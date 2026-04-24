-- file ida ne'e exercicio
--exercicio:

-- numeru 1 and 2:

-- CREATE TABLE IF NOT EXISTS shipments (shipment_id SERIAL PRIMARY KEY, order_id INT, courier_name VARCHAR(50), shipping_cost NUMERIC, is_delivered BOOLEAN, shiped_date DATE, arrived_at TIMESTAMPTZ )

-- number 3
-- CREATE TABLE high_value_orders AS
-- SELECT * FROM orders WHERE total_price > 1000 AND status = 'completed';

-- number 4
-- DROP TABLE IF EXISTS high_value_orders;

-- -- number 5 
-- part 1
-- DROP TABLE IF EXISTS staging_orders;

-- part 2
-- CREATE TABLE staging_orders AS
-- SELECT * FROM orders WHERE status != 'cancelled';

-- part 3
SELECT COUNT(*) FROM staging_orders;