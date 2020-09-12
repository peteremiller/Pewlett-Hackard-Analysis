-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp (
	dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    PRIMARY KEY (dept_no, emp_no)
);

CREATE TABLE salaries (
  	emp_no INT NOT NULL,
  	salary INT NOT NULL,
  	from_date DATE NOT NULL,
  	to_date DATE NOT NULL,
  	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
  	dept_no VARCHAR(4) NOT NULL,
  	emp_no INT NOT NULL,
  	from_date DATE NOT NULL,
  	to_date DATE NOT NULL,
  	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
  	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  	PRIMARY KEY (dept_no, emp_no)
);	

 CREATE TABLE titles (
  	emp_no INT NOT NULL,
  	title VARCHAR(40) NOT NULL,
	from_date DATE NOT NULL,
  	to_date DATE NOT NULL,
  	PRIMARY KEY (emp_no, title, from_date)
);	

SELECT emp_no, birth_date, first_name, last_name
FROM employees

SELECT title, from_date, to_date
FROM titles

--Joining employees and titles for new retirement titles table
SELECT e.emp_no, birth_date, first_name, last_name,
	 t.title, 
	 t.from_date, 
	 t.to_date
INTO retirement_titles
FROM titles	as t
INNER JOIN employees as e
ON e.emp_no = t.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

--SELECT * FROM retirement_titles
--DROP TABLE retirement_titles

--Use the Distinct ON statement to retrieve the first occurance of the emp_no
--for each set of rows defined by the ON() clause.
SELECT DISTINCT ON (rts.emp_no) rts.emp_no,
	rts.first_name,
	rts.last_name,
	rts.title
INTO unique_titles
FROM retirement_titles as rts
ORDER BY rts.emp_no ASC, rts.title DESC;

--Create a Unique Titles table using the INTO clause to get the number of employees who are
--about to retire. Order the query by their most recent job desc.
SELECT COUNT (ut.title), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY COUNT (ut.title) DESC;

SELECT * FROM unique_titles

--Create a table to hold the employees who are eligible to participate 
-- in a mentorship program: Mentorship Eligibiliy.
--Retrieve the emp_no, first_name, last_name, and birth_date columns from the Employees table.
SELECT DISTINCT ON (e.emp_on) e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
--Retrieve the from_date and to_date columns from the Department Employee table.
	dept_emp.from_date,
	dept_emp.to_date,
--Retrieve the title column from the Titles table.
	t.title
INTO mentorship_eligibility
FROM e, dept_emp, t
--Use a DISTINCT ON statement to retrieve the first occurrence of the employee number 
--for each set of rows defined by the ON () clause.
INNER JOIN departments as d 
ON (e.emp_no = dept_emp.emp_no)
INNER JOIN 
ON (e.emp_no = t.emp_no)
--Filter the data on the to_date column to get current employees whose birth dates
--are between January 1, 1965 and December 31, 1965.
WHERE (to_date BETWEEN '1965-01-01' AND '1965-12-31')
--Order the table by the employee number.
ORDER BY e.emp_no