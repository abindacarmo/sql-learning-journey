# SQL Phase 2 — Subquery

> **Topic:** Query Inside a Query (WHERE / FROM / SELECT)
> **Level:** Intermediate

---

## What is a Subquery?

A subquery is a **query nested inside another query**. The inner query runs first, and its result is used as input for the outer query.

Think of it as a **question within a question**:

> *"Show me customers whose spending is above average."*
>
> To answer this, you first need to ask: *"What is the average spending?"* — that's the subquery.
> Once you have that answer, the outer query can filter customers above that number.

**Key rule:** The inner query **always runs first**. Read subqueries from the inside out.

---

## Sample Data

**Table: orders**

| id  | customer | product   | total | status    |
|-----|----------|-----------|-------|-----------|
| 1   | Ana      | Kue Lapis | 45000 | completed |
| 2   | Budi     | Nastar    | 30000 | completed |
| 3   | Ana      | Brownies  | 60000 | completed |
| 4   | Cici     | Putu Ayu  | 25000 | cancelled |
| 5   | Budi     | Bolu      | 20000 | pending   |
| 6   | Doni     | Nastar    | 80000 | completed |
| 7   | Cici     | Kue Lapis | 35000 | completed |
| 8   | Ana      | Putu Ayu  | 15000 | cancelled |

**Table: customers**

| id | name | city    |
|----|------|---------|
| 1  | Ana  | Dili    |
| 2  | Budi | Baucau  |
| 3  | Cici | Dili    |
| 4  | Doni | Maliana |

---

## Three Places to Use a Subquery

| Location | Purpose | Must return |
|---|---|---|
| `WHERE` | Dynamic filter condition | Scalar (1 value) or list |
| `FROM` | Temporary table | A table (multiple rows/columns) |
| `SELECT` | Computed column value | Exactly 1 value (scalar) |

---

## 1. Subquery in WHERE — Dynamic Filter

The most common usage. The inner query result becomes the comparison value in WHERE.

### Example 1a — Scalar subquery (returns one value)

```sql
-- Show orders with total above the average

-- Inner query runs first:
SELECT AVG(total) FROM orders;
-- result: 38750

-- Outer query uses that result:
SELECT customer, product, total
FROM orders
WHERE total > (
  SELECT AVG(total)
  FROM orders
);
```

**Execution flow:**
```
Step 1 — Inner query: SELECT AVG(total) FROM orders → 38750
Step 2 — Outer query: WHERE total > 38750
Step 3 — Return matching rows
```

**Result:**

| customer | product   | total |
|----------|-----------|-------|
| Ana      | Brownies  | 60000 |
| Doni     | Nastar    | 80000 |
| Ana      | Kue Lapis | 45000 |

---

### Example 1b — Subquery with IN (returns multiple values)

```sql
-- Show orders from customers who live in Dili

-- Inner query returns a list of IDs:
SELECT id FROM customers WHERE city = 'Dili';
-- result: [1, 3]  (Ana and Cici)

-- Outer query filters using that list:
SELECT o.id, o.customer, o.product, o.total
FROM orders o
WHERE o.customer_id IN (
  SELECT id
  FROM customers
  WHERE city = 'Dili'
);
```

**Result — only orders from Dili customers:**

| id | customer | product   | total |
|----|----------|-----------|-------|
| 1  | Ana      | Kue Lapis | 45000 |
| 3  | Ana      | Brownies  | 60000 |
| 4  | Cici     | Putu Ayu  | 25000 |
| 7  | Cici     | Kue Lapis | 35000 |

---

### Example 1c — Subquery with NOT IN

```sql
-- Show customers who have NEVER placed an order
SELECT name
FROM customers
WHERE id NOT IN (
  SELECT DISTINCT customer_id
  FROM orders
);
```

---

### Example 1d — Subquery with EXISTS

```sql
-- Show customers who have at least one completed order
SELECT c.name
FROM customers c
WHERE EXISTS (
  SELECT 1
  FROM orders o
  WHERE o.customer_id = c.id
    AND o.status = 'completed'
);
```

> `EXISTS` returns TRUE if the subquery returns any rows at all.
> It's often faster than `IN` for large datasets.

---

## 2. Subquery in FROM — Derived Table

The subquery acts as a temporary table. You query it just like a regular table. **An alias is required.**

### Example 2a — Query a grouped result

```sql
-- Get customers whose total spending is above 50,000
-- (Can't use HAVING here because we want to query an already-aggregated result)

SELECT *
FROM (
  -- This subquery creates a temporary summary table
  SELECT
    customer,
    COUNT(*)   AS total_orders,
    SUM(total) AS total_spent
  FROM orders
  GROUP BY customer
) AS summary                    -- alias is REQUIRED
WHERE summary.total_spent > 50000
ORDER BY summary.total_spent DESC;
```

**The temporary table produced by the subquery:**

| customer | total_orders | total_spent |
|----------|-------------|-------------|
| Ana      | 3           | 120000      |
| Budi     | 2           | 50000       |
| Cici     | 2           | 60000       |
| Doni     | 1           | 80000       |

**Final result after WHERE filter:**

| customer | total_orders | total_spent |
|----------|-------------|-------------|
| Ana      | 3           | 120000      |
| Doni     | 1           | 80000       |
| Cici     | 2           | 60000       |

---

### Example 2b — Rank customers by spending

