-- Basic Queries:
-- 1. List all students along with their details.
SELECT * FROM Students;

-- 2. Find the total number of courses offered by the university.
SELECT COUNT(*) AS total_courses FROM Courses;

-- 3. Show the names of all students enrolled in a specific course.
SELECT s.first_name, s.last_name FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Introduction to Computer Science';

-- 4. Retrieve the email addresses of all instructors in a department.
SELECT email FROM Instructors
WHERE department = 'Computer Science';

-- Intermediate Queries:
-- 5. List all courses along with the number of students enrolled.
SELECT c.course_name, COUNT(*) AS number_of_students_enrolled FROM Courses c
JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;

-- 6. Find the students who were enrolled in a course with a grade of 'A'.
SELECT s.first_name, s.last_name FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE e.grade = 'A';

-- 7. Retrieve the courses and the instructors assigned for a specific semester.
SELECT c.course_name, i.first_name, i.last_name FROM Courses c
JOIN CourseAssignments ca ON c.course_id = ca.course_id
JOIN Instructors i ON ca.instructor_id = i.instructor_id
WHERE ca.semester = 'Fall';

-- 8. Find the average grade for a particular course.
SELECT c.course_name, AVG(e.grade) AS average_grade FROM Enrollments e
JOIN Courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Introduction to Computer Science';


-- Advanced Queries:
-- 9. List students taking more than 3 courses in the current semester.
SELECT s.first_name , s.last_name, COUNT(*) AS number_of_courses FROM students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
GROUP BY c.course_name;

-- 10. Generate a report of students with incomplete grades.
SELECT s.first_name, s.last_name FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE e.grade = 'F';

-- 11. Show the student with the highest average grade across courses.
SELECT s.first_name, s.last_name, AVG(e.grade) AS average_grade FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
ORDER BY average_grade DESC
LIMIT 1;

-- 12. Find the department with the most courses taught this year.
SELECT c.department, COUNT(c.course_id) AS course_count FROM Courses c
JOIN CourseAssignments ca ON c.course_id = ca.course_id
WHERE ca.year = '2023'
LIMIT 1;


-- 13. List courses with no student enrollments.
SELECT c.course_name FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
WHERE e.enrollment_id IS NULL;

-- Step 4: Functions and Aggregates
-- 1. Create a function to calculate a student's age based on date_of_birth.

-- 2. Create a stored procedure to enroll a student in a course.

-- 3. Use aggregate functions to show average grades by department.
SELECT c.department, AVG(e.grade) AS average_grade FROM Courses c
JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.department;

-- Step 5: Constraints and Transactions
-- 1. Add a constraint to ensure unique student emails.
ALTER TABLE Students
ADD CONSTRAINT unique_email UNIQUE (email);

-- 2. Write a transaction to enroll a student if the course capacity isn't exceeded.

-- Step 6: Optimization and Indexes
-- 1. Create an index on the course_code to speed up searches.
CREATE INDEX idx_course_code
ON Courses(course_code);

-- 2. Optimize a query using EXPLAIN to fetch students enrolled in a course.
EXPLAIN 
SELECT s.student_id, s.first_name, s.last_name, e.course_id FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
WHERE e.course_id = 101;

-- Step 7: Joins
-- 1. Write an inner join to fetch students and the courses they are enrolled in.
SELECT s.student_id, s.first_name, s.last_name, c.course_name, c.course_code FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Courses c ON e.course_id = c.course_id;


-- 2. Write a left join to show instructors and courses they teach.
SELECT i.instructor_id, i.first_name, i.last_name, c.course_name, c.course_code FROM Instructors i
LEFT JOIN CourseAssignments ca ON i.instructor_id = ca.instructor_id
LEFT JOIN Courses c ON ca.course_id = c.course_id;


-- 3. Write a query using union to list all students and instructors.
SELECT 'Student' AS role, first_name, last_name, email FROM Students
UNION
SELECT 'Instructor' AS role, first_name, last_name, email FROM Instructors;

-- Step 8: Final Challenge
-- Generate a report showing each student's name, email, major, courses enrolled, instructor, grades, and total
-- credits.
SELECT 
    s.first_name AS student_first_name,
    s.last_name AS student_last_name,
    s.email AS student_email,
    s.major,
    c.course_name,
    c.course_code,
    i.first_name AS instructor_first_name,
    i.last_name AS instructor_last_name,
    e.grade,
    c.credits,
    SUM(c.credits) OVER (PARTITION BY s.student_id) AS total_credits
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Courses c ON e.course_id = c.course_id
INNER JOIN CourseAssignments ca ON c.course_id = ca.course_id
INNER JOIN Instructors i ON ca.instructor_id = i.instructor_id
ORDER BY s.student_id, c.course_name;



