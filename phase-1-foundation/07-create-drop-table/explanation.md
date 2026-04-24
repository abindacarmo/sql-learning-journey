# CREATE & DROP TABLE

## Create Table
> ``CREATE TABLE`` is used to define and create a new table in the database. In data engineering, you create tables constantly - for raw data, staging layers, and final warehouse tables.

> sintax
```sql
CREATE TABLE table_name (
    column1 datatype,
    column2 datatype,
    column3 datatype
);
```
> example
```sql
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name        VARCHAR(100),
    city        VARCHAR(100),
    email       VARCHAR(150),
    joined_date DATE
);
```

## CREATE TABLE IF NOT EXISTS
> Adding ``IF NOT EXISTS`` prevents an error if the table already exists. This is a **must-have** in data engineering pipelines - your pipeline might run multiple times, and you dont want it to crash because the tables already exist.

```sql
-- Safe to run multiple times!
CREATE TABLE IF NOT EXISTS customers (
    customer_id SERIAL PRIMARY KEY,
    name        VARCHAR(100),
    city        VARCHAR(100),
    email       VARCHAR(150),
    joined_date DATE
);
```

## CREATE TABLE AS
> You can create a new table directly from a ``SELECT`` query. Very common in data engineering for creating **staging tables** or **summary tables**.

```sql
-- Create a summary table of completed orders only
CREATE TABLE completed_orders AS
SELECT 
    order_id,
    customer_id,
    total_price,
    order_date
FROM orders
WHERE status = 'completed';
```
DE Note: this pattern always in dbt for do the staging models - get data from raw layer, filter, and then save into new layer.


## DROP TABLE
> ``DROP TABLE`` completely removes a table and all its data from the database. this is permanent and cannot be undone

```sql
-- Delete a table permanently
DROP TABLE completed_orders;
```

> safety with IF EXISTS:
```sql
-- Only drop if the table exists — no error if it doesn't!
DROP TABLE IF EXISTS completed_orders;
```
⚠️ WARNING: ``DROP TABLE`` remove the table include all permanently. in production, always you have bacup before DROP.


# TRUNCATE 
> ``TRUNCATE`` deletes all data inside a table but keeps the table structure. Faster than ``DELETE``for clearing large in pipelines.

```sql
-- Clear all data but keep the table
TRUNCATE TABLE orders;
```

|Command|Delete data|delete table|can rollback|
|-------|-----------|------------|------------|
|``DELETE``|✅ (per raw)|❌|✅|
|``TRUNCATE``|✅ (all)|❌|❌|
|``DROP``|✅ (all)|✅|❌|

> real pipeline Use Case

```sql
-- Pattern umum di ETL pipeline:

-- Step 1: Drop staging table if exists from last run
DROP TABLE IF EXISTS staging_orders;

-- Step 2: Create fresh staging table from raw data
CREATE TABLE staging_orders AS
SELECT
    order_id,
    customer_id,
    total_price,
    status,
    order_date
FROM raw.orders
WHERE order_date = CURRENT_DATE
  AND total_price IS NOT NULL;

-- Step 3: Verify data loaded correctly
SELECT COUNT(*) FROM staging_orders;
```



