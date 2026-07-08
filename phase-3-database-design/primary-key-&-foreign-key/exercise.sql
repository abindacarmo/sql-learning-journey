-- Here are the examples
-- number 1

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL
); 
-- it means created table called students table, it contain the column student_id as a primary key in that table

-- number 2 

ALTER TABLE orders
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

-- it means add column names fk_customer and it is the foreign-key from table customers

-- number 3 
CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    PRIMARY KEY (student_id, course_id)
);
-- it means create a table enrollments with columns student_id and course_id as primary key, and they are from a different table, and it calls COMPOSITY PRIMARY KEY


-- number 4
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id) ON DELETE CASCADE
);
-- it means create table order contain with order_id which is a primary key or unique column and
-- column customer_id which is from other table called table customers as a foreign key


-- number 5 
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
-- it means create the index for column customer_id in the table orders, so that it easyly to JOIN
