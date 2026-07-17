# ER Diagram — Visually Mapping Entity Relationships

> Part of the `sql-learning-journey` notes — turning the Primary Key, Foreign Key, and Normalization concepts into a visual blueprint before writing any SQL.

---

## Table of Contents
1. [What is an ER Diagram?](#1-what-is-an-er-diagram)
2. [Why Draw an ER Diagram Before Writing SQL?](#2-why-draw-an-er-diagram-before-writing-sql)
3. [The Three Core Building Blocks](#3-the-three-core-building-blocks)
4. [Types of Attributes](#4-types-of-attributes)
5. [Types of Relationships (Cardinality)](#5-types-of-relationships-cardinality)
6. [Crow's Foot Notation — The Symbols You'll See Most](#6-crows-foot-notation--the-symbols-youll-see-most)
7. [Example: Building an ER Diagram Step by Step](#7-example-building-an-er-diagram-step-by-step)
8. [From ER Diagram to SQL](#8-from-er-diagram-to-sql)
9. [Weak Entities](#9-weak-entities)
10. [Common Mistakes When Drawing ER Diagrams](#10-common-mistakes-when-drawing-er-diagrams)
11. [Quick Summary](#11-quick-summary)

---

## 1. What is an ER Diagram?

An **Entity-Relationship Diagram (ER Diagram / ERD)** is a visual map that shows:
- What "things" (entities) exist in a system — like `Student`, `Course`, `Order`, `Product`
- What information (attributes) each thing holds
- How those things are connected to each other (relationships)

It's essentially the **blueprint of a database**, drawn *before* any `CREATE TABLE` statement is written — the same way an architect draws a floor plan before construction begins.

**Real-world analogy:**
Think of an ER diagram like a family tree, but instead of showing who's related to whom by blood, it shows how different pieces of data in your system relate to each other — "one student can enroll in many courses," "one order belongs to exactly one customer," and so on.

---

## 2. Why Draw an ER Diagram Before Writing SQL?

- **Catches design problems early.** It's much cheaper to redraw a box on paper than to restructure a live database full of data.
- **Communicates the design to others.** A diagram is far easier for a teammate (or your future self) to understand at a glance than a wall of `CREATE TABLE` statements.
- **Directly maps to normalization concepts.** Every entity typically becomes a table, and 1NF/2NF/3NF rules (from our earlier notes) are much easier to apply once you can *see* which attributes belong to which entity.
- **Makes relationships explicit.** It forces you to decide up front: is this a one-to-many relationship? A many-to-many? That decision determines whether you need a Foreign Key or a full junction table.

---

## 3. The Three Core Building Blocks

### a) Entity
A real-world object or concept that you want to store data about. Drawn as a **rectangle**.

Examples: `Student`, `Course`, `Customer`, `Order`, `Product`.

An entity becomes a **table** once you translate the diagram into SQL.

### b) Attribute
A property or characteristic that describes an entity. Drawn as an **oval** connected to its entity (in classic Chen notation), or listed inside the entity box (in modern/Crow's Foot notation, which is more common today and closer to how tables actually look).

Examples: `Student` has attributes `student_id`, `full_name`, `email`.

An attribute becomes a **column** once translated into SQL.

### c) Relationship
Describes how two (or more) entities are connected. Drawn as a **diamond** in classic notation, or simply as a **line** between entity boxes in modern notation.

Examples: `Student` **enrolls in** `Course`. `Customer` **places** `Order`.

---

## 4. Types of Attributes

| Type | Description | Example |
|---|---|---|
| **Simple attribute** | Cannot be broken down further | `age`, `email` |
| **Composite attribute** | Can be broken into smaller parts | `full_name` → `first_name` + `last_name` |
| **Derived attribute** | Calculated from another attribute, not stored directly | `age` derived from `birth_date` |
| **Multi-valued attribute** | Can hold more than one value — this is exactly the kind of attribute that 1NF tells us to split into its own table | `phone_numbers` (a student can have several) |
| **Key attribute** | Uniquely identifies the entity — becomes the Primary Key | `student_id` |

Notice how **multi-valued attributes** connect directly back to the 1NF notes: in an ER diagram, they're usually drawn as a double oval (in Chen notation) as a visual warning sign that this attribute will need to become its own related entity.

---

## 5. Types of Relationships (Cardinality)

**Cardinality** describes *how many* instances of one entity can relate to *how many* instances of another. This is the single most important decision an ER diagram forces you to make, because it changes your table design.

| Type | Meaning | Example |
|---|---|---|
| **One-to-One (1:1)** | One record in Entity A relates to exactly one record in Entity B, and vice versa | One `Employee` has one `EmployeeBadge` |
| **One-to-Many (1:N)** | One record in Entity A can relate to many records in Entity B, but each record in B relates to only one in A | One `Customer` places many `Orders` |
| **Many-to-Many (M:N)** | Many records in Entity A can relate to many records in Entity B | Many `Students` enroll in many `Courses` |

**How cardinality affects your SQL design:**

| Cardinality | How it's implemented |
|---|---|
| 1:1 | A Foreign Key on either table (often with a `UNIQUE` constraint) |
| 1:N | A Foreign Key on the "many" side, pointing back to the "one" side |
| M:N | A separate **junction table** (like `enrollments` from our PK/FK notes) with a composite primary key |

---

## 6. Crow's Foot Notation — The Symbols You'll See Most

Modern ER diagrams (including the ones you'll typically build in tools like dbdiagram.io, draw.io, or pgAdmin's ER view) use **Crow's Foot notation** to show cardinality directly on the connecting line:

```
One and only one:        ──┼──
Zero or one:              ──o┤
One or many:              ──┼<
Zero or many:              ──o<
```

**Reading a relationship line:**
```
Customer ──┼──────────────┼< Order
         (exactly 1)   (zero or many)
```
This reads as: *"one Customer can have zero or many Orders, and every Order belongs to exactly one Customer."*

The "crow's foot" (the ` < ` fork shape) is what gives this notation its name — it visually looks like a bird's foot at the "many" end of the relationship.

---

## 7. Example: Building an ER Diagram Step by Step

Let's design a simple ordering system using entities we've already used in past notes: `Customer`, `Order`, `Product`.

**Step 1 — Identify the entities:**
```
Customer   Order   Product
```

**Step 2 — Identify attributes for each entity:**
```
Customer                Order                    Product
---------                -----                    -------
customer_id (PK)         order_id (PK)             product_id (PK)
name                     order_date                product_name
email                    customer_id (FK)           price
```

**Step 3 — Identify relationships and cardinality:**
- One `Customer` can place many `Orders`, but each `Order` belongs to exactly one `Customer` → **1:N**
- One `Order` can include many `Products`, and one `Product` can appear in many `Orders` → **M:N**

**Step 4 — Draw it out (text representation):**

```
┌────────────┐          ┌────────────┐          ┌────────────┐
│  Customer  │ 1      N │   Order    │ N      M │   Product  │
├────────────┤──────────├────────────┤──────────├────────────┤
│ customer_id│          │ order_id   │          │ product_id │
│ name       │          │ order_date │          │ product_name│
│ email      │          │ customer_id│          │ price      │
└────────────┘          └────────────┘          └────────────┘
```

**Step 5 — Notice the M:N relationship needs a junction table.**

Because `Order` and `Product` have a many-to-many relationship, you can't just add a Foreign Key on either side — you need a junction table in between, exactly like the `enrollments` table from our PK/FK notes:

```
┌────────────┐     ┌──────────────┐     ┌────────────┐
│   Order    │ 1 N │ order_items  │ N 1 │   Product  │
├────────────┤─────├──────────────┤─────├────────────┤
│ order_id   │     │ order_id (FK)│     │ product_id │
│ order_date │     │ product_id(FK)│     │ product_name│
│ customer_id│     │ quantity     │     │ price      │
└────────────┘     └──────────────┘     └────────────┘
```

This is the same `order_items` structure we worked through in the 2NF notes — the ER diagram is what would have told us upfront that this junction table was needed.

---

## 8. From ER Diagram to SQL

Once the diagram is settled, translating it into SQL is mostly mechanical:

```sql
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    order_date DATE DEFAULT CURRENT_DATE,
    customer_id INT REFERENCES customers(customer_id)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price NUMERIC(10,2)
);

CREATE TABLE order_items (
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, product_id)
);
```

**The translation pattern:**

| ER Diagram Element | Becomes in SQL |
|---|---|
| Entity | Table (`CREATE TABLE`) |
| Attribute | Column |
| Key attribute | `PRIMARY KEY` |
| 1:N relationship | `FOREIGN KEY` on the "many" side |
| M:N relationship | A new junction table with a composite `PRIMARY KEY` |

---

## 9. Weak Entities

A **weak entity** is an entity that **cannot be uniquely identified by its own attributes alone** — it depends on another entity (called the *owner* or *identifying* entity) for its identity.

**Example:** Imagine an `OrderItem` that only makes sense in the context of a specific `Order` — it doesn't have meaning on its own. In Chen notation, a weak entity is drawn with a **double-bordered rectangle**, and its identifying relationship with a **double-bordered diamond**.

This maps directly to something we've already covered: a weak entity is usually the same thing as a table with a **composite primary key that includes a Foreign Key**, like `enrollments(student_id, course_id)` or `order_items(order_id, product_id)`.

---

## 10. Common Mistakes When Drawing ER Diagrams

- ❌ **Adding attributes that belong to a relationship, not an entity.** For example, `enrollment_date` doesn't belong to `Student` or `Course` alone — it belongs to the *relationship* between them, which is exactly why it ends up in the junction table (`enrollments`), not in either entity's own table.
- ❌ **Not deciding cardinality before designing tables.** Skipping this step is the most common cause of designing a Foreign Key where a junction table was actually needed (or vice versa).
- ❌ **Modeling multi-valued attributes as a single column.** If an attribute can hold more than one value per entity (like `phone_numbers`), draw it as leading to a separate related entity from the start — don't wait until you hit a 1NF violation in SQL to notice it.
- ❌ **Forgetting the direction of a relationship.** "Customer places Order" and "Order is placed by Customer" describe the same relationship, but writing it only in one direction on the diagram can cause confusion later about which side holds the Foreign Key.
- ❌ **Over-complicating the first draft.** A rough sketch with boxes, attributes, and arrows is enough to start; polishing exact Crow's Foot symbols can come after the entities and relationships themselves are settled.

---

## 11. Quick Summary

- An **ER Diagram** visually maps **entities** (things), **attributes** (their properties), and **relationships** (how they connect) — before any SQL is written.
- **Cardinality** (1:1, 1:N, M:N) is the most important decision an ER diagram forces you to make, because it determines whether you need a simple Foreign Key or a full junction table.
- **Crow's Foot notation** is the standard modern way to show cardinality directly on the diagram's connecting lines.
- Every element on the diagram maps directly onto something we've already covered: entities → tables, attributes → columns, key attributes → Primary Keys, and M:N relationships → junction tables with composite Primary Keys (which is also the pattern behind weak entities).

---

*Part of the `sql-learning-journey` notes — with PK/FK, 1NF/2NF/3NF, and ER Diagrams together, you now have the full toolkit for designing a normalized relational database before writing a single `CREATE TABLE` statement.*
