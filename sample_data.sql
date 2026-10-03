-- ============================================================================
-- Project: E-Commerce Sales Data Analysis using SQL
-- File: sample_data.sql
-- Description: Realistic sample dataset for e-commerce sales analysis.
-- Includes:
--   - 25 Customers
--   - 15 Products across 5 categories
--   - 40 Orders across 6 months (Jan 2024 - Jun 2024)
--   - 75 Order Items
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. INSERT CUSTOMERS (25 records)
-- Notice: Customers 24 and 25 have never placed an order (for LEFT JOIN tests)
-- ----------------------------------------------------------------------------
INSERT INTO customers (customer_id, first_name, last_name, email, phone, city, state, country, signup_date) VALUES
(1, 'Alice', 'Smith', 'alice.smith@email.com', '555-0101', 'New York', 'NY', 'USA', '2023-08-15'),
(2, 'Bob', 'Jones', 'bob.jones@email.com', '555-0102', 'Los Angeles', 'CA', 'USA', '2023-09-10'),
(3, 'Charlie', 'Brown', 'charlie.brown@email.com', '555-0103', 'Chicago', 'IL', 'USA', '2023-10-05'),
(4, 'Diana', 'Prince', 'diana.prince@email.com', '555-0104', 'Houston', 'TX', 'USA', '2023-11-12'),
(5, 'Evan', 'Wright', 'evan.wright@email.com', '555-0105', 'Phoenix', 'AZ', 'USA', '2023-12-01'),
(6, 'Fiona', 'Gallagher', 'fiona.g@email.com', '555-0106', 'Seattle', 'WA', 'USA', '2024-01-04'),
(7, 'George', 'Clark', 'george.clark@email.com', '555-0107', 'Austin', 'TX', 'USA', '2024-01-15'),
(8, 'Hannah', 'Abbott', 'hannah.a@email.com', '555-0108', 'Denver', 'CO', 'USA', '2024-01-20'),
(9, 'Ian', 'Malcolm', 'ian.malcolm@email.com', '555-0109', 'Boston', 'MA', 'USA', '2024-01-28'),
(10, 'Julia', 'Roberts', 'julia.r@email.com', '555-0110', 'San Francisco', 'CA', 'USA', '2024-02-02'),
(11, 'Kevin', 'Bacon', 'kevin.bacon@email.com', '555-0111', 'Miami', 'FL', 'USA', '2024-02-10'),
(12, 'Laura', 'Croft', 'laura.croft@email.com', '555-0112', 'San Diego', 'CA', 'USA', '2024-02-14'),
(13, 'Michael', 'Scott', 'michael.scott@email.com', '555-0113', 'Scranton', 'PA', 'USA', '2024-02-22'),
(14, 'Nancy', 'Drew', 'nancy.drew@email.com', '555-0114', 'Portland', 'OR', 'USA', '2024-03-01'),
(15, 'Oscar', 'Martinez', 'oscar.m@email.com', '555-0115', 'Dallas', 'TX', 'USA', '2024-03-08'),
(16, 'Pam', 'Beesly', 'pam.b@email.com', '555-0116', 'Philadelphia', 'PA', 'USA', '2024-03-12'),
(17, 'Quinn', 'Fabray', 'quinn.f@email.com', '555-0117', 'Atlanta', 'GA', 'USA', '2024-03-20'),
(18, 'Ryan', 'Howard', 'ryan.h@email.com', '555-0118', 'Detroit', 'MI', 'USA', '2024-03-25'),
(19, 'Sarah', 'Connor', 'sarah.c@email.com', '555-0119', 'Las Vegas', 'NV', 'USA', '2024-04-02'),
(20, 'Thomas', 'Anderson', 'thomas.a@email.com', '555-0120', 'Orlando', 'FL', 'USA', '2024-04-10'),
(21, 'Uma', 'Thurman', 'uma.t@email.com', '555-0121', 'Nashville', 'TN', 'USA', '2024-04-18'),
(22, 'Victor', 'Stone', 'victor.s@email.com', '555-0122', 'Charlotte', 'NC', 'USA', '2024-04-25'),
(23, 'Wendy', 'Darling', 'wendy.d@email.com', '555-0123', 'Minneapolis', 'MN', 'USA', '2024-05-02'),
(24, 'Xavier', 'Charles', 'xavier.c@email.com', '555-0124', 'Salt Lake City', 'UT', 'USA', '2024-05-10'),
(25, 'Yvonne', 'Strahovski', 'yvonne.s@email.com', '555-0125', 'Raleigh', 'NC', 'USA', '2024-05-15');