```sql
SELECT
  customer,
  total_spent,
  RANK() OVER (ORDER BY total_spent DESC) AS spending_rank
FROM (
  SELECT customer, SUM(total) AS total_spent
  FROM orders
  GROUP BY customer
) AS summary;
```

---

## 3. Subquery in SELECT — Computed Column

The subquery adds a calculated column to each row. **Must return exactly one value (scalar).**

### Example 3a — Show each order's total vs overall average

```sql
SELECT
  customer,
  total,
  (SELECT AVG(total) FROM orders) AS overall_avg,
  total - (SELECT AVG(total) FROM orders) AS diff_from_avg
FROM orders
ORDER BY diff_from_avg DESC;
```

**Result:**

| customer | total | overall_avg | diff_from_avg |
|----------|-------|-------------|---------------|
| Doni     | 80000 | 38750       | +41250        |
| Ana      | 60000 | 38750       | +21250        |
| Ana      | 45000 | 38750       | +6250         |
| Cici     | 35000 | 38750       | -3750         |
| Budi     | 30000 | 38750       | -8750         |
| Cici     | 25000 | 38750       | -13750        |
| Budi     | 20000 | 38750       | -18750        |
| Ana      | 15000 | 38750       | -23750        |

---

### Example 3b — Show each customer's total alongside grand total

```sql
SELECT
  customer,
  SUM(total) AS customer_total,
  (SELECT SUM(total) FROM orders) AS grand_total,
  ROUND(SUM(total) * 100.0 / (SELECT SUM(total) FROM orders), 2) AS percentage
FROM orders
GROUP BY customer
ORDER BY customer_total DESC;
```

---

## Scalar vs Multi-Row Subqueries

| Type | Returns | Used with |
|---|---|---|
| Scalar | Exactly 1 value | `=`, `>`, `<`, `>=`, `<=` |
| Multi-row | Multiple values | `IN`, `NOT IN`, `ANY`, `ALL` |
| Table | Multiple rows and columns | `FROM` clause (derived table) |

```sql
-- ❌ Wrong — using = with a multi-row subquery
SELECT * FROM orders
WHERE customer_id = (
  SELECT id FROM customers WHERE city = 'Dili'
);
-- Error: subquery returns more than one row!

-- ✅ Fix: use IN instead
SELECT * FROM orders
WHERE customer_id IN (
  SELECT id FROM customers WHERE city = 'Dili'
);
```

---

## Correlated vs Non-Correlated Subqueries

### Non-Correlated Subquery
Runs **once**, independently of the outer query. The inner query does not reference the outer query.

```sql
-- Inner query runs once, result is reused
SELECT customer, total
FROM orders
WHERE total > (SELECT AVG(total) FROM orders);
```

### Correlated Subquery
Runs **once per row** of the outer query. The inner query references the outer query.

```sql
-- Inner query runs once for each row in the outer query
SELECT c.name
FROM customers c
WHERE EXISTS (
  SELECT 1 FROM orders o
  WHERE o.customer_id = c.id    -- references outer query's c.id
);
```

> Correlated subqueries can be slow on large datasets because the inner query re-runs for every outer row. Consider using JOIN instead when performance matters.

---

## Subquery vs JOIN — When to Use Which

| Situation | Prefer |
|---|---|
| Filter based on aggregate (avg, max, etc.) | Subquery in WHERE |
| Check existence of related rows | `EXISTS` subquery |
| Need columns from both tables in result | JOIN |
| Better readability for simple filters | Subquery |
| Better performance on large data | JOIN (usually) |

```sql
-- Subquery approach
SELECT name FROM customers
WHERE id IN (SELECT customer_id FROM orders WHERE status = 'completed');

-- JOIN approach (same result, usually faster)
SELECT DISTINCT c.name
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id
WHERE o.status = 'completed';
```

---

## Common Mistakes

### Mistake 1 — Using = with a multi-row subquery

```sql
-- ❌ Error if subquery returns more than one row
WHERE customer_id = (SELECT id FROM customers WHERE city = 'Dili')

-- ✅ Fix: use IN
WHERE customer_id IN (SELECT id FROM customers WHERE city = 'Dili')
```

### Mistake 2 — Missing alias on FROM subquery

```sql
-- ❌ Error — subquery in FROM must have an alias
SELECT * FROM (
  SELECT customer, SUM(total) FROM orders GROUP BY customer
);

-- ✅ Fix: add alias
SELECT * FROM (
  SELECT customer, SUM(total) AS total_spent
  FROM orders GROUP BY customer
) AS summary;
```

### Mistake 3 — Subquery in SELECT returns more than one value

```sql
-- ❌ Error — SELECT subquery must return exactly one value
SELECT customer, (SELECT total FROM orders) AS t FROM orders;
-- Error: subquery returns more than one row

-- ✅ Fix: make sure it returns one value
SELECT customer, (SELECT AVG(total) FROM orders) AS avg_total FROM orders;
```

---

## Quick Reference

```sql
-- Subquery in WHERE (scalar)
SELECT * FROM table
WHERE column > (SELECT AVG(column) FROM table);

-- Subquery in WHERE (list)
SELECT * FROM table
WHERE id IN (SELECT id FROM other_table WHERE condition);

-- Subquery in FROM (derived table)
SELECT * FROM (
  SELECT col, AGG_FUNC(col2) AS alias
  FROM table
  GROUP BY col
) AS summary
WHERE summary.alias > value;

-- Subquery in SELECT (scalar)
SELECT col,
  (SELECT AGG_FUNC(col) FROM table) AS computed_col
FROM table;
```