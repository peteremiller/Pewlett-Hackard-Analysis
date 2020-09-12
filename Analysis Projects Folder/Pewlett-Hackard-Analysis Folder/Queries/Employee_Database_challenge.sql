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
SELECT employees.emp_no, birth_date, first_name, last_name,
	 titles.title, 
	 titles.from_date, 
	 titles.to_date
INTO retirement_titles
FROM titles	
INNER JOIN employees
ON employees.emp_no = titles.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY employees.emp_no;

--SELECT * FROM retirement_titles
--DROP TABLE retirement_titles

--Use the Distinct ON statement to retrieve the first occurance of the emp_no
--for each set of rows defined by the ON() clause.
SELECT DISTINCT ON (retirement_titles.emp_no) retirement_titles.emp_no,
	retirement_titles.first_name,
	retirement_titles.last_name,
	retirement_titles.title
INTO unique_titles
FROM retirement_titles
ORDER BY retirement_titles.emp_no ASC, retirement_titles.to_date DESC

--Create a Unique Titles table using the INTO clause
SELECT COUNT (unique_titles.title), unique_titles.title
INTO retiring_titles
FROM unique_titles
GROUP BY unique_titles.title
ORDER BY COUNT (unique_titles.title) DESC;

SELECT * FROM retiring_titles

--Create a table to hold the employees who are eligible to participate 
-- in a mentorship program: Mentorship Eligibiliy.
SELECT DISTINCT ON (employees.emp_on) employees.emp_no,
	employees.first_name,
	employees.last_name,
	employees.birth_date,