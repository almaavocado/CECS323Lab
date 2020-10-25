create schema FACULTY;
set schema FACULTY;

drop table Students;
drop table courses;
drop table requirements;
drop table Departments;
drop table major_requirements;
drop table majors;
drop table faculty;
drop table AcademicAdvisors;


create table Students(
    id varchar(10) NOT NULL,
    major varchar(10) NOT NULL,
    first_name varchar(10) NOT NULL,
    last_name varchar(10) NOT NULL,
    birthdate DATE NOT NULL,
    phone_number varchar(10) NOT NULL,
    GPA varchar(10) NOT NULL,
    CONSTRAINT student_pk PRIMARY KEY(id),
    CONSTRAINT student_fk FOREIGN KEY(major) references MAJORS(code)
);


create table courses(
    course_number varchar(10) NOT NULL,
    title varchar(10) NOT NULL,
    units int NOT NULL,
    description varchar(10) NOT NULL,
    department varchar(10) NOT NULL,
    CONSTRAINT courses_pk PRIMARY KEY(course_number),
    CONSTRAINT courses_fk FOREIGN KEY (department) references Departments(code)
);

create table requirements(
    course varchar(10) NOT NULL,
    required varchar(10) NOT NULL,
    type varchar(10) NOT NULL ,
    CONSTRAINT requirements_pk PRIMARY KEY(course),
    CONSTRAINT requirements_fk FOREIGN KEY (course) references Courses(course_number),
    CONSTRAINT requirements_fk_2 FOREIGN KEY (required) references Courses(course_number)

    );


create table Departments (
  name varchar(10) NOT NULL,
  office varchar(10) NOT NULL,
  phonenumber varchar(20) NOT NULL,
  number_of_faculty int NOT NULL,
  college varchar(10) NOT NULL,
  code varchar(10) NOT NULL,
  CONSTRAINT Departments_pk PRIMARY KEY(code)
);


create table major_requirements(
    major varchar(10) NOT NULL,
    course varchar(10) NOT NULL,
    CONSTRAINT major_requirements_pk_1 PRIMARY KEY(major, course),
    CONSTRAINT major_requirements_idfk_2 FOREIGN KEY (major) references Majors(code),
    CONSTRAINT major_requirements_idfk_3 FOREIGN KEY (course) references Courses(course_number)
);

create table majors(
    code varchar(10) NOT NULL,
    name varchar(10) NOT NULL,
    degree varchar(10) NOT NULL,
    minunitsrequired int NOT NULL,
    description varchar(10) NOT NULL,
    department varchar(10) NOT NULL,
    CONSTRAINT major_pk PRIMARY KEY(code),
    CONSTRAINT major_fk FOREIGN KEY (department) references Departments(code)

);

create table faculty(
    id varchar(10) NOT NULL,
    firstname varchar(10) NOT NULL,
    lastname varchar(10) NOT NULL,
    office varchar(10) NOT NULL,
    start_date DATE NOT NULL,
    phone_number varchar(10) NOT NULL,
    department varchar(10) NOT NULL,
    CONSTRAINT faculty_pk PRIMARY KEY(id),
    CONSTRAINT faculty_idfk_1 FOREIGN KEY (department) references Departments(code)

);


create table AcademicAdvisors(
    major varchar(10) NOT NULL,
    advisor varchar(10) NOT NULL,
    date_started DATE NOT NULL,
    CONSTRAINT AcademicAdvisors_pk PRIMARY KEY(major, advisor),
    CONSTRAINT AcademicAdvisor_idfk_1 FOREIGN KEY (major) references MAJORS(code),
    CONSTRAINT AcademicAdvisor_idfk_2 FOREIGN KEY (advisor) references FACULTY(id)
);

insert into Students(id, major, first_name, last_name, birthdate, phone_number, GPA) VALUES
('0151', '345', 'Alma', 'Alvarado', '1998-11-11', '3102332332', '3.6'),
('0161', '345','Joe', 'Freedman', '1999-12-13', '3234569273', '3.7');

insert into courses(course_number, title, units, description, department) values
('105', 'CECS', 1, 'Intro', '34567'),
('274', 'OOP', 3, 'Java', '34567'),
('150', 'IDK', 3, 'Rand', '23456');

insert into courses(course_number, title, units, description, department) values
('300', 'CECS', 1, 'Intro', '11111');

insert into requirements(course, required, type) values
('274', '105', 'intro');

insert  into Departments(name, office, phonenumber, number_of_faculty, college, code) values
('CECS','245','0000000000',56, 'COE','34567'),
('ENGR', '246', '3103103131', 51, 'COE', '23456');

insert  into Departments(name, office, phonenumber, number_of_faculty, college, code) values
('Engineerin','111','0000100000',59, 'COE','11111');

insert into Departments(name, office, phonenumber, number_of_faculty, college, code) values
('MCECS', '345', '1110001111', 51, 'MCOE', '44444'),
('MPHYS', '390', '1110002222', 40, 'MPHYS', '55555');

