-- Employee Compensation Analysis | PostgreSQL
-- Synthetic employee records; do not use for real pay decisions.
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
 employee_id INT PRIMARY KEY, department VARCHAR(30), job_role VARCHAR(35),
 location VARCHAR(25), hire_date DATE, salary NUMERIC(12,2), performance_rating NUMERIC(2,1)
);
INSERT INTO employees VALUES
(1,'Technology','Data Analyst','Pune','2022-04-11',720000,4.2),
(2,'Technology','Developer','Mumbai','2021-08-20',980000,4.5),
(3,'Finance','Accountant','Pune','2023-01-15',540000,3.8),
(4,'HR','HR Executive','Nashik','2022-11-02',480000,3.9),
(5,'Technology','Data Analyst','Mumbai','2024-02-01',650000,4.0),
(6,'Sales','Sales Executive','Pune','2023-06-18',510000,3.6),
(7,'Finance','Finance Manager','Mumbai','2020-03-10',1250000,4.4),
(8,'HR','HR Manager','Pune','2019-07-22',1050000,4.3),
(9,'Sales','Sales Executive','Nashik','2024-01-08',470000,3.4),
(10,'Technology','Developer','Pune','2022-09-30',910000,4.1),
(11,'Finance','Accountant','Nashik','2024-05-12',520000,3.7),
(12,'Sales','Sales Manager','Mumbai','2020-12-01',1100000,4.2);
-- 1. Workforce and payroll KPIs
SELECT COUNT(*) AS headcount, ROUND(AVG(salary),2) AS avg_salary,
 SUM(salary) AS annual_payroll FROM employees;
-- 2. Department compensation
SELECT department, COUNT(*) AS headcount, ROUND(AVG(salary),2) AS avg_salary,
 MIN(salary) AS min_salary, MAX(salary) AS max_salary
FROM employees GROUP BY department ORDER BY avg_salary DESC;
-- 3. Role-level salary benchmarks
SELECT job_role, COUNT(*) AS employees, ROUND(AVG(salary),2) AS avg_salary
FROM employees GROUP BY job_role ORDER BY avg_salary DESC;
-- 4. Salary ranking within each department
SELECT employee_id, department, job_role, salary,
 DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_salary_rank
FROM employees;
-- 5. Salary band distribution
SELECT CASE WHEN salary<500000 THEN 'Below 5L' WHEN salary<800000 THEN '5L-8L'
 WHEN salary<1100000 THEN '8L-11L' ELSE '11L+' END AS salary_band, COUNT(*) AS employees
FROM employees GROUP BY 1 ORDER BY 1;
-- 6. Tenure and salary
SELECT employee_id, hire_date, ROUND((CURRENT_DATE-hire_date)/365.25,1) AS tenure_years, salary
FROM employees ORDER BY tenure_years DESC;
-- 7. Rating vs salary (descriptive only)
SELECT performance_rating, COUNT(*) AS employees, ROUND(AVG(salary),2) AS avg_salary
FROM employees GROUP BY performance_rating ORDER BY performance_rating;
-- 8. Department share of payroll
SELECT department, SUM(salary) AS payroll,
 ROUND(100.0*SUM(salary)/SUM(SUM(salary)) OVER (),2) AS payroll_share_pct
FROM employees GROUP BY department ORDER BY payroll DESC;
