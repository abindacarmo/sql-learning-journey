# Order by & Limit

## What is ORDER BY?
> ``ORDER BY`` is used to sort the results of a query in ascending or descending order. In data engineering, sorting is important when you need to find the latest records, identify top/bottom values, or prepare data in a specific order before loading it into a warehouse.

## this is sample table?
**We still use table ``orders`` from our database e-commerce before**

| order_id | customer_id | product_id | total_price | status    | order_date |
|----------|-------------|------------|-------------|-----------|------------|
| 1        | 1           | 1          | 15000.00    | completed | 2024-01-01 |
| 2        | 2           | 2          | 500.00      | completed | 2024-01-02 |
| 3        | 3           | 6          | 360.00      | cancelled | 2024-01-03 |
| 4        | 1           | 3          | 500.00      | pending   | 2024-01-04 |
| 5        | 4           | 4          | 800.00      | completed | 2024-01-05 |
| 6        | 5           | 7          | 600.00      | completed | 2024-01-06 |
| 7        | 6           | 5          | 3200.00     | pending   | 2024-01-07 |
| 8        | 7           | 8          | NULL        | cancelled | 2024-01-08 |
| 9        | 3           | 10         | 360.00      | completed | 2024-02-01 |
| 10       | 4           | 9          | 600.00      | completed | 2024-02-05 |
| 11       | 5           | 1          | 15000.00    | pending   | 2024-02-10 |
| 12       | 2           | 5          | 3200.00     | completed | 2024-02-15 |

## ORDER BY ASC - Ascending(default)
>```ASC``` sorts from smallest to largest(A→Z, 1→9, oldest→newest). this is the default behaviour- if you don't wrtite ``ASC`` or ``DESC``, postgreSQL automatically sorts ascending.

```sql
-- Sort orders by total_price from cheapest to most expensive
-- Klasifika ordem husi folin ki'ik ba boot
SELECT order_id, total_price, status, order_date
FROM orders
ORDER BY total_price ASC;
```

>Result

| order_id | total_price | status    | order_date |
|----------|-------------|-----------|------------|
| 8        | NULL        | cancelled | 2024-01-08 |
| 3        | 360.00      | cancelled | 2024-01-03 |
| 9        | 360.00      | completed | 2024-02-01 |
| 2        | 500.00      | completed | 2024-01-02 |
| 4        | 500.00      | pending   | 2024-01-04 |
| 6        | 600.00      | completed | 2024-01-06 |
| 10       | 600.00      | completed | 2024-02-05 |
| 5        | 800.00      | completed | 2024-01-05 |
| 7        | 3200.00     | pending   | 2024-01-07 |
| 12       | 3200.00     | completed | 2024-02-15 |
| 1        | 15000.00    | completed | 2024-01-01 |
| 11       | 15000.00    | pending   | 2024-02-10 |

> 💡 Note: NULL values appear first when sorting ASC in PostgreSQL.

## ORDER BY DESC - Descending
> ``DESC`` sorts from largest to smallest(Z→A, 9→1, newest→oldest). In data engineering, this is very commonlly used to get the latest records or top transactions.

```sql
-- Sort orders by date, newest first
-- Klasifika ordem ho data, foun liu uluk
SELECT order_id, total_price, status, order_date
FROM orders
ORDER BY order_date DESC;
```

> Result

| order_id | total_price | status    | order_date |
|----------|-------------|-----------|------------|
| 12       | 3200.00     | completed | 2024-02-15 |
| 11       | 15000.00    | pending   | 2024-02-10 |
| 10       | 600.00      | completed | 2024-02-05 |
| 9        | 360.00      | completed | 2024-02-01 |
| 8        | NULL        | cancelled | 2024-01-08 |
| 7        | 3200.00     | pending   | 2024-01-07 |
...

## ORDER BY Multiple columns
>you can sort by more than one column. PostgreSQL sorts by the **first column first**, then uses the second column to break ties.

```sql
-- Sort by status ASC, then by total_price DESC
-- Klasifika ho status ASC, depois total_price DESC
SELECT order_id, total_price, status, order_date
FROM orders
ORDER BY status ASC, total_price DESC;
```

>Result

| order_id | total_price | status    | order_date |
|----------|-------------|-----------|------------|
| 3        | 360.00      | cancelled | 2024-01-03 |
| 8        | NULL        | cancelled | 2024-01-08 |
| 12       | 3200.00     | completed | 2024-02-15 |
| 1        | 15000.00    | completed | 2024-01-01 |
| 11       | 15000.00    | pending   | 2024-02-10 |
| 5        | 800.00      | completed | 2024-01-05 |
...

## LIMIT - Restrict Number of Rows
> ``LIMIT`` resticts how many rows are returned. In data engineering, ``LIMIT`` is extremly usefull for **sampling data** - quickly checking what a table looks like without pulling milllions of rows.

```sql
-- Get only the 5 most expensive orders
-- Hetan de'it ordem 5 ne'ebé tahan boot liu
SELECT order_id, total_price, status, order_date
FROM orders
ORDER BY total_price DESC
LIMIT 5;
```

> Result

| order_id | total_price | status    | order_date |
|----------|-------------|-----------|------------|
| 1        | 15000.00    | completed | 2024-01-01 |
| 11       | 15000.00    | pending   | 2024-02-10 |
| 7        | 3200.00     | pending   | 2024-01-07 |
| 12       | 3200.00     | completed | 2024-02-15 |
| 5        | 800.00      | completed | 2024-01-05 |

## ORDER BY + WHERE + LIMIT
> in real queries, these are almost always used together. The order of execution matters - ``WHERE`` filters first, then ``ORDER BY``sorts, then ``LIMIT`` cuts the result.

```sql
-- Top 3 most expensive completed orders in January 2024
-- Ordem kompletu 3 ne'ebé tahan boot liu iha Janeiru 2024
SELECT 
    order_id,
    total_price,
    status,
    order_date
FROM orders
WHERE status = 'completed'
  AND order_date BETWEEN '2024-01-01' AND '2024-01-31'
ORDER BY total_price DESC
LIMIT 3;
```

> Result

| order_id | total_price | status    | order_date |
|----------|-------------|-----------|------------|
| 1        | 15000.00    | completed | 2024-01-01 |
| 5        | 800.00      | completed | 2024-01-05 |
| 6        | 600.00      | completed | 2024-01-06 |

### Real Pipeline use case
> in data engineering, ``ORDER BY`` + ``LIMIT`` used for **data sampling** and finding the latest records loaded into a pipeline - to verify the pipeline ran correctly.

```sql
-- Check latest record loaded into warehouse (pipeline validation)
-- Verifika rekorde ikus liu ne'ebé karga ba warehouse
SELECT 
    order_id,
    total_price,
    status,
    order_date
FROM orders
ORDER BY order_date DESC
LIMIT 1;
```






