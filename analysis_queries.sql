-- ============================================================================
-- Project: E-Commerce Sales Data Analysis using SQL
-- File: analysis_queries.sql
-- Description: Comprehensive SQL queries demonstrating SELECT, WHERE,
--              GROUP BY, ORDER BY, SUM, AVG, COUNT, JOINs, Subqueries,
--              and CASE statements with business insights.
-- Dialect: ANSI SQL / SQLite / PostgreSQL / MySQL compatible
-- ============================================================================


-- ============================================================================
-- SECTION 1: DATA EXPLORATION & FILTERING (SELECT, WHERE, ORDER BY, LIMIT)
-- ============================================================================

-- Query 1.1: Retrieve all active/completed orders placed after February 1, 2024
-- Concept: SELECT, WHERE, ORDER BY
-- Business Question: Which completed orders were placed from February 2024 onwards?
SELECT 
    order_id,
    customer_id,
    order_date,
    order_status,
    shipping_fee
FROM orders
WHERE order_status = 'Completed' 
  AND order_date >= '2024-02-01'
ORDER BY order_date ASC;

/*
Business Insight:
Filtering for completed transactions after a specific milestone provides a baseline
of fulfilled demand, eliminating noisy cancelled or pending orders.
*/


-- Query 1.2: Identify the top 5 most expensive catalog products
-- Concept: SELECT, ORDER BY, LIMIT
-- Business Question: What are our highest-ticket items and their margin potential?
SELECT 
    product_id,
    product_name,
    category,
    unit_price,
    cost_price,
    ROUND(unit_price - cost_price, 2) AS unit_profit_margin
FROM products
ORDER BY unit_price DESC
LIMIT 5;

/*
Business Insight:
High-ticket items like laptops ($1200) and 4K monitors ($350) deliver significant gross dollar margins
($350 and $110 per unit), making them key drivers for promotional bundling.
*/


-- ============================================================================
-- SECTION 2: EXECUTIVE SUMMARY METRICS (COUNT, SUM, AVG, ROUND)
-- ============================================================================

-- Query 2.1: Key Performance Indicators (KPIs) - Total Sales, Total Orders, Items Sold, and AOV
-- Concept: SUM, COUNT, AVG, ROUND, Multi-table aggregation
-- Business Question: What are the high-level revenue and operational KPIs across all fulfilled orders?
SELECT 
    COUNT(DISTINCT o.order_id) AS total_completed_orders,
    SUM(oi.quantity) AS total_units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2) AS total_product_revenue,
    ROUND(SUM(o.shipping_fee), 2) AS total_shipping_revenue,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) + SUM(DISTINCT o.shipping_fee), 2) AS total_gross_sales,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) / COUNT(DISTINCT o.order_id), 2) AS average_order_value_aov
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status IN ('Completed', 'Shipped');

/*
Business Insight:
The store generates healthy revenue driven by high-value technology items. The Average Order Value (AOV)
serves as a benchmark; marketing initiatives should focus on cross-selling accessories to raise AOV.
*/


-- ============================================================================
-- SECTION 3: GROUPED PERFORMANCE ANALYSIS (GROUP BY, ORDER BY, AGGREGATIONS)
-- ============================================================================

-- Query 3.1: Revenue and Units Sold by Product Category
-- Concept: GROUP BY, SUM, COUNT, ORDER BY
-- Business Question: Which product categories generate the most revenue and sales volume?
SELECT 
    p.category,
    COUNT(DISTINCT o.order_id) AS orders_count,
    SUM(oi.quantity) AS total_units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2) AS category_revenue,
    ROUND(AVG(oi.unit_price), 2) AS avg_unit_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status IN ('Completed', 'Shipped')
GROUP BY p.category
ORDER BY category_revenue DESC;

/*
Business Insight:
Electronics dominates gross revenue due to high unit prices, while Clothing and Books
drive steady transactional frequency. A balanced inventory strategy ensures continuous cash flow.
*/


-- Query 3.2: Product-Level Performance (Revenue, Quantity, and Gross Margin)
-- Concept: GROUP BY, SUM, ROUND, Arithmetic Expressions, ORDER BY
-- Business Question: What are the top revenue-generating individual products and their total profit?
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity) AS total_quantity_sold,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2) AS total_revenue,
    ROUND(SUM(oi.quantity * (oi.unit_price * (1 - oi.discount) - p.cost_price)), 2) AS total_gross_profit
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status IN ('Completed', 'Shipped')
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue DESC;

/*
Business Insight:
The 'Pro Laptop 15-inch' is the flagship product contributing the largest share of both revenue
and gross profit. Protecting inventory levels for this SKU is critical to avoid stockout revenue loss.
*/


-- Query 3.3: Monthly Sales Trend
-- Concept: GROUP BY, SUM, COUNT, Date extraction (strftime/substr), ORDER BY
-- Business Question: How has revenue and order volume evolved month-over-month?
SELECT 
    SUBSTR(o.order_date, 1, 7) AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2) AS monthly_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status IN ('Completed', 'Shipped')
GROUP BY SUBSTR(o.order_date, 1, 7)
ORDER BY sales_month ASC;

