# LEFT JOIN & RIGHT JOIN

## What is a JOIN?

A JOIN combines rows from two or more tables using a related column.

---

# LEFT JOIN

A LEFT JOIN returns:

- All rows from the left table
- Matching rows from the right table
- NULL when no match exists

## Syntax

```sql
SELECT *
FROM table1
LEFT JOIN table2
ON table1.id = table2.id;
```

### Example

Customers

| customer_id | name |
|------------|------|
| 1 | Alice |
| 2 | Bob |
| 3 | Charlie |

Orders

| order_id | customer_id |
|----------|------------|
| 101 | 1 |
| 102 | 2 |

Query:

```sql
SELECT
    c.name,
    o.order_id
FROM Customers c
LEFT JOIN Orders o
ON c.customer_id = o.customer_id;
```

Result:

| name | order_id |
|------|----------|
| Alice | 101 |
| Bob | 102 |
| Charlie | NULL |

### Use Case

Find records that do not have a match.

Example:

```sql
SELECT c.*
FROM Customers c
LEFT JOIN Orders o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
```

---

# RIGHT JOIN

A RIGHT JOIN returns:

- All rows from the right table
- Matching rows from the left table
- NULL when no match exists

## Syntax

```sql
SELECT *
FROM table1
RIGHT JOIN table2
ON table1.id = table2.id;
```

### Example

Orders

| order_id | customer_id |
|----------|------------|
| 101 | 1 |
| 102 | 2 |
| 103 | 5 |

Query:

```sql
SELECT
    c.name,
    o.order_id
FROM Customers c
RIGHT JOIN Orders o
ON c.customer_id = o.customer_id;
```

Result:

| name | order_id |
|------|----------|
| Alice | 101 |
| Bob | 102 |
| NULL | 103 |

### Use Case

Keep all rows from the second table, even when no match exists.

---

# LEFT JOIN vs RIGHT JOIN

| LEFT JOIN | RIGHT JOIN |
|------------|------------|
| Keeps all rows from the left table | Keeps all rows from the right table |
| Missing matches become NULL | Missing matches become NULL |
| More commonly used | Less commonly used |

---

# Memory Trick

LEFT JOIN

```sql
FROM Customers
LEFT JOIN Orders
```

→ Keep all Customers.

RIGHT JOIN

```sql
FROM Customers
RIGHT JOIN Orders
```

→ Keep all Orders.