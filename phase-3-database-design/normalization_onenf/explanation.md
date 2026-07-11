# Database Normalization — First Normal Form (1NF)

> Part of the `sql-learning-journey` notes — understanding how to structure tables correctly to avoid data redundancy and anomalies.

---

## Table of Contents
1. [What is Normalization?](#1-what-is-normalization)
2. [Why Do We Need Normalization?](#2-why-do-we-need-normalization)
3. [What is First Normal Form (1NF)?](#3-what-is-first-normal-form-1nf)
4. [The Rules of 1NF](#4-the-rules-of-1nf)
5. [Example: A Table That Violates 1NF](#5-example-a-table-that-violates-1nf)
6. [Fixing the Table to Follow 1NF](#6-fixing-the-table-to-follow-1nf)
7. [Another Common Violation: Repeating Groups](#7-another-common-violation-repeating-groups)
8. [1NF in PostgreSQL Syntax](#8-1nf-in-postgresql-syntax)
9. [Common Mistakes When Applying 1NF](#9-common-mistakes-when-applying-1nf)
10. [Quick Summary](#10-quick-summary)

---

## 1. What is Normalization?

**Normalization** is the process of organizing columns and tables in a relational database to **reduce data redundancy** (duplicate data) and **avoid data anomalies** (inconsistent or incorrect data caused by poor table design).

It works through a series of stages called **Normal Forms**: 1NF, 2NF, 3NF, BCNF, and beyond — each stage builds on the rules of the previous one, making the table design progressively "cleaner."

**Real-world analogy:**
Imagine organizing a messy closet. At first, everything is thrown into one big pile — shirts, pants, shoes, all mixed together. Normalization is like sorting that pile into labeled drawers: one drawer per category, one item per slot. It's more work upfront, but it means you can always find (and update) exactly what you need without digging through everything else.

---

## 2. Why Do We Need Normalization?

Without normalization, tables tend to suffer from **three types of anomalies**:

| Anomaly Type | What Happens |
|---|---|
| **Update Anomaly** | The same piece of data is stored in multiple places, so updating it means you have to change it everywhere — and if you miss one spot, the data becomes inconsistent. |
| **Insert Anomaly** | You can't add certain data without also having unrelated data available (e.g., can't add a new course unless a student is already enrolled in it). |
| **Delete Anomaly** | Deleting one thing accidentally deletes other important information along with it. |

Normalization — starting with 1NF — is the first step in preventing these problems.

---

## 3. What is First Normal Form (1NF)?

**First Normal Form (1NF)** is the most basic level of normalization. A table is in 1NF if:

> Every column contains only a **single, atomic (indivisible) value**, and every row is **uniquely identifiable**.

In other words, 1NF eliminates:
- Multiple values crammed into a single cell (like a comma-separated list)
- Repeating groups of columns (like `phone1`, `phone2`, `phone3`)
- Tables without a way to uniquely identify each row

Think of 1NF as the "cleanup" stage — making sure your table doesn't have cells trying to hold more than one piece of information at once.

---

## 4. The Rules of 1NF

For a table to satisfy 1NF, it must follow these rules:

| Rule | Explanation |
|---|---|
| **Atomic values** | Each column must hold only one value per row — no lists, no combined values separated by commas. |
| **Unique rows** | Every row must be distinguishable from every other row, usually enforced with a Primary Key. |
| **No repeating groups** | You should not have multiple columns representing the same type of data (like `subject1`, `subject2`, `subject3`). |
| **Consistent data type per column** | Every value in a column must be of the same kind of data (e.g., a `phone_number` column shouldn't mix a single number in one row and a list of numbers in another). |

---

## 5. Example: A Table That Violates 1NF

Imagine a table storing student contact information like this:

**`students` (NOT in 1NF)**

| student_id | full_name | phone_numbers |
|---|---|---|
| 1 | Ana | 081234567, 081987654 |
| 2 | Budi | 082211223 |
| 3 | Citra | 081555666, 081777888, 081999000 |

**What's wrong here?**
The `phone_numbers` column holds **multiple values crammed into one cell**, separated by commas. This breaks the "atomic value" rule of 1NF.

**Problems this causes:**
- You can't easily search "find the student who owns phone number `081987654`" — the database would have to do string-matching inside the cell, which is slow and error-prone.
- You can't easily count how many phone numbers each student has.
- Updating or deleting a single phone number means carefully editing a text string instead of a clean row-level operation.

---

## 6. Fixing the Table to Follow 1NF

The fix is to **split the multi-valued column into its own separate table**, connected using a Foreign Key — the same concept we covered in the previous notes.

**`students` (Parent Table — now in 1NF)**

| student_id | full_name |
|---|---|
| 1 | Ana |
| 2 | Budi |
| 3 | Citra |

**`student_phones` (Child Table — one phone number per row)**

| phone_id | student_id | phone_number |
|---|---|---|
| 1 | 1 | 081234567 |
| 2 | 1 | 081987654 |
| 3 | 2 | 082211223 |
| 4 | 3 | 081555666 |
| 5 | 3 | 081777888 |
| 6 | 3 | 081999000 |

**Why this is better:**
- Every cell now holds exactly **one atomic value**.
- Each student can have **as many phone numbers as needed**, without changing the table structure.
- You can search, update, or delete a single phone number directly, without touching a comma-separated string.
- This is the exact same pattern used for a one-to-many relationship, connected through `student_id` as a Foreign Key.

---

## 7. Another Common Violation: Repeating Groups

A second common 1NF violation is using **repeating columns** instead of a proper related table:

**`students` (NOT in 1NF — repeating groups)**

| student_id | full_name | subject_1 | subject_2 | subject_3 |
|---|---|---|---|---|
| 1 | Ana | Math | Physics | NULL |
| 2 | Budi | Chemistry | NULL | NULL |
| 3 | Citra | Math | Biology | English |

**What's wrong here?**
- The number of subjects a student can take is **hardcoded to 3 columns**. What happens when a student takes a 4th subject? You'd have to change the table structure (`ALTER TABLE`) just to add `subject_4`.
- Lots of wasted `NULL` cells for students who take fewer subjects.
- Searching "which students take Math" requires checking three separate columns instead of one.

**The fix (same pattern as before):**

**`enrollments` (Child Table)**

| student_id | subject |
|---|---|
| 1 | Math |
| 1 | Physics |
| 2 | Chemistry |
| 3 | Math |
| 3 | Biology |
| 3 | English |

Now a student can take any number of subjects — 1, 5, or 20 — without ever needing to modify the table structure.

---

## 8. 1NF in PostgreSQL Syntax

Applying the fix from Section 6 as real SQL:

```sql
-- Parent table — atomic, one student per row
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL
);

-- Child table — one phone number per row
CREATE TABLE student_phones (
    phone_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    CONSTRAINT fk_student
        FOREIGN KEY (student_id)
        REFERENCES students(student_id)
        ON DELETE CASCADE
);
```

Querying all phone numbers for a specific student becomes a simple, clean join:

```sql
SELECT s.full_name, p.phone_number
FROM students s
JOIN student_phones p ON s.student_id = p.student_id
WHERE s.full_name = 'Ana';
```

Compare this to trying to extract a single number out of a comma-separated string — this version is far easier to query, filter, and maintain.

---

## 9. Common Mistakes When Applying 1NF

- ❌ **Storing JSON or array data in a single column just to avoid making a new table.** PostgreSQL technically supports array/JSON columns, but if you're storing genuinely relational data (like multiple phone numbers per student), a proper child table is usually still the cleaner, more query-friendly choice.
- ❌ **Assuming 1NF alone is enough.** 1NF only fixes atomicity and repeating groups — it does **not** address redundancy caused by partial or transitive dependencies. That's handled by 2NF and 3NF (topics for later notes).
- ❌ **Forgetting the Primary Key when splitting tables.** Every new child table (like `student_phones`) still needs its own way to uniquely identify each row, even though it's mostly there to support a relationship.
- ❌ **Over-normalizing simple data.** Not every multi-value scenario needs a new table — a single `address` field, for instance, is usually fine as one atomic text value if you don't need to search/filter its individual components.

---

## 10. Quick Summary

- **1NF (First Normal Form)** requires every column to hold a single atomic value, with no repeating groups, and every row to be uniquely identifiable.
- Common violations: comma-separated values in one cell, or multiple numbered columns (`subject_1`, `subject_2`, ...) representing the same kind of data.
- The fix is almost always the same: **split the repeating/multi-valued data into a separate child table**, connected back to the parent using a Foreign Key.
- 1NF is the foundation — the next steps (**2NF**, **3NF**) build further rules on top of it to remove other kinds of redundancy.

---

*Part of the `sql-learning-journey` notes — next up: exploring Second Normal Form (2NF) and partial dependency.*
