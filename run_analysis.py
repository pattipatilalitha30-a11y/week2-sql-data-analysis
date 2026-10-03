#!/usr/bin/env python3
"""
Test and Execution Runner for Week 2 SQL Data Analysis Project
Loads schema.sql, sample_data.sql into an SQLite database (results/ecommerce.db),
executes all analytical queries in analysis_queries.sql, prints tabular results,
and writes comprehensive output reports into results/query_outputs.md.
"""

import os
import re
import sqlite3
import sys

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
SCHEMA_FILE = os.path.join(BASE_DIR, "schema.sql")
DATA_FILE = os.path.join(BASE_DIR, "sample_data.sql")
QUERIES_FILE = os.path.join(BASE_DIR, "analysis_queries.sql")
RESULTS_DIR = os.path.join(BASE_DIR, "results")
DB_FILE = os.path.join(RESULTS_DIR, "ecommerce.db")
MD_OUTPUT = os.path.join(RESULTS_DIR, "query_outputs.md")
TXT_OUTPUT = os.path.join(RESULTS_DIR, "query_outputs.txt")


def setup_database():
    os.makedirs(RESULTS_DIR, exist_ok=True)
    if os.path.exists(DB_FILE):
        os.remove(DB_FILE)

    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()

    print("[*] Creating database schema from schema.sql...")
    with open(SCHEMA_FILE, "r", encoding="utf-8") as f:
        schema_sql = f.read()
    cursor.executescript(schema_sql)

    print("[*] Populating sample data from sample_data.sql...")
    with open(DATA_FILE, "r", encoding="utf-8") as f:
        data_sql = f.read()
    cursor.executescript(data_sql)

    conn.commit()
    print("[+] Database initialized successfully.")
    return conn


def extract_queries_with_metadata(sql_content):
    """
    Parses queries along with comments, query titles, and business insights.
    """
    blocks = sql_content.split("-- ============================================================================")
    parsed_queries = []

    # Regex patterns for extracting metadata
    query_id_pattern = re.compile(r"--\s*(Query\s+[0-9\.]+:.*?)(?:\n|$)", re.IGNORECASE)
    concept_pattern = re.compile(r"--\s*Concept:\s*(.*?)(?:\n|$)", re.IGNORECASE)
    question_pattern = re.compile(r"--\s*Business Question:\s*(.*?)(?:\n|$)", re.IGNORECASE)
    insight_pattern = re.compile(r"/\*\s*Business Insight:(.*?)\*/", re.DOTALL | re.IGNORECASE)

    # Split by standard query comments starting with "-- Query"
    raw_sections = re.split(r"(?=--\s*Query\s+[0-9\.]+)", sql_content)
    for raw in raw_sections:
        if not raw.strip() or not raw.strip().startswith("-- Query"):
            continue

        q_id_match = query_id_pattern.search(raw)
        title = q_id_match.group(1).strip() if q_id_match else "SQL Query"

        concept_match = concept_pattern.search(raw)
        concept = concept_match.group(1).strip() if concept_match else ""

        question_match = question_pattern.search(raw)
        question = question_match.group(1).strip() if question_match else ""

        insight_match = insight_pattern.search(raw)
        insight = insight_match.group(1).strip() if insight_match else ""

        # Extract SQL: between the comment header and the insight comment
        # Remove insight block
        cleaned = re.sub(r"/\*.*?\*/", "", raw, flags=re.DOTALL)
        # Extract SQL statement (starts with SELECT, WITH, etc.)
        lines = []
        for line in cleaned.splitlines():
            line_s = line.strip()
            if line_s.startswith("--"):
                continue
            lines.append(line)
        sql = "\n".join(lines).strip()
        if sql.endswith(";"):
            sql = sql[:-1].strip()

        if sql:
            parsed_queries.append({
                "title": title,
                "concept": concept,
                "question": question,
                "insight": insight,
                "sql": sql
            })

    return parsed_queries


