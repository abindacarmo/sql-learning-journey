# LIKE & WILDCARDS

> Both are wildcards used with ```LIKE```, but they differ in how many characters they substitute:
> - % = matches zero or more characters — any length, even empty
> - _ = matches exactly one character — no more, no less

Think of % as "anything goes here", while _ means "there must be exactly one character here".


# % vs _ — What's the Difference?

Both `%` and `_` are **wildcards** used with the `LIKE` operator in SQL. The difference is how many characters they match:

- `%` = matches **zero or more characters**
- `_` = matches **exactly one character**

## Simple Examples

| Pattern | Matches |
|----------|----------|
| `'A%'` | Adam, Alice, A, Apple |
| `'%son'` | Jackson, Wilson, Anderson |
| `'_at'` | Cat, Bat, Hat |
| `'A___'` | Amir, Alex, Anna |
| `'__'` | Any text with exactly 2 characters |

## Easy Analogy

- `%` = "Anything can go here."
- `_` = "There must be exactly one character here."

## Quick Summary

| Wildcard | Meaning |
|-----------|-----------|
| `%` | Matches zero, one, or many characters |
| `_` | Matches exactly one character |

## Examples in SQL

### Names Starting with "A"

```sql
SELECT name
FROM users
WHERE name LIKE 'A%';
```

### Names Ending with "n"

```sql
SELECT name
FROM users
WHERE name LIKE '%n';
```

### Names Containing "an"

```sql
SELECT name
FROM users
WHERE name LIKE '%an%';
```

### Names with Exactly 4 Characters

```sql
SELECT name
FROM users
WHERE name LIKE '____';
```

### Names Starting with "A" and Ending with "n"

```sql
SELECT name
FROM users
WHERE name LIKE 'A%n';
```

## Remember

- Use `%` when you don't know how many characters are in between.
- Use `_` when you need an exact number of characters.
- You can combine both `%` and `_` in the same pattern.

Example:

```sql
SELECT name
FROM users
WHERE name LIKE 'A__%n';
```

This means:

- Starts with `A`
- Followed by at least 2 characters
- Ends with `n`

## NOT LIKE

`NOT LIKE` is used to exclude rows that match a pattern.

### Examples

#### Names NOT Starting with "A"

```sql
SELECT name
FROM users
WHERE name NOT LIKE 'A%';
```

#### Names NOT Ending with "n"

```sql
SELECT name
FROM users
WHERE name NOT LIKE '%n';
```

#### Names NOT Containing "an"

```sql
SELECT name
FROM users
WHERE name NOT LIKE '%an%';
```

#### Names NOT Having Exactly 4 Characters

```sql
SELECT name
FROM users
WHERE name NOT LIKE '____';
```

## Quick Comparison

| LIKE | NOT LIKE |
|--------|--------|
| Includes matching patterns | Excludes matching patterns |
| `LIKE 'A%'` → Alan, Anna | `NOT LIKE 'A%'` → Bob, John |
| `LIKE '%n'` → Alan, John | `NOT LIKE '%n'` → Alex, Bob |