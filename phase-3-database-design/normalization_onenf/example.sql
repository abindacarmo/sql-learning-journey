-- here are the examples
-- okay the next i wanna show the queries that correct and incorrect that violet the rules of 1NF

-- number 1 the incorrect

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    phone_numbers VARCHAR(255)  -- contain: '081234567, 081987654'
);
-- it means this query is incorrect, because the column phone_numbers that can to contain the most value of number_phone,
-- and it already to violet the rules

-- number 2 the correct

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100)
);

CREATE TABLE student_phones (
    phone_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(student_id),
    phone_number VARCHAR(20)  -- cuma satu nomor per baris
);

-- that is the correct one because separate two tables and make relatioship between these tables(student and student_phone)
-- it will be a student can have one or more phone_numbers and the repeat is the student_id.

-- number 3 the incorrect
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    skill_1 VARCHAR(50),
    skill_2 VARCHAR(50),
    skill_3 VARCHAR(50)
);
-- that is incorrect, because that table has three columns that have same data types,
-- if student B has a 4 skill we will change structure table again, and if student B only has 3 skill the other one column will NULL

-- number 3 the correct
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE employee_skills (
    skill_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    skill_name VARCHAR(50)  -- one skill per row, one student can has a most total skill
);


