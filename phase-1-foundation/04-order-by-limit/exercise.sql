-- in this file we use our dataset e-commerce before for do the assignment

-- exercise
-- number 1:

SELECT * FROM products ORDER BY price ASC;

-- number 2:
SELECT * FROM orders ORDER BY order_date DESC LIMIT 3;

-- number 3:
SELECT * FROM orders WHERE status = 'completed' ORDER BY total_price DESC LIMIT 5;

-- number 4
SELECT * FROM orders WHERE status != 'cancelled' AND total_price IS NOT NULL ORDER BY order_date DESC LIMIT 1;