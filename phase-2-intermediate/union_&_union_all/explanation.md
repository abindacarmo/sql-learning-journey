# SQL Phase 2 — UNION & UNION ALL

> **Topic:** Merging Results From Two Queries
> **Level:** Intermediate
> **Language:** English
> **Prerequisite:** SELECT, WHERE, Aggregate Functions, JOIN

---

## What is UNION?

`UNION` combines the results of two or more queries into a single list of rows.

The key difference from JOIN:
- **JOIN** combines tables **horizontally** — adds more columns
- **UNION** combines tables **vertically** — adds more rows

**Analogy:**
> Imagine you have two separate notebooks — one for income and one for expenses. UNION is like copying all entries from both notebooks into one master list.

---

## UNION vs UNION ALL

| | UNION | UNION ALL |
|---|---|---|
| Removes duplicates? | ✅ Yes | ❌ No |
| Speed | Slower (has to compare rows) | Faster (no comparison needed) |
| Use when | Duplicates are possible and unwanted | No duplicates, or duplicates are acceptable |

---

## Mandatory Rules

Both queries being combined must have:

1. **The same number of columns**
2. **Compatible data types in each column position**
3. **The same column order**

```sql
-- ❌ Wrong — different number of columns
SELECT name, city FROM customers
UNION
SELECT product FROM orders;
-- Error: each UNION query must have the same number of columns

-- ✅ Correct — same number and order of columns
SELECT name, city FROM customers
UNION
SELECT product, status FROM orders;
```

> The column **names** in the final result are taken from the **first query**.

---

## Sample Data

**Table: income**

| id | date       | description | amount |
|----|------------|-------------|--------|
| 1  | 2024-01-01 | Sell Cake   | 45000  |
| 2  | 2024-01-02 | Sell Bread  | 30000  |
| 3  | 2024-01-03 | Sell Cake   | 60000  |

**Table: expenses**

| id | date       | description | amount |
|----|------------|-------------|--------|
| 1  | 2024-01-01 | Buy Flour   | 20000  |
| 2  | 2024-01-02 | Sell Bread  | 30000  |
| 3  | 2024-01-03 | Buy Sugar   | 15000  |

> Notice: **"Sell Bread 30000"** appears in both tables. This is what makes the difference between `UNION` and `UNION ALL` visible.

---

## Basic Syntax

```sql
-- UNION: remove duplicates
SELECT columns FROM table_a
UNION
SELECT columns FROM table_b;

-- UNION ALL: keep all rows including duplicates
SELECT columns FROM table_a
UNION ALL
SELECT columns FROM table_b;
```

---

## Examples

### Example 1 — UNION (removes duplicates)

```sql
SELECT date, description, amount
FROM income

UNION

SELECT date, description, amount
FROM expenses

ORDER BY date;
```

**Result — "Sell Bread" appears only once:**

| date       | description | amount |
|------------|-------------|--------|
| 2024-01-01 | Sell Cake   | 45000  |
| 2024-01-01 | Buy Flour   | 20000  |
| 2024-01-02 | Sell Bread  | 30000  |
| 2024-01-03 | Sell Cake   | 60000  |
| 2024-01-03 | Buy Sugar   | 15000  |

5 rows — "Sell Bread" appears only once even though it exists in both tables.

---

### Example 2 — UNION ALL (keeps duplicates)

```sql
SELECT date, description, amount
FROM income

UNION ALL

SELECT date, description, amount
FROM expenses

ORDER BY date;
```

**Result — "Sell Bread" appears twice:**

| date       | description | amount |
|------------|-------------|--------|
| 2024-01-01 | Sell Cake   | 45000  |
| 2024-01-01 | Buy Flour   | 20000  |
| 2024-01-02 | Sell Bread  | 30000  |
| 2024-01-02 | Sell Bread  | 30000  |
| 2024-01-03 | Sell Cake   | 60000  |
| 2024-01-03 | Buy Sugar   | 15000  |

6 rows — "Sell Bread" appears twice, once from each table.

---

### Example 3 — Add a type column to identify the source

The most common real-world pattern — add a literal column to label where each row came from:

```sql
SELECT date, description, amount, 'income' AS type
FROM income

UNION ALL

SELECT date, description, amount, 'expense' AS type
FROM expenses

ORDER BY date;
```

**Result:**

| date       | description | amount | type    |
|------------|-------------|--------|---------|
| 2024-01-01 | Sell Cake   | 45000  | income  |
| 2024-01-01 | Buy Flour   | 20000  | expense |
| 2024-01-02 | Sell Bread  | 30000  | income  |
| 2024-01-02 | Sell Bread  | 30000  | expense |
| 2024-01-03 | Sell Cake   | 60000  | income  |
| 2024-01-03 | Buy Sugar   | 15000  | expense |

> This is a very practical pattern for financial reports, audit logs, and any situation where you need to combine data from two separate tables into one unified view.

---

### Example 4 — Aggregate after UNION ALL

Wrap the UNION ALL in a subquery, then aggregate:

```sql
-- Total combined income and expenses
SELECT
  type,
  COUNT(*)    AS total_transactions,
  SUM(amount) AS total_amount
FROM (
  SELECT amount, 'income' AS type FROM income
  UNION ALL
  SELECT amount, 'expense' AS type FROM expenses
) AS all_transactions
GROUP BY type;
```

**Result:**

| type    | total_transactions | total_amount |
|---------|--------------------|--------------|
| income  | 3                  | 135000       |
| expense | 3                  | 65000        |

---

### Example 5 — UNION to simulate FULL OUTER JOIN in MySQL

