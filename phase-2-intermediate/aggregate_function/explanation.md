# SQL Phase 2 — Aggregate Functions

> **Topic:** COUNT, SUM, AVG, MIN, MAX  
> **Level:** Intermediate  
> **Language:** English

---

## What is an Aggregate Function?

An aggregate function processes **multiple rows at once** and returns **a single summary value**. Instead of seeing every individual row, you get back one number — like a total, an average, or the highest value in a column.

**Analogy:**  
Imagine you have a gradebook with 30 students. Aggregate functions answer questions like:
- *"How many students are there?"* → `COUNT`
- *"What is the sum of all scores?"* → `SUM`
- *"What is the class average?"* → `AVG`
- *"Who scored the lowest?"* → `MIN`
- *"Who scored the highest?"* → `MAX`

All of them process the **entire list** and return **one answer**.

---

## Sample Data

Table `orders` used in all examples below:

| id | customer | product    | total  | status    |
|----|----------|------------|--------|-----------|
| 1  | Ana      | Kue Lapis  | 45000  | completed |
| 2  | Budi     | Nastar     | NULL   | cancelled |
| 3  | Ana      | Brownies   | 30000  | completed |
| 4  | Cici     | Putu Ayu   | 60000  | completed |
| 5  | Budi     | Bolu       | 20000  | pending   |
| 6  | Cici     | Kue Lapis  | NULL   | cancelled |
| 7  | Doni     | Nastar     | 80000  | completed |

> **Note:** Rows id=2 and id=6 have total = NULL. This is important for understanding how each function behaves differently.

---

## 1. COUNT — Counting Rows

**Purpose:** Counts the number of rows in a dataset.

### Two Variants of COUNT

#### `COUNT(*)` — Count all rows including NULL

```sql
SELECT COUNT(*) AS total_rows
FROM orders;
-- result: 7
```

#### `COUNT(column)` — Count only rows where the column is NOT NULL

```sql
SELECT COUNT(total) AS non_null_count
FROM orders;
-- result: 5 (rows id=2 and id=6 with NULL are skipped)
```

### COUNT(*) vs COUNT(column)

| | `COUNT(*)` | `COUNT(column)` |
|---|---|---|
| Counts NULL? | ✅ Yes | ❌ No |
| Use case | Total number of rows | How many rows have a value |

> **Important:** The difference between `COUNT(*)` and `COUNT(column)` is a classic interview question — make sure you know it!

---

## 2. SUM — Adding Up Values

**Purpose:** Adds up all values in a column. Rows with NULL are automatically skipped.

```sql
SELECT SUM(total) AS total_revenue
FROM orders;
-- result: 235000
-- (45000 + 30000 + 60000 + 20000 + 80000 = 235000)
-- Rows id=2 and id=6 with NULL are not included
```

### With a WHERE filter

```sql
SELECT SUM(total) AS completed_revenue
FROM orders
WHERE status = 'completed';
-- result: 215000 (45000 + 30000 + 60000 + 80000)
```

---

## 3. AVG — Average Value

**Purpose:** Calculates the average. NULL values are ignored — the divisor is the number of NON-NULL rows, not the total row count.

```sql
SELECT AVG(total) AS average_order
FROM orders;
-- result: 47000
-- 235000 ÷ 5 = 47000 (NOT ÷ 7!)
```

> **Watch out:** AVG divides by the number of **non-NULL** rows, not the total rows. This often causes unexpected results when NULL values are present.

---

## 4. MIN — Smallest Value

**Purpose:** Returns the smallest value in a column. NULL is ignored.

```sql
SELECT MIN(total) AS smallest_order
FROM orders;
-- result: 20000 (Budi's order - Bolu)
```

---

## 5. MAX — Largest Value

**Purpose:** Returns the largest value in a column. NULL is ignored.

```sql
SELECT MAX(total) AS largest_order
FROM orders;
-- result: 80000 (Doni's order - Nastar)
```

---

## Combined — All Functions in One Query

Multiple aggregate functions can be used together in a single `SELECT`:

```sql
SELECT
  COUNT(*)          AS total_orders,
  COUNT(total)      AS orders_with_value,
  SUM(total)        AS total_revenue,
  AVG(total)        AS average_order,
  MIN(total)        AS smallest_order,
  MAX(total)        AS largest_order
FROM orders;
```

**Result:**

| total_orders | orders_with_value | total_revenue | average_order | smallest_order | largest_order |
|---|---|---|---|---|---|
| 7 | 5 | 235000 | 47000 | 20000 | 80000 |

---

## Key Rule — NULL Behavior

All aggregate functions **ignore NULL**, except `COUNT(*)`.

| Function | NULL Behavior |
|---|---|
| `COUNT(*)` | Counts NULL — all rows included |
| `COUNT(column)` | Skips NULL |
| `SUM(column)` | Skips NULL |
| `AVG(column)` | Skips NULL — divisor also decreases |
| `MIN(column)` | Skips NULL |
| `MAX(column)` | Skips NULL |

---

## SQL Execution Order

Important to understand before moving on to `GROUP BY` and `HAVING`:

```
FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY
```

Aggregate functions are calculated at the **SELECT** stage, after `WHERE` has already filtered the rows.

---

## What's Next

Once you're comfortable with aggregate functions, the next steps are:

1. **GROUP BY** — aggregate per group (e.g. total per customer)
2. **HAVING** — filter GROUP BY results based on aggregate conditions

---

*SQL Learning Journey — Phase 2 Intermediate Queries*