insert  into majors(code, name, degree, minunitsrequired, description, department) values
('345','CS','BS',140, 'COE','34567'),
('234', 'ME', 'BA', 125, 'COE', '23456');

insert into major_requirements(major, course) values
('345', '105');

insert  into majors(code, name, degree, minunitsrequired, description, department) values
('111','PHCS','PHD',141, 'PHCOE','44444'),
('222', 'PHYS', 'MBA', 121, 'PHYSPH', '55555');

insert  into faculty(id, firstname, lastname, office, start_date, phone_number, department) values
('1','Alvaro','Monge','122', '2020-10-10','0000000001','34567' ),
('2', 'David', 'Brown', '123', '2016-11-11', '3103103132','23456');

insert into faculty(id, firstname, lastname, office, start_date, phone_number, department) values
('3','Alvaro2','Monge2','222', '2019-10-10','0000000201','44444' ),
('4', 'David2', 'Brown2', '223', '2015-11-11', '3103101132','55555');

insert into AcademicAdvisors(major, advisor, date_started) values
('345', '1', '2020-10-10'),
('234', '2', '2016-11-11');

insert into AcademicAdvisors(major, advisor, date_started) values
('111', '3', '2019-10-10'),
('222', '4', '2014-11-11');

SELECT d.name, d.phonenumber, m.name, m.degree, m.minunitsrequired
FROM departments d
INNER JOIN majors m ON d.code = m.department
WHERE
d.number_of_faculty > 50
AND (m.degree = 'BA' OR m.degree = 'BFA' OR m.degree = 'BS')
AND m.minunitsrequired > 120;


SELECT d.name, c.course_number, c.title
FROM courses c
INNER JOIN departments d ON c.department = d.code
EXCEPT
SELECT d.name, c.course_number, c.title
FROM requirements r
INNER JOIN courses c ON r.course = c.course_number
INNER JOIN departments d ON c.department = d.code;


SELECT d.name, m.degree, m.name
FROM majors m
INNER JOIN departments d on m.department = d.code
WHERE
(m.degree = 'MBA' OR m.degree = 'MFA' OR m.degree = 'MS' OR m.degree = 'PhD');


SELECT d.name, c.course_number, c.title
FROM courses c
INNER JOIN departments d ON c.department = d.code
WHERE d.name = 'Engineerin'
EXCEPT
SELECT d.name, c.course_number, c.title
FROM requirements r
INNER JOIN courses c ON r.course = c.course_number
INNER JOIN departments d ON c.department = d.code;

SELECT d.name AS Department_name, d.phonenumber, m.name AS Major_name, m.degree, m.minunitsrequired
FROM Departments d
INNER JOIN majors m ON d.code = m.department
WHERE
d.number_of_faculty > 50
AND (m.degree = 'BA' OR m.degree = 'BFA' OR m.degree = 'BS')
AND m.minunitsrequired> 120;

SELECT a.advisor, a.department from
    (SELECT advisor, department, a.date_started from majors m INNER JOIN AcademicAdvisors a ON m.code = a.major) a
        INNER JOIN faculty f on a.advisor = f.id
    WHERE (a.department = f.department AND TIMESTAMPDIFF(month(), a.date_started, NOW()) > (12 * 3));
SELECT COUNT(*) FROM AcademicAdvisors;









--Problem 1

---SQL----
SELECT f.firstname, f.lastname, f.phone_number, m.name, 'Academic advisor' AS Role FROM faculty f
INNER JOIN academicAdvisors a ON f.id = a.advisor
INNER JOIN majors m ON a.major = m.code
INNER JOIN departments d ON m.department = d.code
WHERE d.name = 'ENGR'
UNION
SELECT s.first_name, s.last_name, s.phone_number, m.name, 'Student' AS Role
FROM students s
INNER JOIN majors m ON s.major = m.code
INNER JOIN departments d ON m.department = d.code
WHERE d.name = 'ENGR';


--Problem 2

---SQL----
SELECT d.name AS Department_name, d.phonenumber, m.name AS Major_name, m.degree, m.minunitsrequired
FROM departments d
INNER JOIN majors m ON d.code = m.department
WHERE
d.number_of_faculty > 50
AND (m.degree = 'BA' OR m.degree = 'BFA' OR m.degree = 'BS')
AND m.minunitsrequired > 120;


--- Problem 6
SELECT f.firstname, f.lastname, a.major, 'Yes' AS Satisfies
FROM academicAdvisors a
INNER JOIN faculty f ON a.advisor = f.id
INNER JOIN majors m ON a.major = m.code
WHERE
f.department = m.department
AND YEAR(date_started) <= YEAR(CURRENT DATE) - 3
UNION
SELECT f.firstname, f.lastname, a.major, 'No' AS Satisfies
FROM academicAdvisors a
INNER JOIN faculty f ON a.advisor = f.id
INNER JOIN majors m ON a.major = m.code
WHERE
f.department != m.department
OR YEAR(date_started) > YEAR(CURRENT DATE) - 3;