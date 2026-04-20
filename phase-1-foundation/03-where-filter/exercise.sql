/*
in this file we're gonna do the sql assignment for try how understand we are
*/

-- exercise
-- number 1: dissapear all order that their status is "completes"

SELECT * FROM orders WHERE status = 'completed';

-- number 2:
SELECT * FROM products WHERE price > 500;

-- number 3:
SELECT * FROM orders WHERE total_price BETWEEN 300 AND 1000;

-- number 4:
SELECT * FROM customers WHERE city IN(Dili, Jakarta)

-- number 5:
SELECT * FROM orders WHERE total_price IS NULL;

-- number 6:
SELECT * FROM orders WHERE status = 'completed' AND total_price > 1000;

-- number 7:
SELECT * FROM orders WHERE status != 'canceled' AND total_price IS NOT NULL AND order_date BETWEEN '2024-01-31' AND '2024-03-31';








