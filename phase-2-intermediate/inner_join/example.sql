-- here is the examples of inner join

-- number 1
select  c.customer_id, c.city,o.total_price, o.order_date from customers c inner join orders o on o.customer_id=c.customer_id;
-- it means shows each customer’s ID and city together with their order total price and order date, matching customers to their orders where both have the same customer_id.

-- number 2
select c.customer_id, count(o.order_id) as total_orders, sum(o.total_price) as total_spent from orders o inner join customers c on o.customer_id=c.customer_id group by c.customer_id order by total_spent desc;
-- it means ists each customer, counts how many orders they made, totals how much they spent, groups the results by customer, and sorts the biggest spenders first.

-- number 3
select c.customer_id, o.product_id, o.total_price from customers c inner join orders o on c.customer_id=o.customer_id inner join products p on p.product_id=o.product_id where c.city = 'Dili' order by o.total_price desc;
-- it means shows products ordered by customers from Dili, including the customer ID, product ID, and total price, sorted from highest to lowest price.