-- here the examples

-- number 1
 select name, city from customers union select p.product_name, o.status from orders o, products p where o.product_id=p.product_id;
 -- it means Get the product name and order status, by joining the orders and products tables where the product ID matches.


 -- number 2
 select name, city from customers union all select p.product_name, o.status from orders o, products p where o.product_id=p.product_id;
 -- it means Combine both results and keep everything, even if some rows look exactly the same.