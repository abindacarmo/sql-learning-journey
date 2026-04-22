# SQL Data Types

## Numeric
> Used to store numbers - for prices, quantities, IDs, and metrics in your pipeline.

|Data Type|Description|DE Use Case|
|---------|-----------|-----------|
|``INT``|whole numbers|order_id,quantity,customer_id|
|``BIGINT``|very large whole numbers|row counts in big tables|
|``NUMERIC(10,2)``|Exact decimal|price,total_price,revenue|
|``FLOAT``|Approximate decimal|ratios,percentages|


```sql
CREATE TABLE example_numeric (
    order_id    INT,
    quantity    INT,
    total_price NUMERIC(10,2),
    tax_rate    FLOAT
);
```
DE note: always use ``NUMERIC`` for money/price, not ``FLOAT``. ```FLOAT`` can cause rounding fatal error in finance report.


## Text
> used to store names, categories, statuses, and description.

|Data Type|Description|DE Use Case|
|---------|-----------|-----------|
|``VARCHAR(n)``|Text with max length|name, email, status|
|``TEXT``|Unlimited length text|descriptions, logs, JSON responses|
|``CHAR(n)``|Fixed length text|country codes ('ID', 'TL')|

```sql
CREATE TABLE example_text (
    status       VARCHAR(20),   -- 'completed', 'pending'
    description  TEXT,          -- long product description
    country_code CHAR(2)        -- 'ID', 'TL', 'US'
);
```
DE note: use ``VARCHAR`` for column that long variation. Avoid ``CHAR`` except for remains code like country code.

## Date & Time
> the most important data types in data engineering - almost every pipeline filters and partition by date/time.

|Data Type|Description|DE Use Case|
|---------|-----------|-----------|
|``DATE``|Date only (YYYY-MM-DD)|order_date, hire_date|
|``TIMESTAMP``|Date + time|created_at, updated_at|
|``TIMESTAMPTZ``|Date + time + timezone|event logs, API timestamps|

```sql
CREATE TABLE example_dates (
    order_date   DATE,                      -- '2024-01-01'
    created_at   TIMESTAMP,                 -- '2024-01-01 08:30:00'
    updated_at   TIMESTAMPTZ                -- '2024-01-01 08:30:00+07'
);
```

DE notes: in product pipeline, always use ``TIMESTAMPTZ`` for colomns audit like ``create_At`` and ``update_at`` - so that timezone-aware when data come from different area.

## Boolean
> stores only ``TRUE`` or ``FALSE``. simple but very usefull for flags in pipelines

```sql
CREATE TABLE example_boolean (
    is_active    BOOLEAN,   -- TRUE / FALSE
    is_verified  BOOLEAN
);
```
DE note: in data engineering, boolean often use for flag columns - example ``is_delete`` for soft delete or ``is_processed`` for tracking status pipeline.

### data type in table e-commerce
> now look back for our table that we made before - every columns 
have data types that choise with reasong:

```sql
CREATE TABLE orders (
    order_id    SERIAL          -- auto-increment INT
    customer_id INT,            -- foreign key to customers
    product_id  INT,            -- foreign key to products
    quantity    INT,            -- angka bulat
    total_price NUMERIC(10,2),  -- uang, harus presisi
    status      VARCHAR(20),    -- 'completed', 'pending', 'cancelled'
    order_date  DATE            -- tanggal order
);
```