/*
Business Insight:
Monthly trend analysis highlights sales trajectory. Consistent volume from Jan through May
demonstrates stable adoption, while promotional campaigns in specific months spike unit sales.
*/


-- ============================================================================
-- SECTION 4: CUSTOMER ANALYSIS & MULTI-TABLE JOINS
-- ============================================================================

-- Query 4.1: Top 10 Customers by Total Spending
-- Concept: Multi-table INNER JOIN, GROUP BY, SUM, ORDER BY, LIMIT
-- Business Question: Who are our 10 most valuable customers in terms of completed purchases?
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.city,
    c.state,
    COUNT(DISTINCT o.order_id) AS total_orders_placed,
    SUM(oi.quantity) AS total_items_purchased,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2) AS total_spending
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status IN ('Completed', 'Shipped')
GROUP BY c.customer_id, customer_name, c.city, c.state
ORDER BY total_spending DESC
LIMIT 10;

/*
Business Insight:
The top customers represent a high concentration of total revenue.
Establishing a VIP loyalty program with personalized offers can improve retention for this cohort.
*/


-- Query 4.2: Customer-wise Spending Summary (All Customers including non-purchasers)
-- Concept: LEFT JOIN, COALESCE, GROUP BY, ORDER BY
-- Business Question: What is the purchase activity for every registered customer?
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    c.city,
    COUNT(DISTINCT o.order_id) AS orders_count,
    COALESCE(ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2), 0.00) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.order_status IN ('Completed', 'Shipped')
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, customer_name, c.email, c.city
ORDER BY total_spent DESC;

/*
Business Insight:
LEFT JOIN enables the identification of all customer behaviors, from power shoppers
to zero-spend registrants, preventing exclusion bias.
*/


-- Query 4.3: Inactive Customers (Registered but Zero Orders)
-- Concept: LEFT JOIN, WHERE ... IS NULL
-- Business Question: Which customers signed up but never completed any purchase?
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    c.city,
    c.signup_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

/*
Business Insight:
Customers like Xavier Charles and Yvonne Strahovski registered but made no purchases.
These users are prime targets for a "first-order welcome discount" email re-engagement campaign.
*/


-- Query 4.4: Complete Order Breakdown (4-Table JOIN)
-- Concept: 4-Table INNER JOIN, Computed columns, ORDER BY
-- Business Question: What are the full itemized details for each order transaction?
SELECT 
    o.order_id,
    o.order_date,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.city,
    p.product_name,
    p.category,
    oi.quantity,
    oi.unit_price,
    oi.discount,
    ROUND(oi.quantity * oi.unit_price * (1 - oi.discount), 2) AS line_total,
    o.order_status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_id ASC, oi.item_id ASC
LIMIT 15;

/*
Business Insight:
Joining customers, orders, line items, and product master files provides an end-to-end
audit trail for finance, customer support, and fulfillment reconciliation.
*/


-- ============================================================================
-- SECTION 5: ADVANCED SUBQUERIES
-- ============================================================================

-- Query 5.1: Customers with Total Spending Above Company Average Customer Spending
-- Concept: Scalar Subquery inside HAVING clause, Nested aggregation
-- Business Question: Which customers have spent more than the average spend across all paying customers?
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2) AS total_spending
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status IN ('Completed', 'Shipped')
GROUP BY c.customer_id, customer_name
HAVING SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) > (
    -- Subquery: Calculates overall average spending per purchasing customer
    SELECT AVG(customer_total)
    FROM (
        SELECT SUM(oi2.quantity * oi2.unit_price * (1 - oi2.discount)) AS customer_total
        FROM orders o2
        JOIN order_items oi2 ON o2.order_id = oi2.order_id
        WHERE o2.order_status IN ('Completed', 'Shipped')
        GROUP BY o2.customer_id
    ) AS customer_spending_subquery
)
ORDER BY total_spending DESC;

/*
Business Insight:
These above-average customers represent the top spending tier. Allocating marketing spend
to retain these customers provides significantly higher ROI than general customer acquisition.
*/


-- Query 5.2: Products Priced Higher Than Their Respective Category Average Price
-- Concept: Correlated Subquery in WHERE clause
-- Business Question: Which individual products carry premium pricing above their category standard?
SELECT 
    p1.product_id,
    p1.product_name,
    p1.category,
    p1.unit_price,
    (
        SELECT ROUND(AVG(p2.unit_price), 2)
        FROM products p2
        WHERE p2.category = p1.category
    ) AS category_avg_price
FROM products p1
WHERE p1.unit_price > (
    SELECT AVG(p2.unit_price)
    FROM products p2
    WHERE p2.category = p1.category
)
ORDER BY p1.category, p1.unit_price DESC;

/*
Business Insight:
Identifies premium offerings in each catalog segment (e.g., Adjustable Dumbbells in Fitness,
Laptop in Electronics). These products have higher margins but may need targeted luxury messaging.
*/


-- Query 5.3: Orders Containing Electronics Items (Subquery with IN operator)
-- Concept: Subquery with IN clause
-- Business Question: Which orders included products from the high-margin Electronics category?
SELECT 
    order_id,
    customer_id,
    order_date,
    order_status
