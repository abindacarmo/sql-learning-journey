# WHERE & FILTER DATA

> ``WHERE`` is used to filter rows based on a condition. Without ``WHERE``, your query returns all rows in the table. In data engineering, filtering is critical - you don't want to process millions of unnecessary rows in your pipeline, as it wastes compute resources and slows everything down.

> Table: orders

| order_id | customer_id | product   | category    | amount | status    | order_date |
|----------|-------------|-----------|-------------|--------|-----------|------------|
| 1        | 101         | Laptop    | Electronics | 15000  | completed | 2024-01-01 |
| 2        | 102         | Mouse     | Electronics | 250    | completed | 2024-01-02 |
| 3        | 103         | T-Shirt   | Fashion     | 120    | cancelled | 2024-01-03 |
| 4        | 101         | Keyboard  | Electronics | 500    | pending   | 2024-01-04 |
| 5        | 104         | Headphone | Electronics | 800    | completed | 2024-01-05 |
| 6        | 105         | Jeans     | Fashion     | 300    | completed | 2024-01-06 |
| 7        | 106         | Monitor   | Electronics | 3200   | pending   | 2024-01-07 |
| 8        | 107         | Jacket    | Fashion     | NULL   | cancelled | 2024-01-08 |


##  Basic Comparison Operators

> These are the most common operators used with ``WHERE``:

|Operator|Meaning|signifikadu|
|---------|-------|----------|
|``=``|Equal to|Igual ba|
|``!=`` or ``<>``|Not equal to|La igual ba|
|``>``|Greater than|Boot liu|
|``<``|Less than|Ki'ik liu|
|``>=``|Greater than or equal|Boot liu ka igual|
|``<=``|Less than or equal|Ki'ik liu ka igual|

```sql
-- Get only completed orders
-- Hetan ordem ne'ebé kompletu de'it
SELECT *
FROM orders
WHERE status = 'completed';
```

> Result

| order_id | product | amount | status    |
|----------|---------|--------|-----------|
| 1        | Laptop  | 15000  | completed |
| 7        | Monitor | 3200   | pending   |


```sql
-- Get orders with amount greater than 1000
-- Hetan ordem ho montante boot liu 1000
SELECT *
FROM orders
WHERE amount > 1000;
```
> Result

| order_id | product | amount | status    |
|----------|---------|--------|-----------|
| 1        | Laptop  | 15000  | completed |
| 7        | Monitor | 3200   | pending   |


## BETWEEN - Range Filter

>``BETWEEN`` filter rows where a value falls **within a range** (inclusive). Very useful in data engineering when filtering data by **date ranges** in a pipeline - for example, processing only last month's data.

```sql
-- Get orders with amount between 200 and 1000
-- Hetan ordem ho montante entre 200 no 1000
SELECT *
FROM orders
WHERE amount BETWEEN 200 AND 1000;
```
> Result

| order_id | product   | amount | status    |
|----------|-----------|--------|-----------|
| 2        | Mouse     | 250    | completed |
| 4        | Keyboard  | 500    | pending   |
| 5        | Headphone | 800    | completed |
| 6        | Jeans     | 300    | completed |

```sql
-- Filter by date range (common in ETL pipelines)
-- Filtra ho intervalu data (komun iha pipeline ETL)
SELECT *
FROM orders
WHERE order_date BETWEEN '2024-01-01' AND '2024-01-04';
```

## IN - Match multiple values

> ``IN `` checks if a value matches **any value in a list**. It's cleaner alternative to writing multiple ``OR`` conditions. In data engineering, commonly used to filter specific 

```sql 
-- Get orders from Electronics category only
-- Hetan ordem husi kategoria Electronics de'it
SELECT *
FROM orders
WHERE category IN ('Electronics', 'Fashion');
```

```sql
-- Get specific order statuses
-- Hetan status ordem espesifiku
SELECT *
FROM orders
WHERE status IN ('completed', 'pending');
```

> Result

| order_id | product   | amount | status    |
|----------|-----------|--------|-----------|
| 1        | Laptop    | 15000  | completed |
| 2        | Mouse     | 250    | completed |
| 4        | Keyboard  | 500    | pending   |
| 5        | Headphone | 800    | completed |
| 6        | Jeans     | 300    | completed |
| 7        | Monitor   | 3200   | pending   |


## IS NULL/IS NOT NULL

> ``NULL`` means **no value**/**Missing data**. You cannot use ``= NULL`` - you must use ``IS NULL`` or ``IS NOT NULL``. In data engineering, handling NULL values is extremely important during **data cleaning** in your pipeline.

```sql
-- Find orders with missing amount (data quality check)
-- Hetan ordem ho montante ne'ebé falta (verifika kualidade dadus)
SELECT *
FROM orders
WHERE amount IS NULL;
```

> Result

| order_id | product | amount | status    |
|----------|---------|--------|-----------|
| 8        | Jacket  | NULL   | cancelled |

```sql
-- Get only orders that have a valid amount
-- Hetan de'it ordem ne'ebé iha montante válidu
SELECT *
FROM orders
WHERE amount IS NOT NULL;
```

## AND/OR/NOT - Combine Conditions

> you can combine multiple conditiond using ``AND``, ``OR``, and ``NOT``.

- ``AND`` → both conditions must be true
- ``OR`` → at least one condition must be true
- ``NOT`` → reverses the condition

```sql
-- Completed orders from Electronics with amount > 500
-- Ordem kompletu husi Electronics ho montante > 500
SELECT *
FROM orders
WHERE status = 'completed'
  AND category = 'Electronics'
  AND amount > 500;
```
> Result

| order_id | product   | amount | status    |
|----------|-----------|--------|-----------|
| 1        | Laptop    | 15000  | completed |
| 5        | Headphone | 800    | completed |

```sql
-- Orders that are either cancelled OR have NULL amount
-- Ordem ne'ebé kansela KA iha montante NULL
SELECT *
FROM orders
WHERE status = 'cancelled'
   OR amount IS NULL;
```

### Real Pipeline Use Case

> in a real ETL Pipeline, ``WHERE`` is used to do incremental loading - only processing new data since the last pipeline run. This saves huge amounts of compute time and cost.

```sql
-- Incremental load: only process today's new orders
-- Karga inkrementál: prosesa de'it ordem foun ohin nian
SELECT
    order_id,
    customer_id,
    product,
    amount,
    order_date
FROM raw.orders
WHERE order_date = CURRENT_DATE
  AND status != 'cancelled'
  AND amount IS NOT NULL;
```

> data engineering note
>this pattern - filtering by date + status + NULL check - is one of the most common pattern you'll write in real pipelines using tools like **Apache Airflow, dbt, or Spark SQL**