As covered in the FULL OUTER JOIN topic, MySQL doesn't support FULL OUTER JOIN natively. UNION is the workaround:

```sql
-- Part 1: LEFT JOIN (all left rows + matched right rows)
SELECT c.name, o.product
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id

UNION

-- Part 2: only right rows with no match on the left
SELECT c.name, o.product
FROM customers c
RIGHT JOIN orders o ON c.id = o.customer_id
WHERE c.id IS NULL;
```

---

### Example 6 — Combine results from different time periods

```sql
-- Compare this month vs last month
SELECT 'This Month' AS period, customer, SUM(total) AS revenue
FROM orders
WHERE date >= '2024-01-01' AND date < '2024-02-01'
GROUP BY customer

UNION ALL

SELECT 'Last Month' AS period, customer, SUM(total) AS revenue
FROM orders
WHERE date >= '2023-12-01' AND date < '2024-01-01'
GROUP BY customer

ORDER BY period, revenue DESC;
```

---

## ORDER BY in UNION

`ORDER BY` can only be written **once, at the very end** — it applies to the entire combined result:

```sql
-- ❌ Wrong — ORDER BY in the middle
SELECT date, amount FROM income ORDER BY date
UNION ALL
SELECT date, amount FROM expenses;
-- Error!

-- ✅ Correct — ORDER BY at the end
SELECT date, amount FROM income
UNION ALL
SELECT date, amount FROM expenses
ORDER BY date;
```

---

## Column Names in UNION Result

The column names in the final result always come from the **first query**:

```sql
SELECT name AS label FROM customers   -- result column name: "label"
UNION ALL
SELECT product FROM orders;           -- still uses "label" from first query
```

---

## UNION vs JOIN — Key Difference

| | JOIN | UNION |
|---|---|---|
| Combines | Columns (horizontally) | Rows (vertically) |
| Tables need relationship? | Yes — needs a matching key | No — just compatible columns |
| Result shape | Wider (more columns) | Taller (more rows) |
| Use case | Enrich data with related info | Stack similar data from multiple sources |

```
JOIN result:                    UNION result:
┌────┬────┬────┬────┐           ┌────┬────┐
│ id │name│prod│total│          │col1│col2│
├────┼────┼────┼────┤     vs    ├────┼────┤
│  1 │Ana │Kue │45K │           │ A  │ 1  │  ← from table_a
└────┴────┴────┴────┘           ├────┼────┤
                                │ B  │ 2  │  ← from table_b
                                └────┴────┘
```

---

## Common Mistakes

### Mistake 1 — Different number of columns

```sql
-- ❌ Error
SELECT name, city FROM customers
UNION
SELECT product FROM orders;
-- Error: each UNION query must have the same number of columns

-- ✅ Fix: match the column count
SELECT name, city FROM customers
UNION
SELECT product, status FROM orders;
```

### Mistake 2 — ORDER BY in the middle

```sql
-- ❌ Error
SELECT amount FROM income ORDER BY amount
UNION ALL
SELECT amount FROM expenses;

-- ✅ Fix: move ORDER BY to the end
SELECT amount FROM income
UNION ALL
SELECT amount FROM expenses
ORDER BY amount;
```

### Mistake 3 — Using UNION when UNION ALL is more appropriate

```sql
-- ❌ Inefficient — UNION does extra work to remove duplicates
-- even when you know there are none
SELECT id FROM table_a
UNION
SELECT id FROM table_b;

-- ✅ Better — UNION ALL is faster when duplicates don't matter
SELECT id FROM table_a
UNION ALL
SELECT id FROM table_b;
```

### Mistake 4 — Incompatible data types

```sql
-- ❌ May cause error or unexpected results
SELECT name FROM customers       -- text column
UNION
SELECT total FROM orders;        -- numeric column

-- ✅ Fix: cast to compatible types
SELECT name FROM customers
UNION
SELECT CAST(total AS VARCHAR) FROM orders;
```

---

## Quick Reference

```sql
-- Basic UNION (no duplicates)
SELECT col1, col2 FROM table_a
UNION
SELECT col1, col2 FROM table_b;

-- Basic UNION ALL (keep duplicates — faster)
SELECT col1, col2 FROM table_a
UNION ALL
SELECT col1, col2 FROM table_b;

-- With type label
SELECT col1, col2, 'source_a' AS source FROM table_a
UNION ALL
SELECT col1, col2, 'source_b' AS source FROM table_b
ORDER BY col1;

-- Aggregate after UNION ALL
SELECT source, COUNT(*), SUM(col2)
FROM (
  SELECT col2, 'source_a' AS source FROM table_a
  UNION ALL
  SELECT col2, 'source_b' AS source FROM table_b
) AS combined
GROUP BY source;
```

---

## Summary

| Feature | UNION | UNION ALL |
|---|---|---|
| Removes duplicates | ✅ Yes | ❌ No |
| Speed | Slower | Faster |
| Use when | Duplicates unwanted | No duplicates / don't care |
| ORDER BY | Only at the end | Only at the end |
| Column count | Must match | Must match |
| Data types | Must be compatible | Must be compatible |
| Column names | From first query | From first query |

---

## Phase 2 Complete! 🎉

You have now covered all Phase 2 — Intermediate Queries topics:

- ✅ LIKE & Wildcards
- ✅ Aggregate Functions
- ✅ GROUP BY
- ✅ HAVING
- ✅ INNER JOIN
- ✅ LEFT JOIN & RIGHT JOIN
- ✅ FULL OUTER JOIN
- ✅ Subquery
- ✅ UNION & UNION ALL

---

*SQL Learning Journey — Phase 2 Intermediate Queries*