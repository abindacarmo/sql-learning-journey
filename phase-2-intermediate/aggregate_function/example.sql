-- example numeber 1.
-- COUNT
select count(*)_price from products;
-- it means Count how many rows are in the products table, and show that number.

-- number 2 
select sum(price) as total_price from products;
-- it means Add up all the values in the price column from the products table, and show the answer as total_price.

-- number 3
select avg(price) as total_price from products;
-- it means Find the average price of all products, and show it with the column name total_price.

-- number 4
select min(price) as total_price from products;
-- it means Find the smallest/lowest price in the products table, and show it with the column name total_price.

-- number 5
select max(price) as total_price from products;
-- it means Find the largest/highest price in the products table, and show it with the column name total_price.