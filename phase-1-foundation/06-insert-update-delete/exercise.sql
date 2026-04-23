-- in this file we will do the assignment with DML basic

-- exercise
-- number 1:
-- INSERT INTO customers(customer_id, name, city, email, joined_date) VALUES 
-- (8, 'Dito Carmo', 'Balibar', 'dito@gmail.com', '2026-04-23'),
-- (9, 'Merry Gilda', 'Lutumata', 'merry@gmail.com', '2026-04-23')

-- number 2
-- INSERT INTO orders (customer_id, product_id, quantity, total_price, status, order_date)VALUES
-- (3, 5, 2, 6400, 'pending', CURRENT_DATE);

-- number 3
-- UPDATE orders SET status = 'completed' WHERE status = 'pending' AND order_date < '2024-02-01';

-- number 4
-- UPDATE products SET price = price * 50 WHERE category = 'Electronics';

-- number 5
DELETE FROM orders WHERE status = 'cancelled' AND total_price IS NULL;
