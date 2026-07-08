# Primary Key & Foreign Key in SQL

> Understanding unique identity and table relationships — the foundation of relational databases.

---

## Table of Contents
1. [What is a Primary Key?](#1-what-is-a-primary-key)
2. [Characteristics of a Primary Key](#2-characteristics-of-a-primary-key)
3. [Types of Primary Keys](#3-types-of-primary-keys)
4. [Primary Key Syntax (PostgreSQL)](#4-primary-key-syntax-postgresql)
5. [What is a Foreign Key?](#5-what-is-a-foreign-key)
6. [Characteristics of a Foreign Key](#6-characteristics-of-a-foreign-key)
7. [Foreign Key Syntax (PostgreSQL)](#7-foreign-key-syntax-postgresql)
8. [Referential Integrity](#8-referential-integrity)
9. [ON DELETE and ON UPDATE Actions](#9-on-delete-and-on-update-actions)
10. [Primary Key vs Foreign Key — Comparison Table](#10-primary-key-vs-foreign-key--comparison-table)
11. [Full Example: Two Related Tables](#11-full-example-two-related-tables)
12. [Common Mistakes to Avoid](#12-common-mistakes-to-avoid)
13. [Quick Summary](#13-quick-summary)

---

## 1. What is a Primary Key?

A **Primary Key (PK)** is a column (or combination of columns) in a table that **uniquely identifies each row** in that table. Think of it like a national ID number, a student ID, or a passport number — no two people share the same one, and every person must have one.

In a database table, the primary key guarantees that:
- Every row can be found and referenced without ambiguity.
- No two rows are exact duplicates in terms of identity.

**Real-world analogy:**
Imagine a classroom of students. Two students might share the same name ("Maria"), but each student has a unique **Student ID**. That Student ID is the primary key — it's the one thing guaranteed to be different for every student.

---

## 2. Characteristics of a Primary Key

A valid primary key must follow these rules:

| Rule | Explanation |
|------|-------------|
| **Uniqueness** | No two rows can have the same primary key value. |
| **Not Null** | A primary key column can never contain a `NULL` value — every row must have an identity. |
| **Immutability (best practice)** | The value should not change over time, since other tables may reference it. |
| **One per table** | A table can only have **one** primary key (though that key can consist of multiple columns — see composite keys below). |
| **Automatically indexed** | Most database systems (including PostgreSQL) automatically create an index on the primary key, making lookups faster. |

---

## 3. Types of Primary Keys

### a) Single-Column Primary Key
Uses just one column as the unique identifier.

```sql
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL
);
```

### b) Composite Primary Key
Uses **two or more columns together** to form uniqueness. This is common in "junction tables" that represent many-to-many relationships.

```sql
CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    PRIMARY KEY (student_id, course_id)
);
```

Here, a single `student_id` or `course_id` can repeat, but the **combination** of both must be unique — meaning one student can't enroll in the same course twice.

### c) Natural Key vs Surrogate Key
- **Natural Key**: A real-world attribute that is already unique (e.g., a national ID number, an email address).
- **Surrogate Key**: An artificial, system-generated identifier with no business meaning (e.g., `SERIAL`, `UUID`, auto-increment integer). Surrogate keys are generally preferred because natural keys can sometimes change or aren't guaranteed to be unique.

---

## 4. Primary Key Syntax (PostgreSQL)

**Method 1 — Inline declaration:**
```sql
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);
```

**Method 2 — Table constraint (useful for composite keys):**
```sql
CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    CONSTRAINT pk_order_items PRIMARY KEY (order_id, product_id)
);
```

**Method 3 — Adding a primary key to an existing table:**
```sql
ALTER TABLE customers
ADD CONSTRAINT pk_customers PRIMARY KEY (customer_id);
```

---

## 5. What is a Foreign Key?

A **Foreign Key (FK)** is a column (or set of columns) in one table that **refers to the Primary Key of another table**. It is what creates the actual *relationship* between two tables.

**Real-world analogy:**
Think of an order receipt at a store. The receipt has a "Customer ID" written on it — that ID doesn't describe the receipt itself, it *points back* to a specific customer stored in the customer records. The receipt's Customer ID is a foreign key referencing the customer's primary key.

In short:
> **Primary Key** = "This is who/what I am."
> **Foreign Key** = "This is who/what I belong to."

---

## 6. Characteristics of a Foreign Key

| Rule | Explanation |
|------|-------------|
| **References a Primary Key (or Unique key)** | A foreign key must point to a column that is guaranteed unique in the parent table. |
| **Can contain duplicates** | Unlike a primary key, a foreign key value *can* repeat — many rows in the "child" table can reference the same row in the "parent" table. |
| **Can be NULL (usually)** | Unless explicitly restricted, a foreign key can be `NULL`, meaning "no relationship assigned yet." |
| **Enforces referential integrity** | The database will not allow a foreign key value that doesn't exist in the referenced table. |
| **Can exist in the same table (self-reference)** | For example, an `employees` table where `manager_id` references `employee_id` in the same table. |

---

## 7. Foreign Key Syntax (PostgreSQL)

**Method 1 — Inline declaration:**
```sql
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE DEFAULT CURRENT_DATE
);
```

**Method 2 — Named constraint (recommended for clarity):**
```sql
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE DEFAULT CURRENT_DATE,
    CONSTRAINT fk_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);
```

**Method 3 — Adding a foreign key to an existing table:**
```sql
ALTER TABLE orders
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id) REFERENCES customers(customer_id);
```

---

## 8. Referential Integrity

**Referential integrity** is the rule that guarantees relationships between tables always stay valid. It means:

1. You **cannot insert** a foreign key value that doesn't exist in the parent table.
   ```sql
   -- This will FAIL if customer_id = 999 does not exist in customers
   INSERT INTO orders (customer_id) VALUES (999);
   ```

2. You **cannot delete** a row from the parent table if it is still referenced by a child table — unless you define a cascading behavior (explained next).
   ```sql
   -- This will FAIL if orders still reference customer_id = 5
   DELETE FROM customers WHERE customer_id = 5;
   ```

This protection prevents "orphan records" — child rows that point to a parent that no longer exists.

---

## 9. ON DELETE and ON UPDATE Actions

When defining a foreign key, you can tell the database **what to do** when the referenced parent row is deleted or updated:

```sql
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
```

| Action | Meaning |
|--------|---------|
| `CASCADE` | Automatically delete/update the child rows when the parent row is deleted/updated. |
| `SET NULL` | Set the foreign key column to `NULL` when the parent row is deleted. |
| `SET DEFAULT` | Set the foreign key column to its default value. |
| `RESTRICT` | Block the delete/update if any child row still references it (strictest option). |
| `NO ACTION` | Similar to `RESTRICT`, but the check can be deferred until the end of the transaction (this is PostgreSQL's default). |

**Example scenario:**
If a `customers` table uses `ON DELETE CASCADE` for its relationship with `orders`, deleting a customer will automatically delete all of their orders too. If it instead uses `ON DELETE RESTRICT`, PostgreSQL will refuse to delete the customer until all their orders are removed or reassigned first.

---

## 10. Primary Key vs Foreign Key — Comparison Table

| Aspect | Primary Key | Foreign Key |
|--------|-------------|--------------|
| **Purpose** | Uniquely identifies a row in its own table | Links a row to a row in another (or the same) table |
| **Uniqueness** | Must be unique | Can have duplicate values |
| **Null allowed?** | Never | Usually allowed, unless restricted |
| **Number per table** | Only one (can be composite) | Can have multiple foreign keys in one table |
| **Automatically indexed?** | Yes | Not always (should be indexed manually for performance) |
| **Where does the value come from?** | Generated or entered directly in that table | Copied from a primary key value in another table |

---

## 11. Full Example: Two Related Tables

```sql
-- Parent table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Child table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE DEFAULT CURRENT_DATE,
    total_amount NUMERIC(10,2),
    CONSTRAINT fk_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE CASCADE
);

-- Insert a customer
INSERT INTO customers (full_name, email)
VALUES ('Brigida Carmo', 'brigida@example.com');

-- Insert an order linked to that customer
INSERT INTO orders (customer_id, total_amount)
VALUES (1, 25.50);

-- Query: get every order along with the customer's name
SELECT o.order_id, c.full_name, o.total_amount, o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;
```

**What's happening here:**
- `customers.customer_id` is the **Primary Key** — the unique identity of each customer.
- `orders.customer_id` is the **Foreign Key** — it points back to `customers.customer_id`, meaning "this order belongs to this customer."
- The `JOIN` at the end works *because* of this relationship — this is the whole reason primary keys and foreign keys exist: to make joining related data possible and reliable.

---

## 12. Common Mistakes to Avoid

- ❌ **Forgetting to index foreign key columns.** PostgreSQL indexes primary keys automatically, but *not* foreign keys — this can slow down joins on large tables. Add an index manually:
  ```sql
  CREATE INDEX idx_orders_customer_id ON orders(customer_id);
  ```
- ❌ **Using a "meaningful" natural key that might change** (e.g., using someone's email as a primary key — what happens when they change their email?). Prefer surrogate keys (`SERIAL`/`UUID`) for stability.
- ❌ **Not deciding on `ON DELETE` behavior**, leading to unexpected `RESTRICT` errors in production when trying to delete parent records.
- ❌ **Confusing `UNIQUE` with `PRIMARY KEY`.** A table can have several `UNIQUE` columns, but only one `PRIMARY KEY`. Also, `UNIQUE` columns *can* be `NULL` (multiple times, depending on the database), while a `PRIMARY KEY` cannot.
- ❌ **Creating a composite primary key when a simple surrogate key would be simpler to manage** in application code and future joins.

---

## 13. Quick Summary

- **Primary Key** → guarantees a row's unique identity within its own table. Never null, always unique, one per table.
- **Foreign Key** → creates a link from a "child" table to a "parent" table's primary key. Enforces that relationships stay valid (referential integrity).
- Together, they are the mechanism that lets relational databases avoid duplicate/inconsistent data and allow you to `JOIN` related tables meaningfully.
- Choosing the right `ON DELETE`/`ON UPDATE` behavior is a design decision that affects how your data behaves when related records are removed or changed.

---

*Part of the `sql-learning-journey` notes — next up: exploring these concepts hands-on in PostgreSQL with `aprende_db`.*
