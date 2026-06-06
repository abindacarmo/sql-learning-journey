-- examples

-- number 1
select customer_id, count(*) from orders group by customer_id having count(*) >= 2;
-- it means shows each customer_id that has 2 or more orders, along with the number of orders they made.

-- number 2
select customer_id, sum(total_price) as total_price from orders group by customer_id having sum(total_price) >= 800;
-- it means It shows each customer_id whose total spending is 800 or more, along with the total amount they spent.

-- number 3
select customer_id, count(*) as completed_orders, sum(total_price) as total_spent from orders where status='completed' group by customer_id having count(*) >= 2 order by total_spent desc;
-- it means shows customers who have 2 or more completed orders, along with their number of completed orders and total money spent, sorted from highest spender to lowest.

-- number 4
select customer_id, min(total_price) as smallest_price, max(total_price) as largest_price from orders group by customer_id having min(total_price) >= 800;
-- it means It shows each customer whose smallest order price is 800 or more, along with their smallest and largest order prices.