-- ----------------------------------------------------------------------------
-- 2. INSERT PRODUCTS (15 records)
-- Covers 5 categories: Electronics, Clothing, Home & Kitchen, Books, Fitness
-- ----------------------------------------------------------------------------
INSERT INTO products (product_id, product_name, category, unit_price, cost_price) VALUES
(101, 'Pro Laptop 15-inch', 'Electronics', 1200.00, 850.00),
(102, 'Wireless Noise-Canceling Headphones', 'Electronics', 180.00, 110.00),
(103, 'Ultra-Slim Mechanical Keyboard', 'Electronics', 95.00, 55.00),
(104, '27-inch 4K UHD Monitor', 'Electronics', 350.00, 240.00),
(105, 'Classic Denim Jacket', 'Clothing', 85.00, 40.00),
(106, 'Cotton Crewneck T-Shirt (3-Pack)', 'Clothing', 35.00, 15.00),
(107, 'Performance Running Shoes', 'Clothing', 120.00, 65.00),
(108, 'Stainless Steel Cookware Set', 'Home & Kitchen', 220.00, 130.00),
(109, 'Espresso Coffee Machine', 'Home & Kitchen', 160.00, 95.00),
(110, 'HEPA Air Purifier', 'Home & Kitchen', 130.00, 80.00),
(111, 'SQL for Data Analysis Handbook', 'Books', 45.00, 18.00),
(112, 'Python Data Science Practical Guide', 'Books', 50.00, 20.00),
(113, 'High-Density Non-Slip Yoga Mat', 'Fitness', 40.00, 18.00),
(114, 'Adjustable Dumbbells Set (50 lbs)', 'Fitness', 250.00, 160.00),
(115, 'Smart Fitness Tracker Watch', 'Fitness', 90.00, 50.00);

-- ----------------------------------------------------------------------------
-- 3. INSERT ORDERS (40 records)
-- Spans Jan 2024 to Jun 2024 with various order statuses
-- ----------------------------------------------------------------------------
INSERT INTO orders (order_id, customer_id, order_date, order_status, shipping_fee) VALUES
(1001, 1, '2024-01-05', 'Completed', 15.00),
(1002, 2, '2024-01-08', 'Completed', 0.00),
(1003, 3, '2024-01-12', 'Completed', 10.00),
(1004, 4, '2024-01-15', 'Completed', 20.00),
(1005, 5, '2024-01-20', 'Cancelled', 10.00),
(1006, 1, '2024-01-25', 'Completed', 0.00),
(1007, 6, '2024-01-28', 'Completed', 15.00),
(1008, 7, '2024-02-02', 'Completed', 0.00),
(1009, 8, '2024-02-05', 'Completed', 10.00),
(1010, 9, '2024-02-10', 'Completed', 15.00),
(1011, 2, '2024-02-14', 'Completed', 0.00),
(1012, 10, '2024-02-18', 'Completed', 20.00),
(1013, 11, '2024-02-22', 'Cancelled', 10.00),
(1014, 12, '2024-02-27', 'Completed', 0.00),
(1015, 3, '2024-03-02', 'Completed', 10.00),
(1016, 13, '2024-03-06', 'Completed', 15.00),
(1017, 14, '2024-03-10', 'Completed', 0.00),
(1018, 15, '2024-03-14', 'Completed', 20.00),
(1019, 16, '2024-03-18', 'Completed', 10.00),
(1020, 4, '2024-03-22', 'Completed', 15.00),
(1021, 1, '2024-03-28', 'Completed', 0.00),
(1022, 17, '2024-04-03', 'Completed', 10.00),
(1023, 18, '2024-04-07', 'Completed', 15.00),
(1024, 7, '2024-04-12', 'Completed', 0.00),
(1025, 19, '2024-04-16', 'Completed', 20.00),
(1026, 20, '2024-04-20', 'Cancelled', 0.00),
(1027, 2, '2024-04-25', 'Completed', 15.00),
(1028, 21, '2024-04-29', 'Completed', 10.00),
(1029, 6, '2024-05-03', 'Completed', 0.00),
(1030, 22, '2024-05-08', 'Completed', 15.00),
(1031, 8, '2024-05-12', 'Completed', 10.00),
(1032, 23, '2024-05-16', 'Completed', 0.00),
(1033, 10, '2024-05-20', 'Completed', 20.00),
(1034, 12, '2024-05-25', 'Completed', 15.00),
(1035, 1, '2024-06-01', 'Completed', 0.00),
(1036, 14, '2024-06-05', 'Shipped', 10.00),
(1037, 16, '2024-06-10', 'Shipped', 15.00),
(1038, 3, '2024-06-15', 'Shipped', 0.00),
(1039, 9, '2024-06-20', 'Pending', 10.00),
(1040, 17, '2024-06-25', 'Pending', 15.00);

