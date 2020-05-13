-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/4vsllR

-- Drop tables
DROP TABLE DeptEmp;
DROP TABLE Salaries;
DROP TABLE DeptManager;
DROP TABLE Departments;
DROP TABLE Employees;
DROP TABLE Titles;

-- Create tables
CREATE TABLE Employees (
    emp_no INT NOT NULL,
    emp_title_id VARCHAR(30)   NOT NULL,
    birth_date date   NOT NULL,
    first_name VARCHAR(30)   NOT NULL,
    last_name VARCHAR(30)   NOT NULL,
    sex VARCHAR(1)   NOT NULL,
    hire_date date   NOT NULL,
    CONSTRAINT pk_Employees PRIMARY KEY (
        emp_no
     )
);

CREATE TABLE DeptManager (
    dept_no VARCHAR   NOT NULL,
    emp_no INT   NOT NULL
);

CREATE TABLE DeptEmp (
    emp_no INT   NOT NULL,
    dept_no VARCHAR   NOT NULL
);

CREATE TABLE Departments (
    dept_no VARCHAR   NOT NULL,
    dept_name VARCHAR   NOT NULL,
    CONSTRAINT pk_Departments PRIMARY KEY (
        dept_no
     )
);

CREATE TABLE Salaries (
    emp_no INT   NOT NULL,
    salary INT   NOT NULL
);

CREATE TABLE Titles (
    title_id VARCHAR   NOT NULL,
    title VARCHAR   NOT NULL,
    CONSTRAINT pk_Titles PRIMARY KEY (
        title_id
     )
);

-- Import csv files before adding FKs

ALTER TABLE Employees ADD CONSTRAINT fk_Employees_emp_title_id FOREIGN KEY(emp_title_id)
REFERENCES Titles (title_id);

ALTER TABLE DeptManager ADD CONSTRAINT fk_DeptManager_dept_no FOREIGN KEY(dept_no)
REFERENCES Departments (dept_no);

ALTER TABLE DeptManager ADD CONSTRAINT fk_DeptManager_emp_no FOREIGN KEY(emp_no)
REFERENCES Employees (emp_no);

ALTER TABLE DeptEmp ADD CONSTRAINT fk_DeptEmp_emp_no FOREIGN KEY(emp_no)
REFERENCES Employees (emp_no);

ALTER TABLE DeptEmp ADD CONSTRAINT fk_DeptEmp_dept_no FOREIGN KEY(dept_no)
REFERENCES Departments (dept_no);

ALTER TABLE Salaries ADD CONSTRAINT fk_Salaries_emp_no FOREIGN KEY(emp_no)
REFERENCES Employees (emp_no);

--Check tables
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM departments;
SELECT * FROM deptemp;
SELECT * FROM deptmanager;
SELECT * FROM titles;


-- 1. List the following details of each employee: employee number, last name, first name, sex, and salary.
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM salaries AS s
INNER JOIN employees AS e ON
e.emp_no = s.emp_no;


-- 2. List first name, last name, and hire date for employees who were hired in 1986.
-- Extract year from hire_date
SELECT EXTRACT(YEAR FROM hire_date) FROM employees;

-- Include subquery hire_year, where year is 1986
SELECT first_name, last_name, hire_date,(
	SELECT EXTRACT(YEAR FROM hire_date)) AS hire_year 
FROM employees WHERE (
	SELECT EXTRACT(YEAR FROM hire_date)) = 1986;


-- 3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.
-- deptmanager (dept_no, emp_no) + department (dept_name) + employees (last_name, first_name)
SELECT dm.dept_no, dm.emp_no AS manager_emp_no, d.dept_name, e.last_name AS manager_last_name, e.first_name AS manager_first_name
FROM employees AS e 
INNER JOIN deptmanager AS dm 
ON e.emp_no = dm.emp_no 
INNER JOIN departments AS d 
ON dm.dept_no = d.dept_no;


-- 4. List the department of each employee with the following information: employee number, last name, first name, and department name.
-- employee (emp_no, last_name, first_name) + deptemp (departments(dept_name))
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e, departments AS d, deptemp AS de
WHERE (e.emp_no = de.emp_no) AND (d.dept_no = de.dept_no);


-- 5. List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
-- Select employees named Hercules
SELECT first_name, last_name, sex 
FROM employees
WHERE first_name = 'Hercules' AND
last_name LIKE 'B%';


-- 6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e, departments AS d, deptemp AS de
WHERE (e.emp_no = de.emp_no) AND (d.dept_no = de.dept_no) AND (dept_name = 'Sales');


-- 7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
-- 
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e, departments AS d, deptemp AS de
WHERE (e.emp_no = de.emp_no) AND (d.dept_no = de.dept_no) AND ((dept_name = 'Sales') OR (dept_name = 'Development'));

-- 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT last_name, count(*) AS "Last_name_frequency"
FROM employees
GROUP BY last_name
HAVING COUNT(*) > 1
ORDER BY last_name DESC;

-- Check if correct; you're welcome, LEO!
SELECT COUNT(last_name) FROM employees WHERE last_name = 'Zykh'

