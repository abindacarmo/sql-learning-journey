-- here is the examples

-- number 1
 select c.name, c.city, o.product_id, o.total_price from customers c full outer join orders o on c.customer_id=o.customer_id;
 -- it means Show all customers and all orders, matching them when the customer ID is the same.

 -- number 2
 select c.name, c.city, o.product_id, o.total_price from customers c full outer join orders o on c.customer_id=o.customer_id where c.customer_id is null or o.order_id is null;
 -- it means Show customers without orders, and orders without matching customers.