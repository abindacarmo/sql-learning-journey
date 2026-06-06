# SQL Phase 2 — HAVING

> **Topic:** Filtering GROUP BY Results  
> **Level:** Intermediate  

---

## What is HAVING?

`HAVING` filters the results of `GROUP BY`. It works like `WHERE`, but specifically for groups — not individual rows.

The key difference:
- **`WHERE`** → filters rows **before** grouping
- **`HAVING`** → filters groups **after** aggregation

---

## Why Does HAVING Exist?

Because `WHERE` cannot use aggregate functions. Look at the SQL execution order:

```
FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY
```

`WHERE` runs at step 2 — at that point, `GROUP BY` hasn't run yet, so aggregate functions don't exist yet. That's why writing `WHERE COUNT(*) >= 2` causes an error — `COUNT(*)` hasn't been calculated when `WHERE` is executed.

`HAVING` fills that gap — it runs **after** `GROUP BY` is complete.

---

## Sample Data

Table `orders` used in all examples:

| id | customer | product    | total  | status    |
|----|----------|------------|--------|-----------|
| 1  | Ana      | Kue Lapis  | 45000  | completed |
| 2  | Budi     | Nastar     | 30000  | completed |
| 3  | Ana      | Brownies   | 60000  | completed |
| 4  | Cici     | Putu Ayu   | 25000  | cancelled |
| 5  | Budi     | Bolu       | 20000  | pending   |
| 6  | Doni     | Nastar     | 80000  | completed |
| 7  | Cici     | Kue Lapis  | 35000  | completed |
| 8  | Ana      | Putu Ayu   | 15000  | cancelled |

---

## Basic Syntax

```sql
SELECT column_to_group, AGG_FUNC(...)
FROM table
GROUP BY column_to_group
HAVING AGG_FUNC(...) condition;
```

---

## Examples

### Example 1 — Customers who ordered more than once

```sql
SELECT
  customer,
  COUNT(*) AS total_orders
FROM orders
GROUP BY customer
HAVING COUNT(*) > 1;
```

**What happens step by step:**

After GROUP BY, the intermediate result is:

| customer | total_orders | HAVING check |
|----------|-------------|--------------|
| Ana      | 3           | ✅ 3 > 1 — kept |
| Budi     | 2           | ✅ 2 > 1 — kept |
| Cici     | 2           | ✅ 2 > 1 — kept |
| Doni     | 1           | ❌ 1 > 1 is false — removed |

**Final result:**

| customer | total_orders |
|----------|-------------|
| Ana      | 3           |
| Budi     | 2           |
| Cici     | 2           |

---

### Example 2 — Customers with total spending above 55,000

```sql
SELECT
  customer,
  SUM(total) AS total_spent
FROM orders
GROUP BY customer
HAVING SUM(total) > 55000;
```

**Result:**

| customer | total_spent |
|----------|-------------|
| Ana      | 120000      |
| Doni     | 80000       |
| Cici     | 60000       |

---

### Example 3 — WHERE and HAVING used together

```sql
SELECT
  customer,
  COUNT(*)   AS completed_orders,
  SUM(total) AS total_spent
FROM orders
WHERE status = 'completed'     -- Step 1: remove cancelled/pending rows first
GROUP BY customer              -- Step 2: group remaining rows
HAVING COUNT(*) >= 2           -- Step 3: keep only groups with 2+ orders
ORDER BY total_spent DESC;
```

**What this query means:**  
*"Among completed orders only, which customers have ordered at least 2 times — sorted by highest spending?"*

**Execution flow:**

```
1. WHERE status = 'completed'  → removes rows id=4, id=5, id=8
2. GROUP BY customer           → groups remaining 5 rows
3. HAVING COUNT(*) >= 2        → removes groups with less than 2 orders
4. ORDER BY total_spent DESC   → sorts final result
```

---

### Example 4 — Using MIN and MAX in HAVING

```sql
-- Customers whose smallest order is still above 20,000
SELECT
  customer,
  MIN(total) AS smallest_order,
  MAX(total) AS largest_order
FROM orders
GROUP BY customer
HAVING MIN(total) > 20000;
```

---

## WHERE vs HAVING — Side by Side

| | WHERE | HAVING |
|---|---|---|
| Runs | Before GROUP BY | After GROUP BY |
| Can use aggregate functions? | ❌ No | ✅ Yes |
| Filters | Individual rows | Groups |
| Used with | Any query | Only with GROUP BY |

---

## Common Mistakes

### Mistake 1 — Using WHERE to filter an aggregate

```sql
-- ❌ Wrong — WHERE cannot use aggregate functions
SELECT customer, COUNT(*)
FROM orders
WHERE COUNT(*) >= 2
GROUP BY customer;
-- Error: aggregate functions not allowed in WHERE

-- ✅ Fix: use HAVING
SELECT customer, COUNT(*)
FROM orders
GROUP BY customer
HAVING COUNT(*) >= 2;
```

### Mistake 2 — Using HAVING without GROUP BY

```sql
-- ❌ Unusual — HAVING without GROUP BY treats the whole table as one group
SELECT COUNT(*)
FROM orders
HAVING COUNT(*) > 5;

-- ✅ Better — just use WHERE for row-level filtering
SELECT COUNT(*)
FROM orders
WHERE total > 30000;
```

### Mistake 3 — Trying to use SELECT alias in HAVING

```sql
-- ❌ Wrong in most databases — alias not available at HAVING stage
SELECT customer, COUNT(*) AS total_orders
FROM orders
GROUP BY customer
HAVING total_orders >= 2;   -- alias doesn't exist yet!

-- ✅ Fix: repeat the aggregate function
SELECT customer, COUNT(*) AS total_orders
FROM orders
GROUP BY customer
HAVING COUNT(*) >= 2;
```

> **Note:** PostgreSQL actually allows aliases in HAVING, but MySQL and SQL Server do not. To be safe and portable, always repeat the aggregate function in HAVING.

---

## Quick Reference

| Goal | Clause |
|---|---|
| Filter rows before grouping | `WHERE` |
| Filter groups after aggregation | `HAVING` |
| Both at the same time | `WHERE` + `HAVING` together |

**Template:**
```sql
SELECT column, AGG_FUNC(...) AS alias
FROM table
WHERE row_condition           -- optional
GROUP BY column
HAVING AGG_FUNC(...) condition  -- optional
ORDER BY alias DESC;          -- optional
```

*SQL Learning Journey — Phase 2 Intermediate Queries*