-- ----------------------------------------------------------------------------
-- 4. INSERT ORDER_ITEMS (75 records)
-- Line items with products, quantities, prices, and discounts
-- ----------------------------------------------------------------------------
INSERT INTO order_items (item_id, order_id, product_id, quantity, unit_price, discount) VALUES
(1, 1001, 101, 1, 1200.00, 0.05),
(2, 1001, 103, 1, 95.00, 0.00),
(3, 1002, 102, 2, 180.00, 0.10),
(4, 1002, 106, 1, 35.00, 0.00),
(5, 1003, 105, 1, 85.00, 0.00),
(6, 1003, 111, 2, 45.00, 0.00),
(7, 1004, 108, 1, 220.00, 0.05),
(8, 1004, 109, 1, 160.00, 0.00),
(9, 1005, 107, 1, 120.00, 0.00),
(10, 1006, 104, 1, 350.00, 0.10),
(11, 1006, 112, 1, 50.00, 0.00),
(12, 1007, 114, 1, 250.00, 0.05),
(13, 1007, 113, 1, 40.00, 0.00),
(14, 1008, 101, 1, 1200.00, 0.00),
(15, 1009, 106, 2, 35.00, 0.00),
(16, 1009, 115, 1, 90.00, 0.05),
(17, 1010, 108, 1, 220.00, 0.00),
(18, 1010, 110, 1, 130.00, 0.10),
(19, 1011, 107, 2, 120.00, 0.00),
(20, 1011, 105, 1, 85.00, 0.05),
(21, 1012, 101, 1, 1200.00, 0.05),
(22, 1012, 102, 1, 180.00, 0.00),
(23, 1012, 103, 1, 95.00, 0.00),
(24, 1013, 114, 1, 250.00, 0.00),
(25, 1014, 109, 1, 160.00, 0.00),
(26, 1014, 113, 2, 40.00, 0.00),
(27, 1015, 102, 1, 180.00, 0.00),
(28, 1015, 104, 1, 350.00, 0.05),
(29, 1016, 105, 2, 85.00, 0.10),
(30, 1016, 106, 2, 35.00, 0.00),
(31, 1017, 111, 1, 45.00, 0.00),
(32, 1017, 112, 1, 50.00, 0.00),
(33, 1018, 108, 1, 220.00, 0.00),
(34, 1018, 110, 1, 130.00, 0.05),
(35, 1019, 115, 2, 90.00, 0.00),
(36, 1019, 113, 1, 40.00, 0.00),
(37, 1020, 101, 1, 1200.00, 0.10),
(38, 1021, 102, 1, 180.00, 0.00),
(39, 1021, 106, 3, 35.00, 0.05),
(40, 1022, 107, 1, 120.00, 0.00),
(41, 1022, 103, 1, 95.00, 0.00),
(42, 1023, 109, 1, 160.00, 0.05),
(43, 1023, 111, 2, 45.00, 0.00),
(44, 1024, 104, 1, 350.00, 0.00),
(45, 1024, 103, 1, 95.00, 0.00),
(46, 1025, 114, 1, 250.00, 0.10),
(47, 1025, 115, 1, 90.00, 0.00),
(48, 1026, 108, 1, 220.00, 0.00),
(49, 1027, 101, 1, 1200.00, 0.05),
(50, 1027, 104, 1, 350.00, 0.00),
(51, 1028, 105, 1, 85.00, 0.00),
(52, 1028, 107, 1, 120.00, 0.05),
(53, 1029, 102, 1, 180.00, 0.00),
(54, 1029, 110, 1, 130.00, 0.00),
(55, 1030, 106, 2, 35.00, 0.00),
(56, 1030, 113, 2, 40.00, 0.00),
(57, 1031, 109, 1, 160.00, 0.00),
(58, 1031, 112, 2, 50.00, 0.05),
(59, 1032, 114, 1, 250.00, 0.00),
(60, 1032, 115, 1, 90.00, 0.00),
(61, 1033, 101, 1, 1200.00, 0.00),
(62, 1033, 104, 1, 350.00, 0.05),
(63, 1034, 108, 1, 220.00, 0.10),
(64, 1034, 105, 1, 85.00, 0.00),
(65, 1035, 103, 2, 95.00, 0.00),
(66, 1035, 111, 1, 45.00, 0.00),
(67, 1036, 102, 1, 180.00, 0.05),
(68, 1036, 107, 1, 120.00, 0.00),
(69, 1037, 104, 1, 350.00, 0.00),
(70, 1037, 106, 2, 35.00, 0.00),
(71, 1038, 110, 1, 130.00, 0.00),
(72, 1038, 114, 1, 250.00, 0.05),
(73, 1039, 101, 1, 1200.00, 0.05),
(74, 1040, 109, 1, 160.00, 0.00),
(75, 1040, 115, 1, 90.00, 0.00);
