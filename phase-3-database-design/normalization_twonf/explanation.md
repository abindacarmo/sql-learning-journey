# Database Normalization — Second Normal Form (2NF)

> Part of the `sql-learning-journey` notes — building on 1NF to eliminate partial dependency.

---

## Table of Contents
1. [Quick Recap: 1NF](#1-quick-recap-1nf)
2. [What is Second Normal Form (2NF)?](#2-what-is-second-normal-form-2nf)
3. [What is a Functional Dependency?](#3-what-is-a-functional-dependency)
4. [What is Partial Dependency?](#4-what-is-partial-dependency)
5. [Important: 2NF Only Applies to Composite Keys](#5-important-2nf-only-applies-to-composite-keys)
6. [Example: A Table That Violates 2NF](#6-example-a-table-that-violates-2nf)
7. [Fixing the Table to Follow 2NF](#7-fixing-the-table-to-follow-2nf)
8. [2NF in PostgreSQL Syntax](#8-2nf-in-postgresql-syntax)
9. [The Anomalies 2NF Prevents](#9-the-anomalies-2nf-prevents)
10. [Common Mistakes When Applying 2NF](#10-common-mistakes-when-applying-2nf)
11. [Quick Summary](#11-quick-summary)

---

## 1. Quick Recap: 1NF

Before 2NF makes sense, a table must already satisfy **1NF**:
- Every column holds a single, atomic value (no comma-separated lists)
- No repeating groups of columns (no `subject_1`, `subject_2`, `subject_3`)
- Every row is uniquely identifiable

2NF is the **next step after 1NF** — it doesn't replace those rules, it adds a new one on top.

---

## 2. What is Second Normal Form (2NF)?

A table is in **Second Normal Form (2NF)** if:

> It is already in 1NF, **and** every non-key column depends on the **entire** primary key — not just part of it.

In plain terms: 2NF eliminates **partial dependency** — a situation where a column only relies on *one piece* of a composite primary key, rather than the whole key together.

---

## 3. What is a Functional Dependency?

Before understanding "partial dependency," it helps to understand **functional dependency** first.

We say **column B depends on column A** (written `A → B`) if, given a specific value of A, you always know exactly what B's value must be.

**Example:**
```
student_id → student_name
```
If you know the `student_id`, you always know exactly which student's name that refers to. That's a functional dependency.

---

## 4. What is Partial Dependency?

**Partial dependency** happens only in tables that use a **composite primary key** (a primary key made of two or more columns — covered in our earlier PK/FK notes).

It occurs when a non-key column depends on **only one part** of the composite key, instead of depending on the full combination of both key columns together.

**Example of the problem:**

If a table has composite key `(student_id, course_id)`, and a column like `student_name` only actually depends on `student_id` alone (not on `course_id` at all), that's a **partial dependency** — and it violates 2NF.

---

## 5. Important: 2NF Only Applies to Composite Keys

This is a detail that trips a lot of learners up:

> If a table's primary key is a **single column** (like `student_id` alone), that table automatically satisfies 2NF as long as it's already in 1NF.

Why? Because partial dependency can only exist when there's "part of a key" to depend on. If the key is just one column, there's no "part" to be partially dependent on — every non-key column either depends on that single key, or it doesn't belong in the table at all.

**2NF is only a concern for tables with composite primary keys** — most commonly, junction/bridge tables used for many-to-many relationships.

---

## 6. Example: A Table That Violates 2NF

Imagine a table tracking student course enrollments, storing extra details directly in the same table:

**`enrollments` (NOT in 2NF)**

| student_id | course_id | student_name | course_name | enrollment_date |
|---|---|---|---|---|
| 1 | 101 | Ana | Database Systems | 2026-01-10 |
| 1 | 102 | Ana | Web Development | 2026-01-12 |
| 2 | 101 | Budi | Database Systems | 2026-01-15 |

**Primary Key:** `(student_id, course_id)` — a composite key.

**What's wrong here?**

Look closely at each non-key column:

| Column | What it actually depends on | Problem? |
|---|---|---|
| `student_name` | Only `student_id` (not `course_id`) | ❌ Partial dependency |
| `course_name` | Only `course_id` (not `student_id`) | ❌ Partial dependency |
| `enrollment_date` | Both `student_id` AND `course_id` together | ✅ Fine — this one is a full dependency |

`student_name` and `course_name` are **repeated unnecessarily**: notice "Ana" appears twice, and "Database Systems" appears twice. This repetition is the direct symptom of partial dependency.

---

## 7. Fixing the Table to Follow 2NF

The fix is to **split off the columns that only depend on part of the key** into their own tables, keyed by that single column.

**`students` (student_name depends only on student_id)**

| student_id | student_name |
|---|---|
| 1 | Ana |
| 2 | Budi |

**`courses` (course_name depends only on course_id)**

| course_id | course_name |
|---|---|
| 101 | Database Systems |
| 102 | Web Development |

**`enrollments` (only what truly depends on the full composite key)**

| student_id | course_id | enrollment_date |
|---|---|---|
| 1 | 101 | 2026-01-10 |
| 1 | 102 | 2026-01-12 |
| 2 | 101 | 2026-01-15 |

Now:
- `student_name` is stored **once** per student, in the `students` table
- `course_name` is stored **once** per course, in the `courses` table
- `enrollments` only holds data that genuinely depends on the *combination* of `student_id` and `course_id` — in this case, the enrollment date

If you need a student's name or a course's name, you simply `JOIN` back to the relevant table.

---

## 8. 2NF in PostgreSQL Syntax

```sql
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL
);

CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL
);

CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
```

Getting the full picture back with a join:

```sql
SELECT s.student_name, c.course_name, e.enrollment_date
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;
```

---

## 9. The Anomalies 2NF Prevents

Going back to the un-normalized `enrollments` table from Section 6:

| Anomaly | Example |
|---|---|
| **Update anomaly** | If Ana changes her name, you'd have to update `student_name` in every single row where she appears — miss one, and the data becomes inconsistent. |
| **Insert anomaly** | You can't record a new student's name unless they enroll in at least one course, since `student_name` only exists inside the `enrollments` table. |
| **Delete anomaly** | If Budi drops his only course, deleting that row also deletes the only record that Budi's name (`Budi`) ever existed — even though he might still be an active student. |

Splitting into separate `students` and `courses` tables (Section 7) directly solves all three problems.

---

## 10. Common Mistakes When Applying 2NF

- ❌ **Assuming every table needs 2NF review.** If a table already has a single-column primary key, it automatically satisfies 2NF — there's nothing to check for partial dependency.
- ❌ **Forgetting to check every non-key column individually.** Some columns might correctly depend on the full composite key (like `enrollment_date` in our example) while others don't — you have to check them one at a time, not assume the whole table is fine or broken as a unit.
- ❌ **Confusing 2NF with 1NF.** 1NF is about atomic values and repeating groups. 2NF is specifically about *where a non-key column's dependency points* within a composite key — a completely different kind of problem.
- ❌ **Over-splitting tables that don't actually have a composite key.** Don't apply 2NF-style splitting to a table with a simple single-column primary key just out of habit — it's unnecessary and adds complexity for no benefit.

---

## 11. Quick Summary

- **2NF** requires a table to already be in 1NF, **and** have no partial dependency — meaning every non-key column must depend on the **whole** composite primary key, not just part of it.
- 2NF only matters for tables with a **composite primary key**. Tables with a single-column primary key automatically satisfy 2NF.
- The telltale sign of a 2NF violation: a value (like a name) is **repeated across multiple rows** because it actually only relates to one part of the composite key.
- The fix: split the columns with partial dependency into their own tables, keyed by whichever single column they truly depend on.

---

*Part of the `sql-learning-journey` notes — next up: Third Normal Form (3NF) and transitive dependency.*
