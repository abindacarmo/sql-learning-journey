# INSERT, UPDATE & DELETE

## what is DML?
> DML(Data Manipulation Language) is as set of SQL commands used to add, modify and delete data inside the table. In data engineering, DML is used heavily in ETL pipelines - inserting new data, updating records, and cleaning bad data.

> here we are gonna learn about basic DML, we use three command for manipulating data which is stored in the tables.and the three command is:
> - ``INSERT`` : to add new data or row in the tables.
> - ``UPDATE`` : for edit data that already exist.
> - ``DELETE`` : for delete data from the table.

## INSERT - add new data
> ``INSERT`` adds new rows into a table.

> sintax

```sql
INSERT INTO table_name (column1, column2, ...)
VALUES (value1, value2, ...);
```
> single row

```sql
-- Insert one new customer
INSERT INTO customers (name, city, email, joined_date)
VALUES ('Ana Soares', 'Dili', 'ana@email.com', '2024-03-15');
```
> multiple row

```sql
-- Insert multiple products at once (lebih efisien di pipeline!)
INSERT INTO products (product_name, category, price)
VALUES 
    ('Smartwatch',    'Electronics', 1200.00),
    ('Backpack',      'Fashion',      450.00),
    ('Python Book',   'Books',        220.00);
```

DE notes: In pipeline ETL, insert multiplie rows at the same time more better efficient than insert one by one. it is called batch insert - save connection and time execution.

## UPDATE - modify existing data
> ``UPDATE`` modifies existing data in a table. Always use ``WHERE`` with UPDATE - without it, every row in the table will be updated!

> sintax

```sql
UPDATE table_name
SET column1 = value1, column2 = value2
WHERE condition;
```

> update multiple columns

```sql
-- Update price and category of a product
UPDATE products
SET price    = 270.00,
    category = 'Electronics'
WHERE product_id = 2;
```

> updating with calculating

```sql
-- Give 10% discount to all Fashion products
UPDATE products
SET price = price * 0.90
WHERE category = 'Fashion';
```

⚠️ WARNING: never executing this without WHERE!

```sql
-- BERBAHAYA! Semua order jadi completed!
UPDATE orders SET status = 'completed';
```

## DELETE
> ``DELETE`` removes rows from a table. Just like UPDATE, always use ``WHERE`` - without it, all data in the table will be deleted

> sintax

```sql
DELETE FROM table_name
WHERE condition;
```

> delete specific row

```sql
-- Delete cancelled orders
DELETE FROM orders
WHERE status = 'cancelled';
```

> delete with multiple condition:

```sql 
-- Delete old orders with NULL total_price
DELETE FROM orders
WHERE total_price IS NULL
  AND order_date < '2024-02-01';
```
⚠️ WARNING: never execute this witout WHERE!

```sql
-- BERBAHAYA! Semua data orders terhapus!
DELETE FROM orders;
```

### Real Pipeline Use Case
> In a real ETL pipeline, INSERT + UPDATE + DELETE are combined in a pettern called Upsert - Insert if new, update if already exist. This is Extremely common in data engineering

```sql
-- Step 1: Insert new orders from today
INSERT INTO orders (customer_id, product_id, quantity, total_price, status, order_date)
SELECT customer_id, product_id, quantity, total_price, status, order_date
FROM raw.orders
WHERE order_date = CURRENT_DATE;

-- Step 2: Update status for existing orders
UPDATE orders
SET status = 'completed'
WHERE status = 'pending'
  AND order_date < CURRENT_DATE;

-- Step 3: Delete bad data (NULL price + cancelled)
DELETE FROM orders
WHERE total_price IS NULL
  AND status = 'cancelled';
```













