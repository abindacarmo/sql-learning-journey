-- exercise number 1
-- number 1:

-- completed data type that most appropriate for this table transaction :

-- CREATE TABLE transactions (
--     transaction_id SERIAL PRIMARY KEY,   
--     customer_name  VARCHAR(100),  
--     amount         NUMERIC,   
--     is_paid         VARCHAR(20),  
--     notes           TEXT,   
--     transaction_date DATE,
--     created_at      TIMESTAMPTZ
-- );

-- number 2
-- CREATE TABLE products (
--     product_id    INT,
--     product_name  VARCHAR(100),
--     -- price         FLOAT, -- ini yang sala
--     price         NUMERIC,
--     is_available  VARCHAR(20),
--     created_at    DATE
-- );

-- number 3
-- CREATE TABLE shipments (
--     id_pengiriman SERIAL PRIMARY KEY,
--     order_id INT REFERENCES products,
--     kurir_name VARCHAR(100),
--     price_pengiriman NUMERIC,
--     status VARCHAR(20),
--     date_pengiriman DATE,
--     date_tiba TIMESTAMPTZ
-- );



