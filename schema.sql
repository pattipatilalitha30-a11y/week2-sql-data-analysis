-- ============================================================================
-- Project: E-Commerce Sales Data Analysis using SQL
-- File: schema.sql
-- Description: DDL script defining tables, keys, and constraints.
-- Dialect: ANSI SQL / SQLite / PostgreSQL / MySQL compatible
-- ============================================================================

-- Drop tables if they already exist to ensure idempotent execution
-- (Drop child tables before parent tables to respect foreign key constraints)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- ----------------------------------------------------------------------------
-- 1. CUSTOMERS TABLE
-- Stores master data for registered customers
-- ----------------------------------------------------------------------------
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name  VARCHAR(50)  NOT NULL,
    last_name   VARCHAR(50)  NOT NULL,
    email       VARCHAR(100) NOT NULL UNIQUE,
    phone       VARCHAR(20),
    city        VARCHAR(50)  NOT NULL,
    state       VARCHAR(50)  NOT NULL,
    country     VARCHAR(50)  NOT NULL DEFAULT 'USA',
    signup_date DATE         NOT NULL
);

-- ----------------------------------------------------------------------------
-- 2. PRODUCTS TABLE
-- Stores product catalog information including category and cost prices
-- ----------------------------------------------------------------------------
CREATE TABLE products (
    product_id   INT PRIMARY KEY,
    product_name VARCHAR(100)   NOT NULL,
    category     VARCHAR(50)    NOT NULL,
    unit_price   DECIMAL(10, 2) NOT NULL CHECK (unit_price >= 0),
    cost_price   DECIMAL(10, 2) NOT NULL CHECK (cost_price >= 0)
);

-- ----------------------------------------------------------------------------
-- 3. ORDERS TABLE
-- Stores order transaction headers linked to customers
-- ----------------------------------------------------------------------------
CREATE TABLE orders (
    order_id     INT PRIMARY KEY,
    customer_id  INT            NOT NULL,
    order_date   DATE           NOT NULL,
    order_status VARCHAR(20)    NOT NULL CHECK (order_status IN ('Completed', 'Pending', 'Shipped', 'Cancelled')),
    shipping_fee DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK (shipping_fee >= 0),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

-- ----------------------------------------------------------------------------
-- 4. ORDER_ITEMS TABLE
-- Stores line-item details per order, linking to products with quantities & discounts
-- ----------------------------------------------------------------------------
CREATE TABLE order_items (
    item_id    INT PRIMARY KEY,
    order_id   INT            NOT NULL,
    product_id INT            NOT NULL,
    quantity   INT            NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price >= 0),
    discount   DECIMAL(4, 2)  NOT NULL DEFAULT 0.00 CHECK (discount >= 0.00 AND discount <= 1.00),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- Create indexes for performance optimization on frequently queried foreign keys
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_order_date ON orders(order_date);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
