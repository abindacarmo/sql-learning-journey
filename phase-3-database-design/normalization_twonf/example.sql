-- here are the example
-- number 1 
-- this is the incorrect query, its violet the normalization 2NF
CREATE TABLE purchase_items (
    supplier_id INT,
    product_id INT,
    supplier_name VARCHAR(100),
    product_name VARCHAR(100),
    quantity INT,
    PRIMARY KEY (supplier_id, product_id)
);

-- it means the column supplier_name will be depend with supplier_id(it calls partial dependency) and its violet 2NF and the product_name name ass well.

-- number 2 incorrect
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100)
);

CREATE TABLE purchase_items (
    supplier_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (supplier_id, product_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- it means already separate three tables that have respectivetly with its primary key and have relation with foreign key
