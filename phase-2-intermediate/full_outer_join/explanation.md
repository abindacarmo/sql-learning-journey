# SQL Phase 2 — FULL OUTER JOIN

> **Topic:** All Rows From Both Tables  
> **Level:** Intermediate  

---

## What is FULL OUTER JOIN?

`FULL OUTER JOIN` combines two tables and returns **all rows from both tables** — whether they have a match or not. Where there is no match on either side, the missing columns are filled with `NULL`.

Think of it as LEFT JOIN and RIGHT JOIN combined into one.

| JOIN Type | What appears |
|---|---|
| `INNER JOIN` | Only rows matching in **both** tables |
| `LEFT JOIN` | All rows from left + matched rows from right |
| `RIGHT JOIN` | All rows from right + matched rows from left |
| `FULL OUTER JOIN` | **All rows from both tables — nothing is left out** |

---

## Sample Data

**Table: customers**

| id | name | city    |
|----|------|---------|
| 1  | Ana  | Dili    |
| 2  | Budi | Baucau  |
| 3  | Cici | Dili    |
| 4  | Doni | Maliana |

**Table: orders**

| id  | customer_id | product   | total |
|-----|-------------|-----------|-------|
| 101 | 1           | Kue Lapis | 45000 |
| 102 | 1           | Brownies  | 60000 |
| 103 | 2           | Nastar    | 30000 |
| 104 | 3           | Putu Ayu  | 25000 |
| 105 | 99          | Bolu      | 20000 |

Two "problem" rows:
- **Doni** (id=4) → registered customer with no orders
- **Order id=105** → order with customer_id=99 that doesn't exist in the customers table

---

## All JOINs Compared — Same Data

| JOIN | Doni appears? | Bolu appears? | Total rows |
|---|---|---|---|
| INNER JOIN | ❌ No | ❌ No | 4 |
| LEFT JOIN | ✅ Yes (NULL) | ❌ No | 5 |
| RIGHT JOIN | ❌ No | ✅ Yes (NULL) | 5 |
| **FULL OUTER JOIN** | ✅ **Yes (NULL)** | ✅ **Yes (NULL)** | **6** |

---

## Basic Syntax

```sql
SELECT
  c.name,
  c.city,
  o.product,
  o.total
FROM customers c
FULL OUTER JOIN orders o
  ON c.id = o.customer_id;
```

**Result — all 6 rows:**

| name | city    | product   | total |
|------|---------|-----------|-------|
| Ana  | Dili    | Kue Lapis | 45000 |
| Ana  | Dili    | Brownies  | 60000 |
| Budi | Baucau  | Nastar    | 30000 |
| Cici | Dili    | Putu Ayu  | 25000 |
| Doni | Maliana | NULL      | NULL  |
| NULL | NULL    | Bolu      | 20000 |

> Row 5 (Doni): has no orders → product and total are NULL  
> Row 6 (Bolu): customer_id=99 doesn't exist → name and city are NULL

---

## How It Works — Step by Step

```
Step 1 — LEFT JOIN part:
  Take all rows from the left table (customers)
  Match with the right table (orders)
  No match on the right → fill with NULL

Step 2 — RIGHT JOIN part:
  Take rows from the right table (orders) that had NO match in step 1
  Fill left-side columns with NULL

Step 3 — Combine both:
  Result = all matched rows + left-only rows + right-only rows
```

---

## Use Cases

### Use Case 1 — Audit orphaned data on both sides

Find customers without orders AND orders without a valid customer — all in one query:

```sql
SELECT c.name, o.product
FROM customers c
FULL OUTER JOIN orders o
  ON c.id = o.customer_id
WHERE c.id IS NULL        -- orders with no matching customer
   OR o.id IS NULL;       -- customers with no orders
```

**Result:**

| name | product |
|------|---------|
| Doni | NULL    |
| NULL | Bolu    |

---

### Use Case 2 — Data reconciliation between two sources

Compare data from two different systems and find discrepancies:

```sql
SELECT
  COALESCE(a.id, b.id) AS id,
  a.total              AS total_system_a,
  b.total              AS total_system_b
FROM sales_system_a a
FULL OUTER JOIN sales_system_b b
  ON a.id = b.id
WHERE a.total != b.total
   OR a.id IS NULL
   OR b.id IS NULL;
```

