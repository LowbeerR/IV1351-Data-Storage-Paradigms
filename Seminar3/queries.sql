-- VIEW FOR LESSONS PER MONTH 2023
CREATE VIEW lesson_count_per_month_2023 AS
SELECT 
EXTRACT (MONTH FROM CAST (lesson.date AS timestamp)) AS month,
COUNT(*)
FROM lesson
WHERE EXTRACT(YEAR FROM CAST(lesson.date AS timestamp)) = 2023
GROUP BY month;

-- VIEW FOR NR OF EACH LESSON PER MONTH 2023
CREATE VIEW lesson_type_count_per_month_2023 AS
SELECT lesson_type,
EXTRACT (MONTH FROM CAST (lesson.date AS timestamp)) AS month,
COUNT(*)
FROM lesson
WHERE EXTRACT(YEAR FROM CAST(lesson.date AS timestamp)) = 2023
GROUP BY month, lesson_type;

-- SEE HOW MANY SIBLINGS
CREATE VIEW number_of_siblings AS
SELECT amount_of_siblings, COUNT(*)
FROM (SELECT a.student_id, COUNT (sibling_person_number) as amount_of_siblings
FROM student as a full join sibling_person_number as b ON a.student_id = b.student_id
GROUP BY a.student_id
ORDER BY amount_of_siblings) AS students_siblings
GROUP BY amount_of_siblings;

-- TEACHERS LESSONS CURRENT MONTH if >= 3
CREATE VIEW teachers_lesson_count_this_month AS
SELECT a.teacher_id, a.first_name, COUNT(*) as lessons
FROM teacher as a INNER JOIN lesson as b ON a.teacher_id = b.teacher_id
WHERE EXTRACT(YEAR FROM CAST(b.date AS timestamp)) = EXTRACT(YEAR FROM CURRENT_DATE)
AND EXTRACT(MONTH FROM CAST (b.date AS timestamp)) = EXTRACT(MONTH FROM CURRENT_DATE)
GROUP BY a.teacher_id
HAVING COUNT(*) >= 3
ORDER BY lessons DESC;

-- NEXT WEEKS ENSEMBLES
CREATE VIEW next_weeks_ensembles AS
SELECT a.lesson_id, l.genre, EXTRACT(DOW FROM CAST(l.date AS TIMESTAMP)) as day_of_week,
CASE
	WHEN COUNT(a.student_id) = CAST(l.max_students AS int) AND l.lesson_id = a.lesson_id THEN 'Fully booked'
	WHEN COUNT(a.student_id) = CAST(l.max_students AS int)-1 AND l.lesson_id = a.lesson_id THEN '1 spot left'
	WHEN COUNT(a.student_id) = CAST(l.max_students AS int)-2 AND l.lesson_id = a.lesson_id THEN '2 spots left'
	ELSE 'Many spots left'
END AS spots	
FROM lesson AS l INNER JOIN student_lesson as a ON l.lesson_id = a.lesson_id
WHERE l.lesson_type = 'ensemble' AND EXTRACT(WEEK FROM CURRENT_DATE)+1 = EXTRACT(WEEK FROM CAST(l.date AS timestamp))
AND EXTRACT(YEAR FROM CURRENT_DATE) = EXTRACT(YEAR FROM CAST(l.date AS timestamp))
GROUP BY a.lesson_id, l.lesson_id
ORDER BY l.genre, day_of_week;
