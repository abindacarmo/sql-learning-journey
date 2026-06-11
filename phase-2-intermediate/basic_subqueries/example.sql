-- here is the examples

-- number 1
select customer_id, product_id, total_price from orders where total_price > (select avg(total_price) from orders);
-- it means Get orders where the total price is above the average price of all orders.

-- number 2
select o.order_id, o.customer_id, o.product_id, o.total_price from orders o where o.customer_id in (select customer_id from customers where city='Dili');
-- it means Get orders where the customer is from Dili.

-- example 3
 select name from customers where customer_id not in (select distinct customer_id from orders);
-- it means Get customers who have never placed an order.