FROM orders
WHERE order_id IN (
    SELECT DISTINCT oi.order_id
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    WHERE p.category = 'Electronics'
)
ORDER BY order_date DESC;

/*
Business Insight:
Isolating orders with electronic purchases helps operations plan fragile shipment packaging
and offers customer service the opportunity to cross-sell electronics warranties.
*/


-- ============================================================================
-- SECTION 6: CONDITIONAL LOGIC (CASE STATEMENTS)
-- ============================================================================

-- Query 6.1: Customer Segmentation by Spending (High / Medium / Low Value)
-- Concept: CASE Statement, Aggregate SUM, GROUP BY, ORDER BY
-- Business Question: How are our customers segmented based on lifetime spending tiers?
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.city,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2) AS total_spending,
    CASE 
        WHEN SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) >= 1000 THEN 'High Value'
        WHEN SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) >= 400 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status IN ('Completed', 'Shipped')
GROUP BY c.customer_id, customer_name, c.city
ORDER BY total_spending DESC;

/*
Business Insight:
Segmenting customers allows CRM teams to tailor messaging:
- High Value (>= $1000): Dedicated account reps, early access to new releases, zero shipping fees.
- Medium Value ($400 - $999): Re-order reminders, threshold discounts ($50 off next $200).
- Low Value (< $400): Broad discount flyers and seasonal sales campaigns.
*/


-- Query 6.2: Distribution of Customers across Value Segments
-- Concept: CASE Statement inside Subquery / GROUP BY
-- Business Question: What percentage and count of our paying customer base falls into each value tier?
SELECT 
    customer_segment,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_spending), 2) AS segment_revenue,
    ROUND(AVG(total_spending), 2) AS avg_segment_spending
FROM (
    SELECT 
        c.customer_id,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS total_spending,
        CASE 
            WHEN SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) >= 1000 THEN 'High Value'
            WHEN SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) >= 400 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_segment
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status IN ('Completed', 'Shipped')
    GROUP BY c.customer_id
) sub
GROUP BY customer_segment
ORDER BY segment_revenue DESC;

/*
Business Insight:
Validates the Pareto principle (80/20 rule): High-value customers drive the overwhelming majority
of total revenue despite making up a smaller fraction of the customer count.
*/


-- Query 6.3: Order Fulfillment Status Summary (Pivoted / Aggregated with CASE)
-- Concept: SUM with conditional CASE WHEN
-- Business Question: What is the distribution and monetary value of orders across each lifecycle status?
SELECT 
    COUNT(*) AS total_all_orders,
    SUM(CASE WHEN order_status = 'Completed' THEN 1 ELSE 0 END) AS completed_orders,
    SUM(CASE WHEN order_status = 'Shipped' THEN 1 ELSE 0 END) AS shipped_orders,
    SUM(CASE WHEN order_status = 'Pending' THEN 1 ELSE 0 END) AS pending_orders,
    SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
    ROUND(100.0 * SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancellation_rate_percentage
FROM orders;

/*
Business Insight:
A cancellation rate under 10% indicates healthy fulfillment operations.
Monitoring cancelled orders identifies potential inventory or payment gateway friction early.
*/


-- ============================================================================
-- SECTION 7: ADDITIONAL BUSINESS & COHORT ANALYSIS
-- ============================================================================

-- Query 7.1: Repeat Purchase Rate (Customers with Multiple Orders)
-- Concept: HAVING COUNT, Subquery calculation
-- Business Question: What proportion of our customers are repeat buyers?
SELECT 
    COUNT(DISTINCT customer_id) AS total_ordering_customers,
    SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    ROUND(100.0 * SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) / COUNT(DISTINCT customer_id), 2) AS repeat_customer_rate_percentage
FROM (
    SELECT 
        customer_id,
        COUNT(order_id) AS order_count
    FROM orders
    WHERE order_status IN ('Completed', 'Shipped')
    GROUP BY customer_id
) order_counts;

/*
Business Insight:
Repeat purchase rate measures customer satisfaction and customer lifetime value (LTV).
A high repeat rate significantly reduces the customer acquisition cost (CAC) burden.
*/


-- Query 7.2: Category Profit Margin Comparison
-- Concept: SUM, ROUND, Arithmetic Margins, GROUP BY
-- Business Question: Which category is most profitable on a percentage margin basis?
SELECT 
    p.category,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 2) AS gross_revenue,
    ROUND(SUM(oi.quantity * p.cost_price), 2) AS cost_of_goods_sold,
    ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) - SUM(oi.quantity * p.cost_price), 2) AS gross_profit,
    ROUND(
        100.0 * (SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) - SUM(oi.quantity * p.cost_price)) 
        / SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 
        2
    ) AS profit_margin_percentage
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status IN ('Completed', 'Shipped')
GROUP BY p.category
ORDER BY profit_margin_percentage DESC;

/*
Business Insight:
While Electronics produces the highest total revenue, Books and Clothing often yield higher
percentage profit margins. Prioritizing mixed basket sales balances both volume and margin health.
*/
