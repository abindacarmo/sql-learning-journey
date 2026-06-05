# SQL Phase 2 — GROUP BY

> **Topic:** Grouping Data for Aggregation  
> **Level:** Intermediate  


---

## What is GROUP BY?

`GROUP BY` groups rows that share the same value in a column, then applies an aggregate function to each group separately.

**Without GROUP BY** → aggregate functions collapse the entire table into one single row.  
**With GROUP BY** → you get one summary row *per group*.

**Analogy:**  
Imagine you have a pile of scattered receipts. `GROUP BY` is like sorting those receipts into envelopes by customer name — all of Ana's receipts go into one envelope, all of Budi's into another. Once grouped, you calculate the total *per envelope*. That's exactly what `GROUP BY` + aggregate function does.

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

> Notice: Ana appears 3 times, Budi 2 times, Cici 2 times, Doni 1 time. GROUP BY will "fold" these rows into one row per customer.

---

## Basic Syntax

```sql
SELECT column_to_group, AGG_FUNC(...)
FROM table
GROUP BY column_to_group;
```

---

## How GROUP BY Works — Step by Step

### Step 1 — Raw data (before GROUP BY)

8 rows, unorganized.

### Step 2 — Database groups rows by customer

```
Ana   → [ id=1 (45000), id=3 (60000), id=8 (15000) ]
Budi  → [ id=2 (30000), id=5 (20000) ]
Cici  → [ id=4 (25000), id=7 (35000) ]
Doni  → [ id=6 (80000) ]
```

### Step 3 — Aggregate function is applied to each group

```
Ana   → COUNT=3, SUM=120000, AVG=40000
Budi  → COUNT=2, SUM=50000,  AVG=25000
Cici  → COUNT=2, SUM=60000,  AVG=30000
Doni  → COUNT=1, SUM=80000,  AVG=80000
```

### Step 4 — Result: 8 rows → 4 rows

---

## Examples

### Example 1 — Count orders per customer

```sql
SELECT
  customer,
  COUNT(*) AS total_orders
FROM orders
GROUP BY customer;
```

**Result:**

| customer | total_orders |
|----------|-------------|
| Ana      | 3           |
| Budi     | 2           |
| Cici     | 2           |
| Doni     | 1           |

---

### Example 2 — Total and average spending per customer

```sql
SELECT
  customer,
  COUNT(*)        AS total_orders,
  SUM(total)      AS total_spent,
  AVG(total)      AS avg_order
FROM orders
GROUP BY customer
ORDER BY total_spent DESC;
```

**Result:**

| customer | total_orders | total_spent | avg_order |
|----------|-------------|-------------|-----------|
| Ana      | 3           | 120000      | 40000     |
| Doni     | 1           | 80000       | 80000     |
| Cici     | 2           | 60000       | 30000     |
| Budi     | 2           | 50000       | 25000     |

---

### Example 3 — Group by multiple columns

```sql
SELECT
  customer,
  status,
  COUNT(*) AS total_orders
FROM orders
GROUP BY customer, status
ORDER BY customer;
```

> When grouping by multiple columns, each unique **combination** of those columns becomes one group.

---

### Example 4 — GROUP BY with MIN and MAX

```sql
SELECT
  customer,
  MIN(total) AS smallest_order,
  MAX(total) AS largest_order
FROM orders
GROUP BY customer;
```

---

## The Most Important Rule

> **Every column in SELECT that is NOT an aggregate function MUST appear in GROUP BY.**

This is the most common mistake beginners make.

```sql
-- ❌ WRONG — product is in SELECT but not in GROUP BY
SELECT customer, product, COUNT(*)
FROM orders
GROUP BY customer;
-- Error: column "product" must appear in GROUP BY

-- ✅ CORRECT — only GROUP BY column + aggregates in SELECT
SELECT customer, COUNT(*)
FROM orders
GROUP BY customer;
```

**Why?** When you group by customer, each group has multiple rows with different product values. The database doesn't know which product value to show for the group — so it throws an error.

---

## SQL Execution Order

```
FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY
```

Understanding this order explains two important things:

1. **WHERE runs before GROUP BY** — so you can filter rows before they get grouped.
2. **You cannot use SELECT aliases in GROUP BY** — aliases are created in the SELECT step, which runs after GROUP BY.

```sql
-- ❌ WRONG — alias created in SELECT, not available in GROUP BY yet
SELECT customer, SUM(total) AS total_spent
FROM orders
GROUP BY customer
ORDER BY total_spent DESC;   -- ORDER BY can use alias ✅

-- But GROUP BY cannot:
GROUP BY total_spent;        -- ❌ this would fail
```

---

## Combining WHERE and GROUP BY

`WHERE` filters rows **before** grouping. This means only the filtered rows are included in each group's calculation.

```sql
-- Only count completed orders per customer
SELECT
  customer,
  COUNT(*) AS completed_orders,
  SUM(total) AS completed_revenue
FROM orders
WHERE status = 'completed'    -- filter rows first
GROUP BY customer             -- then group
ORDER BY completed_revenue DESC;
```

**Result:** Only completed orders are counted. Cancelled and pending orders are excluded before grouping happens.

---

## Common Mistakes

### Mistake 1 — Non-aggregate column not in GROUP BY

```sql
-- ❌ Error
SELECT customer, product, COUNT(*)
FROM orders
GROUP BY customer;

-- ✅ Fix: add product to GROUP BY, or remove it from SELECT
SELECT customer, COUNT(*)
FROM orders
GROUP BY customer;
```

### Mistake 2 — Trying to filter aggregate in WHERE

```sql
-- ❌ Error — WHERE cannot use aggregate functions
SELECT customer, COUNT(*)
FROM orders
WHERE COUNT(*) >= 2
GROUP BY customer;

-- ✅ Fix: use HAVING instead
SELECT customer, COUNT(*)
FROM orders
GROUP BY customer
HAVING COUNT(*) >= 2;
```

> This is exactly why `HAVING` exists — to filter groups after aggregation. More on this in the next topic.

---

## Quick Reference

| Situation | Clause to use |
|---|---|
| Filter rows before grouping | `WHERE` |
| Filter groups after aggregation | `HAVING` |
| Every non-aggregate column in SELECT | Must be in `GROUP BY` |
| Group by multiple columns | `GROUP BY col1, col2` |

---



*SQL Learning Journey — Phase 2 Intermediate Queries*