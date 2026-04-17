# What is database & SQL?
**tetum bellow**

## what is database?
> A database is a structured place to store data so it can be easily accessed, managed, and manipulating. Imaigne you work on a data engineering team at an e-commerce company. Everyday, millions of transaction come in - customer data, order data, product data. All of that needs to be stored somewhere organized. That's the role of database.

### what is RDBMS?
>RDBMS (Relational Database Management System) is a system that manages databases based on relationship between tables. Popular RDBMS in the Database engineering world:

|RDBMS|                   |Used for|
------|-------------------|--------|
|PostgreSQL|              |Data warehouse, backend, analytics|
|MySQL|                   |Web applications, OLTP|
|BigQuery|                |Cloud data warehouse (Google)|
|Snowflake|               |Cloud data warehouse|
|Redshift|                |Cloud data warehouse (AWS)|

 - Tables, Rows, Columns
 > In RDBMS, data is stored in tables, similar to a spreadsheet but more powerful.

>Table: orders

>| order_id | customer_id | product  | amount | order_date |
>|----------|-------------|----------|--------|------------|
>| 1        | 101         | Laptop   | 15000  | 2024-01-01 |
>| 2        | 102         | Mouse    | 250    | 2024-01-02 |
>| 3        | 101         | Keyboard | 500    | 2024-01-03 |

- Table: a collection of data about one entity(order, customer, procudcts)
- Row: one record/one piece of data(1 order transaction)
- Column: one attribute of that entity(order-id, amount, etc.)

- Relations
>The power of RDBMS lies in relationship beetwen tables. Tables can be connected to each other.

>Tabela: customers              
>| customer_id | name |
>|-------------|-------|
>| 101         | Budi  |
>| 102         | Ani   | 
>

>Tabela: orders
>| order_id | customer_id | product |
>|----------|-------------|---------|
>| 1        | 101         | Laptop  |
> | 2        | 102         | Mouse   |
>
>The ```customer_id``` column connect these two tables. so we can know Budi bought a Laptop without duplicating the name data in the orders table. this concept will be explorer deeper in the primary key & foreign key topic later.

## What is SQL?
>SQL(Structure Query Language) is the language used to communicate with a database. SQLis divided into several categories:

|Category|Abbreviation|Function|Example|
|--------|------------|--------|-------|
|Data Query Language|DQL|Retrieve data|```SELECT```|
|Data Manipulation Language|DML|Manipulate data|```INSERT```, ```UPDATE```, ```DELETE```|
|Data Definition Language|DDL|Define structure|```CREATE```, ```DROP```, ```ALTER```|
|Data Control Language|DCL|Access rights|```GRANT```, ```REVOKE```|

### Relevance in Data engineering
> As a data engineering, you will use SQL almost every day to:
> - Extract data from source databases (part of ETL/ELT)
> - Transform data - cleaning, aggregation, joining tables
> - Load data into data warehouses like BigQuery or Snowflake
> - Build efficiet data models for modles for analyst and scientist teams