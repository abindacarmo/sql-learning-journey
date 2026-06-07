-- example 

-- number 1
SELECT city, count(email) FROM customers GROUP BY city; 
-- it means For every city in the customers table, show the city name and the number of customer emails in that city.

-- number 2
select customer_id, count(*) from orders group by customer_id;
-- it means For every customer_id in the orders table, show the customer_id and the number of orders for that customer.


-- number 3
select customer_id, count(*) as total_count, sum(total_price) as total_price, avg(total_price) as avg_price from orders group by customer_id;
-- it means Look at the orders table and, for each customer, show their ID, number of orders, total money spent, and average order price.

-- number 4
select customer_id, status, count(*) as total_orders from orders group by customer_id, status order by customer_id;
-- it means Look at the orders table and, for each customer and each order status, show the customer ID, the status, and how many orders have that status.


-- number 5
SELECT customer_id, MIN(total_price) AS smallest_order_price, MAX(total_price) AS largest_order_price FROM orders GROUP BY customer_id;
-- it means Look at the orders table and, for each customer, show the smallest order total and the largest order total.


-- example 6
-- combining GROUP BY and WHERE
select customer_id, count(*) as completed_orders, sum(total_price) as completed_revenue from orders where status = 'completed' group by customer_id order by completed_revenue;

-- it means Look at the orders table, keep only completed orders, and for each customer show their ID, number of completed orders, and total completed revenue, ordered from lowest to highest revenue.