---

### Use Case 3 — ETL Pipeline data validation

Before loading data into a warehouse, validate that records from two source tables are complete and consistent:

```sql
-- Check which records exist in source but not in destination, or vice versa
SELECT
  COALESCE(src.id, dest.id) AS record_id,
  src.value                 AS source_value,
  dest.value                AS destination_value,
  CASE
    WHEN src.id IS NULL  THEN 'Only in destination'
    WHEN dest.id IS NULL THEN 'Only in source'
    ELSE 'In both'
  END AS status
FROM source_table src
FULL OUTER JOIN destination_table dest
  ON src.id = dest.id;
```

> FULL OUTER JOIN is especially useful in **data engineering** and **ETL pipelines** — exactly the kind of work done with Apache Airflow and PostgreSQL.

---

## MySQL Does NOT Support FULL OUTER JOIN

```sql
-- ❌ This causes an error in MySQL!
SELECT * FROM customers
FULL OUTER JOIN orders ON customers.id = orders.customer_id;
```

### Workaround — Simulate with UNION

```sql
-- ✅ Simulated FULL OUTER JOIN in MySQL

-- Part 1: LEFT JOIN (all left rows + matched right rows)
SELECT c.name, c.city, o.product, o.total
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id

UNION

-- Part 2: RIGHT JOIN — only rows with no match on the left
SELECT c.name, c.city, o.product, o.total
FROM customers c
RIGHT JOIN orders o ON c.id = o.customer_id
WHERE c.id IS NULL;
```

The result is **identical** to a real `FULL OUTER JOIN`.

**Why UNION works here:**
- `UNION` removes duplicates automatically
- Part 1 covers all left rows + matched rows
- Part 2 adds only the right rows that weren't matched in Part 1
- Together they cover all rows from both tables

---

## Database Support

| Database | FULL OUTER JOIN |
|---|---|
| PostgreSQL | ✅ Native support |
| SQL Server | ✅ Native support |
| Oracle | ✅ Native support |
| MySQL | ❌ Not supported — use UNION workaround |
| SQLite | ❌ Not supported — use UNION workaround |

---

## Common Mistakes

### Mistake 1 — Using it in MySQL without a workaround

```sql
-- ❌ Error in MySQL
SELECT * FROM customers
FULL OUTER JOIN orders ON customers.id = orders.customer_id;

-- ✅ Use UNION workaround instead (see above)
```

### Mistake 2 — Forgetting WHERE when looking for orphaned rows only

```sql
-- This returns ALL rows (matched + unmatched) — probably not what you want
SELECT c.name, o.product
FROM customers c
FULL OUTER JOIN orders o ON c.id = o.customer_id;

-- ✅ Add WHERE to get only the unmatched rows
SELECT c.name, o.product
FROM customers c
FULL OUTER JOIN orders o ON c.id = o.customer_id
WHERE c.id IS NULL OR o.id IS NULL;
```

### Mistake 3 — Confusing FULL OUTER JOIN with CROSS JOIN

```sql
-- FULL OUTER JOIN — keeps all rows, NULL where no match
SELECT * FROM customers c
FULL OUTER JOIN orders o ON c.id = o.customer_id;
-- Result: 6 rows

-- CROSS JOIN — every row paired with every other row (Cartesian Product)
SELECT * FROM customers
CROSS JOIN orders;
-- Result: 4 × 5 = 20 rows — completely different!
```

---

## Quick Reference

```sql
-- Basic FULL OUTER JOIN
SELECT a.col, b.col
FROM table_a a
FULL OUTER JOIN table_b b
  ON a.id = b.a_id;

-- Find orphaned rows on both sides
SELECT a.col, b.col
FROM table_a a
FULL OUTER JOIN table_b b
  ON a.id = b.a_id
WHERE a.id IS NULL OR b.id IS NULL;

-- MySQL workaround
SELECT a.col, b.col FROM table_a a
LEFT JOIN table_b b ON a.id = b.a_id
UNION
SELECT a.col, b.col FROM table_a a
RIGHT JOIN table_b b ON a.id = b.a_id
WHERE a.id IS NULL;
```
