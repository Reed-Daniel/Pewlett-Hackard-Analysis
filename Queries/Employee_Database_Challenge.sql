-- The Number of Retiring Employees by Title
SELECT em.emp_no, 
        em.first_name, 
        em.last_name,
	    ti.title, 
        ti.from_date, 
        ti.to_date
	INTO retiring_emp_by_title
	FROM employees AS em
	LEFT JOIN titles as ti
	ON (em.emp_no = ti.emp_no)
	WHERE (em.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	ORDER BY em.emp_no;

-- check results
SELECT * FROM retiring_emp_by_title;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no, 
	first_name, 
    last_name, 
    title
INTO unique_titles
FROM retiring_emp_by_title
ORDER BY emp_no ASC, to_date DESC;

--check results
SELECT * FROM unique_titles;

-- retrieve the number of employees by their most recent job title who are about to retire.
SELECT COUNT(title), title 
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT(title) DESC;

--check results
SELECT * FROM retiring_titles;

--create a Mentorship Eligibility table that holds the employees who are eligible to participate in a mentorship program.
SELECT DISTINCT ON (em.emp_no) 
		em.emp_no, 
		em.first_name, 
		em.last_name, 
		em.birth_date, 
		de.from_date, 
		de.to_date, 
		ti.title
INTO mentorship_elegible 
FROM employees AS em
LEFT JOIN dept_emp AS de
ON em.emp_no = de.emp_no
LEFT JOIN titles AS ti
ON em.emp_no = ti.emp_no
WHERE (em.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01')
ORDER BY em.emp_no;

--check results
SELECT * FROM mentorship_elegible;

-- determine elegible mentorship by title
SELECT COUNT(title), title 
INTO mentor_titles
FROM mentorship_elegible
GROUP BY title
ORDER BY COUNT(title) DESC;

SELECT * FROM mentor_titles;

--create query to determine retirees by department
SELECT DISTINCT ON (emp_no)
    emp_no,
    dept_no,
    to_date
INTO dept_filter
FROM dept_emp
ORDER BY emp_no ASC, to_date DESC;

SELECT un.emp_no,
       un.title,
       de.dept_no,
       de.to_date,
       du.dept_name
INTO dept_unique
FROM unique_titles AS un
LEFT JOIN dept_filter AS de
ON un.emp_no = de.emp_no
LEFT JOIN departments AS du
ON de.dept_no = du.dept_no;

SELECT COUNT(emp_no) AS emp_count, dept_name
FROM dept_unique
GROUP BY dept_name
ORDER By emp_count DESC;