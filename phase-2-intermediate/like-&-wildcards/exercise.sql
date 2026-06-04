-- here the example of like & wildcards

-- number 1
SELECT * FROM customers WHERE name like '%o'; -- it will show the customer who names end with o

-- number 2
SELECT product_name FROM products WHERE product_name NOT LIKE '___________'; -- Names NOT Having Exactly 10 Characters

