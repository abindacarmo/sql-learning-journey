# SQL Phase 2 — INNER JOIN

> **Topic:** Combining Tables — Matching Rows Only  
> **Level:** Intermediate  

---

## What is INNER JOIN?

`INNER JOIN` combines two tables based on a related column and returns **only the rows that have a matching row in both tables**. If a row has no match in the other table, it is completely excluded from the result.

**Analogy:**  
You have two lists — a **customers** list and an **orders** list. INNER JOIN is like matching them up — only customers who have placed an order appear. Customers without orders? Gone. Orders without a valid customer? Gone too.

---

## Key Concepts — Primary Key and Foreign Key

Before using JOIN, you need to understand these two concepts:

- **Primary Key (PK)** → a column with a unique value per row, usually the `id` column
- **Foreign Key (FK)** → a column that references the Primary Key of another table

```
customers table              orders table
─────────────────────        ───────────────────────────
id   ← Primary Key           id
name                          customer_id  ← Foreign Key → references customers.id
city                          product
                              total
```

The linking column is: `customers.id = orders.customer_id`

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

> Notice:
> - **Doni** (id=4) — registered customer but has no orders
> - **Order id=105** — customer_id=99 does not exist in the customers table

---

## Basic Syntax

```sql
SELECT columns_to_display
FROM first_table alias1
INNER JOIN second_table alias2
  ON alias1.linking_column = alias2.linking_column;
```

---

## Examples

### Example 1 — Join customer names with their orders

```sql
SELECT
  c.name,
  c.city,
  o.product,
  o.total
FROM customers c
INNER JOIN orders o
  ON c.id = o.customer_id;
```

**Matching process:**

| customers.id | name | orders.customer_id | product   | match? |
|---|---|---|---|---|
| 1 | Ana  | 1  | Kue Lapis | ✅ match |
| 1 | Ana  | 1  | Brownies  | ✅ match |
| 2 | Budi | 2  | Nastar    | ✅ match |
| 3 | Cici | 3  | Putu Ayu  | ✅ match |
| 4 | Doni | —  | —         | ❌ no match — excluded |
| — | —    | 99 | Bolu      | ❌ no match — excluded |

**Final result — only matched rows:**

| name | city   | product   | total |
|------|--------|-----------|-------|
| Ana  | Dili   | Kue Lapis | 45000 |
| Ana  | Dili   | Brownies  | 60000 |
| Budi | Baucau | Nastar    | 30000 |
| Cici | Dili   | Putu Ayu  | 25000 |

> Doni does not appear. Order id=105 (Bolu) does not appear.

---

### Example 2 — INNER JOIN combined with GROUP BY

```sql
SELECT
  c.name,
  COUNT(o.id)  AS total_orders,
  SUM(o.total) AS total_spent
FROM customers c
INNER JOIN orders o
  ON c.id = o.customer_id
GROUP BY c.name
ORDER BY total_spent DESC;
```

**Result:**

| name | total_orders | total_spent |
|------|-------------|-------------|
| Ana  | 2           | 105000      |
| Budi | 1           | 30000       |
| Cici | 1           | 25000       |

> Doni is not included because INNER JOIN already excluded customers without orders.

---

### Example 3 — INNER JOIN with WHERE filter

```sql
SELECT
  c.name,
  o.product,
  o.total
FROM customers c
INNER JOIN orders o
  ON c.id = o.customer_id
WHERE c.city = 'Dili'
ORDER BY o.total DESC;
```

**Result — only customers from Dili:**

| name | product   | total |
|------|-----------|-------|
| Ana  | Brownies  | 60000 |
| Ana  | Kue Lapis | 45000 |
| Cici | Putu Ayu  | 25000 |

---

### Example 4 — Three tables joined together

```sql
SELECT
  c.name       AS customer,
  o.id         AS order_id,
  p.name       AS product_name,
  p.price
FROM customers c
INNER JOIN orders o    ON c.id = o.customer_id
INNER JOIN products p  ON o.product_id = p.id;
```

> When joining 3+ tables, the result of the first JOIN becomes the "left table" for the next JOIN. Each JOIN needs its own `ON` condition.

---

### Example 5 — Old style (implicit join) vs modern style

```sql
-- Old style — implicit join (same result)
SELECT c.name, o.product
FROM customers c, orders o
WHERE c.id = o.customer_id;

-- Modern style — explicit INNER JOIN (recommended)
SELECT c.name, o.product
FROM customers c
INNER JOIN orders o
  ON c.id = o.customer_id;
```

Both produce **identical results**, but the modern style is preferred because:
1. More readable — JOIN condition is separated from filter conditions
2. Safer with multiple tables — harder to accidentally create a Cartesian Product
3. Easier to extend to LEFT JOIN or RIGHT JOIN later

---

## Why Table Aliases Matter

```sql
-- ❌ Without aliases — ambiguous column name error
SELECT id, name, product
FROM customers
INNER JOIN orders
  ON id = customer_id;
-- Error: column "id" is ambiguous

-- ✅ With aliases — clear and safe
SELECT c.id, c.name, o.product
FROM customers c
INNER JOIN orders o
  ON c.id = o.customer_id;
```

Use short, meaningful aliases:
- `c` for customers
- `o` for orders
- `p` for products or payments (context dependent)

---

## Common Mistakes

### Mistake 1 — Missing ON condition (Cartesian Product)

```sql
-- ❌ Wrong — missing ON creates a Cartesian Product
SELECT * FROM customers
INNER JOIN orders;
-- 4 customers × 5 orders = 20 meaningless rows!

-- ✅ Fix: always include ON
SELECT * FROM customers c
INNER JOIN orders o
  ON c.id = o.customer_id;
```

### Mistake 2 — Ambiguous column names without aliases

```sql
-- ❌ Wrong — which table does "id" come from?
SELECT id, name, product
FROM customers
INNER JOIN orders ON id = customer_id;

-- ✅ Fix: prefix every column with its table alias
SELECT c.id, c.name, o.product
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id;
```

### Mistake 3 — Expecting missing rows to appear

```sql
-- If you need Doni to appear even without orders → use LEFT JOIN, not INNER JOIN
SELECT c.name, o.product
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id;
-- Doni will NOT appear here

-- ✅ Use LEFT JOIN instead
SELECT c.name, o.product
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id;
-- Doni will appear with NULL for product
```

---

## INNER JOIN vs Other JOINs

| JOIN Type | Rows returned |
|---|---|
| `INNER JOIN` | Only rows matching in **both** tables |
| `LEFT JOIN` | All rows from left + matched rows from right |
| `RIGHT JOIN` | All rows from right + matched rows from left |
| `FULL OUTER JOIN` | All rows from both tables |

---

## Quick Reference

```sql
-- Basic INNER JOIN
SELECT a.col, b.col
FROM table_a a
INNER JOIN table_b b
  ON a.id = b.a_id;

-- With filter
SELECT a.col, b.col
FROM table_a a
INNER JOIN table_b b
  ON a.id = b.a_id
WHERE a.status = 'active';

-- With aggregation
SELECT a.col, COUNT(*), SUM(b.value)
FROM table_a a
INNER JOIN table_b b
  ON a.id = b.a_id
GROUP BY a.col;

-- Three tables
SELECT a.col, b.col, c.col
FROM table_a a
INNER JOIN table_b b ON a.id = b.a_id
INNER JOIN table_c c ON b.id = c.b_id;
```