-- ================================
-- INSERT SAMPLE DATA
-- ================================

-- first command insert table
-- in this command for insert data to table customers
-- INSERT INTO customers (name, city, email, joined_date) VALUES
-- ('Budi Santoso',   'Jakarta',   'budi@email.com',   '2022-01-15'),
-- ('Ani Lestari',    'Surabaya',  'ani@email.com',    '2022-03-20'),
-- ('João da Silva',  'Dili',      'joao@email.com',   '2023-06-10'),
-- ('Maria Exposto',  'Dili',      'maria@email.com',  '2023-08-05'),
-- ('Tino Gusmão',   'Baucau',    'tino@email.com',   '2024-01-30'),
-- ('Siti Rahma',     'Bandung',   'siti@email.com',   '2024-02-14'),
-- ('Carlos Ximenes', 'Dili',      'carlos@email.com', '2024-03-01');

-- dont forget to comment when you already run some command

-- second command insert table
-- insert into table products
-- INSERT INTO products (product_name, category, price) VALUES
-- ('Laptop Pro 15',    'Electronics', 15000.00),
-- ('Wireless Mouse',   'Electronics',   250.00),
-- ('Mechanical Keyboard', 'Electronics', 500.00),
-- ('Headphone BT',     'Electronics',   800.00),
-- ('Monitor 27"',      'Electronics',  3200.00),
-- ('T-Shirt Basic',    'Fashion',       120.00),
-- ('Denim Jeans',      'Fashion',       300.00),
-- ('Leather Jacket',   'Fashion',       850.00),
-- ('Running Shoes',    'Fashion',       600.00),
-- ('SQL for DE Book',  'Books',         180.00);


-- third command insert table
-- insert data into table orders
INSERT INTO orders (customer_id, product_id, quantity, total_price, status, order_date) VALUES
(1, 1, 1, 15000.00, 'completed', '2024-01-01'),
(2, 2, 2,   500.00, 'completed', '2024-01-02'),
(3, 6, 3,   360.00, 'cancelled', '2024-01-03'),
(1, 3, 1,   500.00, 'pending',   '2024-01-04'),
(4, 4, 1,   800.00, 'completed', '2024-01-05'),
(5, 7, 2,   600.00, 'completed', '2024-01-06'),
(6, 5, 1,  3200.00, 'pending',   '2024-01-07'),
(7, 8, 1,   NULL,   'cancelled', '2024-01-08'),
(3, 10,2,   360.00, 'completed', '2024-02-01'),
(4, 9, 1,   600.00, 'completed', '2024-02-05'),
(5, 1, 1, 15000.00, 'pending',   '2024-02-10'),
(2, 5, 1,  3200.00, 'completed', '2024-02-15');








