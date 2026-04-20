-- ================================
-- E-COMMERCE DATABASE SETUP
-- SQL Learning Journey
-- ================================

-- in this practice we will use postgresql and E-commerce database
-- and don't forgat once you run one of the command sql dont forget to comment others.

-- 1. First command 
-- use  sudo -u postgres psql -d aprende_db -f practice.sql this command to run in your terminal
-- Create customers table
-- CREATE TABLE customers (
--     customer_id SERIAL PRIMARY KEY,
--     name        VARCHAR(100),
--     city        VARCHAR(100),
--     email       VARCHAR(150),
--     joined_date DATE
-- );

-- 2. second command
-- Create products table
-- CREATE TABLE products (
--     product_id   SERIAL PRIMARY KEY,
--     product_name VARCHAR(100),
--     category     VARCHAR(50),
--     price        NUMERIC(10,2)
-- );

-- 3. third command
-- Create orders table
-- CREATE TABLE orders (
--     order_id    SERIAL PRIMARY KEY,
--     customer_id INT REFERENCES customers(customer_id),
--     product_id  INT REFERENCES products(product_id),
--     quantity    INT,
--     total_price NUMERIC(10,2),
--     status      VARCHAR(20),
--     order_date  DATE
-- );