def format_table(headers, rows):
    """Format tabular data into GitHub-flavored Markdown table"""
    if not rows:
        return "_No records returned._"
    col_widths = [len(str(h)) for h in headers]
    for row in rows:
        for idx, val in enumerate(row):
            col_widths[idx] = max(col_widths[idx], len(str(val) if val is not None else "NULL"))

    header_line = "| " + " | ".join(f"{str(h):<{col_widths[i]}}" for i, h in enumerate(headers)) + " |"
    separator_line = "|-" + "-|-".join("-" * col_widths[i] for i in range(len(headers))) + "-|"
    data_lines = []
    for row in rows:
        data_lines.append("| " + " | ".join(f"{str(val if val is not None else 'NULL'):<{col_widths[i]}}" for i, val in enumerate(row)) + " |")

    return "\n".join([header_line, separator_line] + data_lines)


def run_tests():
    conn = setup_database()
    cursor = conn.cursor()

    with open(QUERIES_FILE, "r", encoding="utf-8") as f:
        sql_content = f.read()

    queries = extract_queries_with_metadata(sql_content)
    print(f"[*] Found {len(queries)} analytical queries to verify.")

    md_lines = [
        "# E-Commerce Sales Data Analysis - Query Execution Results",
        "",
        "> Automated Execution Report generated from `analysis_queries.sql` against the sample database.",
        "",
        "---",
        ""
    ]

    txt_lines = [
        "=" * 80,
        "E-COMMERCE SALES DATA ANALYSIS - QUERY EXECUTION RESULTS",
        "=" * 80,
        ""
    ]

    passed = 0
    failed = 0

    for idx, q in enumerate(queries, 1):
        print(f"\n[{idx}/{len(queries)}] Testing: {q['title']}...")
        print(f"    Concepts: {q['concept']}")
        try:
            cursor.execute(q['sql'])
            rows = cursor.fetchall()
            headers = [desc[0] for desc in cursor.description] if cursor.description else []
            passed += 1
            print(f"    [PASS] Returned {len(rows)} row(s).")

            # Markdown report block
            md_lines.append(f"### {q['title']}")
            if q['concept']:
                md_lines.append(f"**Concepts:** `{q['concept']}`  ")
            if q['question']:
                md_lines.append(f"**Business Question:** *{q['question']}*  ")
            md_lines.append("")
            md_lines.append("```sql")
            md_lines.append(q['sql'] + ";")
            md_lines.append("```")
            md_lines.append("")
            md_lines.append("**Query Result:**")
            md_lines.append("")
            md_lines.append(format_table(headers, rows))
            md_lines.append("")
            if q['insight']:
                md_lines.append("> [!TIP]")
                md_lines.append(f"> **Business Insight:** {q['insight']}")
            md_lines.append("")
            md_lines.append("---")
            md_lines.append("")

            # Plain text report block
            txt_lines.append(f"Query {idx}: {q['title']}")
            txt_lines.append(f"Concepts: {q['concept']}")
            txt_lines.append(f"Question: {q['question']}")
            txt_lines.append("-" * 60)
            txt_lines.append(q['sql'] + ";")
            txt_lines.append("-" * 60)
            txt_lines.append(f"Rows returned: {len(rows)}")
            txt_lines.append(format_table(headers, rows))
            if q['insight']:
                txt_lines.append(f"Insight: {q['insight']}")
            txt_lines.append("\n" + "=" * 80 + "\n")

        except Exception as e:
            failed += 1
            print(f"    [FAIL] Error executing query: {e}")
            md_lines.append(f"### {q['title']} - [EXECUTION FAILED]")
            md_lines.append(f"```text\n{str(e)}\n```")
            txt_lines.append(f"Query {idx} FAILED: {str(e)}")

    with open(MD_OUTPUT, "w", encoding="utf-8") as f:
        f.write("\n".join(md_lines))

    with open(TXT_OUTPUT, "w", encoding="utf-8") as f:
        f.write("\n".join(txt_lines))

    print("\n" + "=" * 50)
    print(f"Verification Summary: {passed} passed, {failed} failed out of {len(queries)} queries.")
    print(f"Markdown Results saved to: {MD_OUTPUT}")
    print(f"Text Results saved to:     {TXT_OUTPUT}")
    print(f"Database saved to:         {DB_FILE}")
    print("=" * 50)

    conn.close()
    if failed > 0:
        sys.exit(1)


if __name__ == "__main__":
    run_tests()
