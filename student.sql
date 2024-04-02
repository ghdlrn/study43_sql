-- Drop the tables if they exist

DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS professor;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS student_course;

-- Create Department table
create table department(
department_code int primary key auto_increment,
department_name varchar(50)
);

-- Create Student table
CREATE TABLE student(
student_id INT PRIMARY KEY AUTO_INCREMENT,
student_name VARCHAR(50),
student_height DECIMAL(5,2),
department_code INT
);

-- Create Professor table
CREATE TABLE professor(
professor_code INT PRIMARY KEY AUTO_INCREMENT,
professor_name VARCHAR(50),
department_code INT,
CONSTRAINT FK_Professor_Department FOREIGN KEY(department_code) 
        REFERENCES department(department_code)
);

-- Create Course table
CREATE TABLE course (
course_code INT PRIMARY KEY AUTO_INCREMENT,
course_name VARCHAR(50),
professor_code INT,
start_date DATE,
end_date DATE
);

-- Create Student_Course table
CREATE TABLE student_course(
id INT not null unique,
student_id INT,
course_code INT,
primary key(student_id , course_code)
);

-- Add foreign key constraints using ALTER TABLE
ALTER TABLE student
ADD CONSTRAINT FK_Student_Department FOREIGN KEY(department_code ) 
REFERENCES department(department_code);

ALTER TABLE course
ADD CONSTRAINT FK_Course_Professor FOREIGN KEY (professor_code ) 
REFERENCES professor(professor_code);

ALTER TABLE student_course
ADD CONSTRAINT FK_Student_Course_Student FOREIGN KEY (student_id ) 
REFERENCES student(student_id);

ALTER TABLE student_course
ADD CONSTRAINT FK_Student_Course_Course FOREIGN KEY (course_code ) 
REFERENCES course(course_code);


-- 학과
INSERT INTO department (department_name ) VALUES 
('수학통계학'),
('국어문과'),
('전자정보통신과'),
('모바일 AI 공학');


-- 학생
INSERT INTO student (student_name , student_height,department_code ) 
VALUES 
('가학생 ', 170.5,1), 
('나학생 ', 165.2,1), 
('다학생 ', 180.2,1), 
('라학생 ', 175.8,2),  
('마학생 ', 160.7,2), 
('바학생 ', 168.3, 3), 
('사학생 ', 172.1, 4), 
('아학생 ', 175.3, 4); 

-- 교수
INSERT INTO professor (professor_name , department_code ) 
 VALUES 
('가교수' ,1), 
('나교수' ,2), 
('다교수' ,3), 
('빌게이츠' ,4), 
('스티브잡스' ,3); 

-- 개설과목
INSERT INTO course (course_name , professor_code , start_date ,end_date ) 
VALUES 
('교양 영어 ', 1, '2023-07-01', '2023-08-15'),
('데이터베이스 입문 ', 3, '2023-07-01', '2023-08-31'),
('회로이론 ', 2, '2023-07-15', '2023-09-15'),
('공학수학 ', 4, '2023-07-15', '2023-09-30'),
('객체지향 프로그래밍 ', 3, '2023-07-01', '2023-08-31');


-- 수강
INSERT INTO student_course ( id,student_id , course_code ) VALUES  
(1, 1, 1),
(2, 2, 1),
(3, 3, 2),
(4, 4, 3),
(5, 5, 4),
(6, 6, 5),
(7, 7, 5);

-- Q1. 교수의 학과 정보를 출력하세요(교수이름, 학과명)

select p.professor_name, d.department_name
from professor p inner join department d
on p.department_code = d.department_code;

-- Q2. 학과별 교수의 수를 출력하세요
select d.department_name, count(p.professor_name)
from professor p inner join department d
on p.department_code = d.department_code
group by d.department_name;

-- Q3. 수학통계학의 학생 정보를 출력하세요.

select d.department_name, s.student_id, s.student_name, s.student_height
from department d join student s
on d.department_code = s.department_code
where d.department_code=1;

-- Q4. 학생 중 성이 '바'인 학생이 속한 학과이름과 학생 이름을 출력하세요
select d.department_name, s.student_name
from department d join student s
on d.department_code = s.department_code
where s.student_name like '바%';

-- Q5. 학생의 키가 175~180사이에 속하는 학생 수를 출력하세요
select count(student_height)
from student
where student_height between 175 and 180;

-- Q6. 학과별 키의 최고값과 평균값을 출력하세요.
select d.department_name ,max(s.student_height), avg(s.student_height)
from department d join student s
on d.department_code = s.department_code
group by d.department_name;

-- Q7. '다학생'과 같은 학과에 속한 학생의 이름을 출력하세요.
select student_name
from student
where department_code = (
	select department_code
	from student
	where student_name = '다학생'
);
--  Q8. 가장 많은 학생이 있는 학과 이름을 출력하세요.
 select a.department_name
 from department a
 join student b on a.department_code = b.department_code
 GROUP BY a.department_name
 order by count(b.student_id) desc
 limit 1;
 
-- Q9. '교양 영어' 과목을 수강 신ㅁ청한 학생의 이름을 출력하세요.
select c.course_name, s.student_name
from course c join student_course sc
on c.course_code = sc.course_code
join student s
on sc.student_id = s.student_id
where c. course_name = '교양 영어';

-- Q10. '가교수' 교수의 과목을 수강신청한 학생수를 출력하세요.
select p.professor_name, c.course_name, count(s.student_id)
from course c join professor p
on c.professor_code = p.professor_code
join student s
on p.department_code = s.department_code
where p.professor_name = '가교수'
group by c.course_code;

