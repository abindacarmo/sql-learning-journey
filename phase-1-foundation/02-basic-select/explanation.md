# what is SELECT?
> SELECT  is the most fundamental SQL command. It is used to retrieve data from a table. As a data engineer, you will use SELECT constantly - whether querying raw data from a source system, checking pipeline outputs, or exploring data in a warehouse.

## sample table
> we sill use this table for all example in this topic
>
Table: employees

| employee_id | name        | department  | salary | hire_date  |
|-------------|-------------|-------------|--------|------------|
| 1           | Budi        | Engineering | 8000   | 2021-03-01 |
| 2           | Ani         | Marketing   | 5000   | 2022-07-15 |
| 3           | João        | Engineering | 9000   | 2020-01-10 |
| 4           | Maria       | HR          | 4500   | 2023-05-20 |
| 5           | Tino        | Engineering | 7500   | 2021-11-30 |

## SELECT *
> the ``*`` (asterisk) means "all columns". Use this when you want to see everyting in a table. In data engineering, this often using during data exploration to understand what a table contains before building a pipeline.

```sql
SELECT *
FROM employees;
```
>Result

| employee_id | name  | department  | salary | hire_date  |
|-------------|-------|-------------|--------|------------|
| 1           | Budi  | Engineering | 8000   | 2021-03-01 |
| 2           | Ani   | Marketing   | 5000   | 2022-07-15 |
| 3           | João  | Engineering | 9000   | 2020-01-10 |
| 4           | Maria | HR          | 4500   | 2023-05-20 |
| 5           | Tino  | Engineering | 7500   | 2021-11-30 |

>⚠️ Data engineering note: avoid using ``SELECT *`` in production pipelines! It can cause performance issues when tables hae hundres of columns. Always select only the columns you need.

## SELECT specific columns 
instead of selecting everything, you can specify which columns you want. This is the best practice in data engineering - only pull the data you actually need

```sql
SELECT name, department, salary
FROM employees;
```
>Result

| name  | department  | salary |
|-------|-------------|--------|
| Budi  | Engineering | 8000   |
| Ani   | Marketing   | 5000   |
| João  | Engineering | 9000   |
| Maria | HR          | 4500   |
| Tino  | Engineering | 7500   |

## Alias - AS
>an alias is a temporary name you give to a column or table using ``AS``. In data engineering, aliases are heavily used in dbt models and complec transformation queries to make column names cleaner and more readable

```sql
SELECT 
    name AS employee_name,
    department AS dept,
    salary AS monthly_salary
FROM employees;
```
> Result

| employee_name | dept        | monthly_salary |
|---------------|-------------|----------------|
| Budi          | Engineering | 8000           |
| Ani           | Marketing   | 5000           |
| João          | Engineering | 9000           |
| Maria         | HR          | 4500           |
| Tino          | Engineering | 7500           |

## SELECT with Expression 
> you can also do calculating directly inside ``SELECT``. This is useful in data pipelines when you need to derive new columns from existing data

```sql

SELECT 
    name,
    salary,
    salary * 12 AS annual_salary
FROM employees;
```
>Result

| name  | salary | annual_salary |
|-------|--------|---------------|
| Budi  | 8000   | 96000         |
| Ani   | 5000   | 60000         |
| João  | 9000   | 108000        |
| Maria | 4500   | 54000         |
| Tino  | 7500   | 90000         |


## Relevance in data engineering
> in a real data pipeline, a typical ``SELECT`` query in dbt might lool like this - selecting specific columnd, renaming them for the warehouse layer, and deriving new fields

```sql
-- dbt model: stg_employees.sql
SELECT
    employee_id,
    name AS employee_name,
    department,
    salary AS monthly_salary,
    salary * 12 AS annual_salary,
    hire_date
FROM raw.employees
```

> use RDBMS postgresql
> and here its explanation following:

1. for running file ```.sql```

- mysql
```bash
mysql -u root -p nama_database < file.sql
```
- postgresql
```bash
psql -U postgres -d nama_database -f file.sql
```

- husi psql nia laran
```bash
\i /path/file.sql
```

2. MySQL LAMPP (cause we use linux)
 
 - start 
 ```bash
sudo /opt/lampp/lampp start
```

- login
 ```bash
/opt/lampp/bin/mysql -u root -p
```

- Socket error fix:
 ```bash
mysql -u root -p --socket=/opt/lampp/var/mysql/mysql.sock
```

3. PostgreSQL basic

- in
 ```bash
sudo -u postgres psql
```

- chose DB
 ```bash
\c database_name
```

- list database
 ```bash
\l
```

- list table
 ```bash
\dt
```

4. create table

```sql
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    salary INT,
    hire_date DATE
);
```


4. insert data into table

```sql
INSERT INTO employees (employee_id, name, department, salary, hire_date)
VALUES
(11, 'Binda', 'Engineering', 80000, '2020-09-29'),
(12, 'Dito', 'Marketing', 5000, '2022-07-15');
```
6. Select data

```sql
SELECT * FROM employees;
>
SELECT name, salary FROM employees;
>
SELECT * FROM employees LIMIT 10;
```

7. comment in file .sql we use
```sql
-- single line
>
/* multi line */
```

### 🔹 MySQL vs PostgreSQL Command Comparison

| Feature          | MySQL Command      | PostgreSQL Command |
|------------------|-------------------|--------------------|
| List databases   | SHOW DATABASES    | \l                 |
| List tables      | SHOW TABLES       | \dt                |
| Select database  | USE db            | \c db              |
| Auto increment   | AUTO_INCREMENT    | SERIAL             |