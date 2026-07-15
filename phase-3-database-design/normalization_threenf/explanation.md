# Database Normalization — Third Normal Form (3NF)

> Part of the `sql-learning-journey` notes — building on 2NF to eliminate transitive dependency.

---

## Table of Contents
1. [Quick Recap: 1NF and 2NF](#1-quick-recap-1nf-and-2nf)
2. [What is Third Normal Form (3NF)?](#2-what-is-third-normal-form-3nf)
3. [What is a Transitive Dependency?](#3-what-is-a-transitive-dependency)
4. [3NF Applies Even to Single-Column Primary Keys](#4-3nf-applies-even-to-single-column-primary-keys)
5. [Example: A Table That Violates 3NF](#5-example-a-table-that-violates-3nf)
6. [Fixing the Table to Follow 3NF](#6-fixing-the-table-to-follow-3nf)
7. [3NF in PostgreSQL Syntax](#7-3nf-in-postgresql-syntax)
8. [The Anomalies 3NF Prevents](#8-the-anomalies-3nf-prevents)
9. [2NF vs 3NF — What's the Difference?](#9-2nf-vs-3nf--whats-the-difference)
10. [Common Mistakes When Applying 3NF](#10-common-mistakes-when-applying-3nf)
11. [Quick Summary](#11-quick-summary)

---

## 1. Quick Recap: 1NF and 2NF

- **1NF** → every column holds one atomic value, no repeating groups, every row is uniquely identifiable.
- **2NF** → already in 1NF, and no *partial dependency* (every non-key column depends on the **whole** composite primary key, not just part of it). Only relevant for tables with composite keys.

**3NF** is the next layer on top — and unlike 2NF, it applies to **every table**, whether the primary key is a single column or a composite one.

---

## 2. What is Third Normal Form (3NF)?

A table is in **Third Normal Form (3NF)** if:

> It is already in 2NF, **and** no non-key column depends on another non-key column. Every non-key column must depend on the primary key **directly** — not indirectly, through another column.

In plain terms: 3NF eliminates **transitive dependency** — a chain where column C depends on column B, and column B depends on the primary key A, meaning C only depends on A "through" B.

---

## 3. What is a Transitive Dependency?

Recall functional dependency from the 2NF notes: `A → B` means "given A, you always know B."

A **transitive dependency** happens when:
```
A → B       (primary key → some column)
B → C       (that column → another column)
therefore: A → C, but only indirectly, through B
```

**Example:**
```
student_id → department_id → department_name
```
If you know `student_id`, you can figure out `department_id`. And if you know `department_id`, you can figure out `department_name`. So technically `student_id → department_name`, but only **through** `department_id` — not directly. This chain is the transitive dependency, and 3NF says it shouldn't exist within a single table.

---

## 4. 3NF Applies Even to Single-Column Primary Keys

This is the key difference from 2NF:

> Unlike 2NF (which only matters for composite keys), **3NF applies to every table**, including ones with a simple single-column primary key.

Why? Because transitive dependency isn't about "part of a key" — it's about one non-key column depending on *another non-key column* instead of depending on the key directly. That chain can happen regardless of whether the key is single-column or composite.

---

## 5. Example: A Table That Violates 3NF

Imagine a table storing student information along with their department:

**`students` (NOT in 3NF)**

| student_id | student_name | department_id | department_name |
|---|---|---|---|
| 1 | Ana | D01 | Informatics Engineering |
| 2 | Budi | D02 | Civil Engineering |
| 3 | Citra | D01 | Informatics Engineering |

**Primary Key:** `student_id` (a single column — so this table is already fine for 1NF and 2NF).

**What's wrong here?**

Let's trace the dependency chain:
```
student_id → department_id   (each student belongs to exactly one department)
department_id → department_name   (each department_id maps to exactly one name)
```

So `department_name` depends on `student_id`, but only **indirectly**, through `department_id`. This is a transitive dependency, and it violates 3NF.

**The visible symptom:** notice `"Informatics Engineering"` is repeated for both Ana and Citra. Anytime you see a value repeating across rows because it's tied to a *non-key* column rather than the primary key itself, that's the tell-tale sign of transitive dependency.

---

## 6. Fixing the Table to Follow 3NF

The fix is to **split off the column that depends on another non-key column** into its own table, keyed by that non-key column.

**`departments` (department_name depends only on department_id)**

| department_id | department_name |
|---|---|
| D01 | Informatics Engineering |
| D02 | Civil Engineering |

**`students` (only what depends directly on student_id)**

| student_id | student_name | department_id |
|---|---|---|
| 1 | Ana | D01 |
| 2 | Budi | D02 |
| 3 | Citra | D01 |

Now:
- `department_name` is stored **once** per department, in the `departments` table.
- `students` only keeps `department_id` as a reference (a Foreign Key) — not the full department name.
- If you need the department name for a student, you `JOIN` back to `departments`.

---

## 7. 3NF in PostgreSQL Syntax

```sql
CREATE TABLE departments (
    department_id VARCHAR(10) PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    department_id VARCHAR(10),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);
```

Getting the full picture back with a join:

```sql
SELECT s.student_name, d.department_name
FROM students s
JOIN departments d ON s.department_id = d.department_id;
```

---

## 8. The Anomalies 3NF Prevents

Going back to the un-normalized `students` table from Section 5:

| Anomaly | Example |
|---|---|
| **Update anomaly** | If the Informatics Engineering department is renamed, you'd have to update `department_name` in every row of every student in that department — miss one, and the data becomes inconsistent. |
| **Insert anomaly** | You can't record a new department's name unless at least one student is already enrolled in it, since `department_name` only exists inside the `students` table. |
| **Delete anomaly** | If Budi (the only student in Civil Engineering) is deleted, the fact that a department called "Civil Engineering" with id `D02` ever existed is lost too. |

Splitting off `departments` into its own table (Section 6) solves all three.

---

## 9. 2NF vs 3NF — What's the Difference?

Both 2NF and 3NF are about removing "unwanted dependencies," but on different targets:

| Aspect | 2NF | 3NF |
|---|---|---|
| **Problem it fixes** | Partial dependency | Transitive dependency |
| **What depends on what** | A non-key column depends on *part* of a composite primary key | A non-key column depends on *another non-key column*, not the primary key directly |
| **Applies to** | Only tables with composite primary keys | Every table, regardless of key type |
| **Typical symptom** | Repeated values tied to one piece of a composite key (e.g., student name repeating across course enrollments) | Repeated values tied to a non-key column (e.g., department name repeating across students) |

A simple way to remember the order:
> **1NF**: fix the columns themselves (atomic values). **2NF**: fix dependency on *part* of the key. **3NF**: fix dependency on *columns other than* the key.

---

## 10. Common Mistakes When Applying 3NF

- ❌ **Assuming a single-column primary key means the table is automatically safe.** That assumption is true for 2NF, but **not** for 3NF — transitive dependency can still exist even with a simple primary key, as shown in Section 5.
- ❌ **Confusing a Foreign Key relationship with a transitive dependency problem.** Storing `department_id` as a Foreign Key in `students` is completely fine and expected in 3NF — the issue only appears if you *also* store `department_name` directly in the same table.
- ❌ **Chasing every dependency to the extreme (over-normalization).** Sometimes a small amount of redundancy is intentional for performance reasons (denormalization) — 3NF is a strong default, not an absolute rule that must never be broken in real-world system design.
- ❌ **Forgetting to trace the full chain.** Transitive dependency can sometimes go through more than one hop (A → B → C → D) — check the whole chain, not just the first link.

---

## 11. Quick Summary

- **3NF** requires a table to already be in 2NF, **and** have no transitive dependency — every non-key column must depend on the primary key directly, not through another non-key column.
- Unlike 2NF, **3NF applies to all tables**, not just ones with composite keys.
- The telltale sign of a 3NF violation: a value (like a department name) is **repeated across multiple rows** because it's actually tied to another non-key column, not the primary key itself.
- The fix: split the transitively-dependent column into its own table, keyed by the non-key column it truly depends on, and reference it back with a Foreign Key.

---

*Part of the `sql-learning-journey` notes — 1NF, 2NF, and 3NF together form the most commonly applied "safe baseline" for relational database design.*
