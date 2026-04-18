/*
tetum bellow
please pay your attention, and read the following instruction first:
in this file we are going to do three thing:
1. we're gonna create the table use command CREATE TABLE an then we're gonna give a comment at that line before we're wanna do others thing
2. we're gonna insert data into the table use command INSERT INTO table_name, an then give a comment too at that line before continue
3. last but not least we're gonna show all data in that table use command SELECT *

[TETUM]
favor antes tama iha ne primeiro lee uluk tiha lai instrusaun sira tuir mai:
iha file ida ne'e ita sei halo buat tolu:
1. kria table uza command CREATE TABLE hotu ida ne'e ita sei fo comment tiha linha ne'e rasik depois mak ita sei kontinua fali ba lina seluk
2. ita mos sei aumenta dados ba iha table utiliza comando INSERT INTO naran_tabela hotu ida ne'e ita sei fo comment ba iha linha ne'e rasik
3. ikus, ita sei fo sai hotu dados sira iha table ne'e rasik nia laran utiliza comman SELECT *
*/

-- 1. CREATE TABLE/KRIA TABELA
-- CREATE TABLE employees(employee_id INT, name VARCHAR(100), department VARCHAR(100), salary FLOAT, hire_date DATE); -- create is a command you use to create something like: table or database

-- 2. INSERT DATA/AUMENTA DADOS
-- INSERT INTO employees (employee_id, name, department, salary, hire_date) VALUES
--     (11, 'Binda', 'Engineering', 80000, '2020-09-29'),
--     (12, 'Dito', 'Marketing', 5000, '2022-07-15'),
--     (13, 'João', 'Engineering', 9000, '2020-01-10'),
--     (14, 'Maria', 'HR', 4500, '2023-05-20'),
--     (15, 'Tino', 'Engineering', 7500, '2021-11-30')


-- 3. retrieve data/fo sai dadus sira
SELECT * FROM employees;