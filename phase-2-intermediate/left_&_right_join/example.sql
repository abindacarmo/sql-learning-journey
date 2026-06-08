-- here are the examples

-- number 1
select c.customer_id, o.order_id from customers c left join orders o on c.customer_id=o.order_id;
-- it means Show all customers, and show their order if they have one.

-- number 2
select c.customer_id, o.order_id from customers c right join orders o on c.customer_id=o.order_id;
-- it means show all orders, and show the customer if it matches.