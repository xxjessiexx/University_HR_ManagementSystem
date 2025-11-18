CREATE DATABASE University_HR_ManagementSystem_28;

GO

USE University_HR_ManagementSystem_28;

GO

CREATE PROCEDURE createAllTables
AS 

CREATE TABLE Department (
name varchar (50) PRIMARY KEY , 
building_location varchar (50),
);

create table Employee (
employee_ID int PRIMARY KEY IDENTITY(1,1), 
first_name varchar (50), 
last_name varchar (50), 
email varchar(50), 
password varchar (50), 
address varchar (50), 
gender char (1), 
official_day_off varchar(50),
years_of_experience int, 
national_ID char (16), 
employment_status varchar (50),
type_of_contract varchar (50), 
emergency_contact_name varchar (50),
emergency_contact_phone char (11), 
annual_balance int, 
accidental_balance int, 
salary decimal(10,2), hire_date date, 
last_working_date date, 
dept_name varchar (50)
FOREIGN KEY (dept_name) REFERENCES Department(name),
CHECK (employment_status in ('active', 'onleave', 'notice_period', 'resigned')),
CHECK (type_of_contract in ('full_time', 'part_time'))
);

CREATE TABLE Employee_Phone (
emp_ID int ,
phone_num char (11),
PRIMARY KEY (emp_ID,phone_num),
FOREIGN KEY(emp_ID) REFERENCES Employee(employee_ID));

CREATE TABLE Role (
role_name varchar (50) PRIMARY KEY , 
title varchar (50), 
description varchar (50), 
rank int, 
base_salary decimal (10,2),
percentage_YOE decimal (4,2), 
percentage_overtime decimal (4,2),
annual_balance int, 
accidental_balance int,
);

CREATE TABLE Employee_Role (
emp_ID int , 
role_name varchar(50)
PRIMARY KEY(emp_ID, role_name),
FOREIGN KEY(emp_ID) REFERENCES Employee(employee_ID),
FOREIGN KEY(role_name) REFERENCES Role (role_name));

CREATE TABLE Role_existsIn_Department (
department_name VARCHAR(50), Role_name VARCHAR(50),
PRIMARY KEY(department_name, Role_name),
FOREIGN KEY (department_name) REFERENCES Department(name),
FOREIGN KEY (Role_name) REFERENCES Role (role_name)) ;

CREATE TABLE Leave (
request_ID int PRIMARY KEY IDENTITY(1,1), 
date_of_request date, 
start_date date, 
end_date date, 
final_approval_status varchar (50) DEFAULT 'pending',
num_days AS end_date - start_date
CHECK(final_approval_status in ('approved', 'rejected', 'pending') ));

CREATE TABLE Annual_Leave (
request_ID int PRIMARY KEY , 
emp_ID int , 
replacement_emp int, 
FOREIGN KEY (emp_id) REFERENCES Employee(employee_ID),
FOREIGN KEY (request_ID) REFERENCES Leave (request_ID),
FOREIGN KEY (replacement_emp) REFERENCES Employee (employee_ID));

CREATE TABLE Accidental_Leave (
request_ID int PRIMARY KEY,
emp_ID int,
FOREIGN KEY (request_ID) REFERENCES Leave (request_ID),
FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID));

CREATE TABLE Medical_Leave (
request_ID int PRIMARY KEY , 
insurance_status BIT,
disability_details varchar (50), 
type varchar (50), 
Emp_ID int,
FOREIGN KEY (request_ID) REFERENCES Leave (request_ID),
FOREIGN KEY (Emp_ID) REFERENCES Employee(employee_ID),
CHECK (type in ('sick', 'maternity'))
) ;

CREATE TABLE Unpaid_Leave (
request_ID int PRIMARY KEY, 
Emp_ID int, 
FOREIGN KEY (request_ID) REFERENCES Leave (request_ID),
FOREIGN KEY (Emp_ID) REFERENCES Employee(employee_ID)
);

CREATE TABLE Compensation_Leave (
request_ID int PRIMARY KEY,
reason varchar(50), 
date_of_original_workday date, 
emp_ID int ,
replacement_emp int,
FOREIGN KEY (request_ID) REFERENCES Leave(request_ID),
FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID),
FOREIGN KEY (replacement_emp) REFERENCES Employee(employee_id));


CREATE TABLE  Document (
document_ID int PRIMARY KEY IDENTITY(1,1), 
type varchar (50), 
description varchar (50), 
file_name varchar (50), 
creation_date date, 
expiry_date date, 
status varchar (50), 
emp_ID int , 
medical_ID int,
unpaid_ID int, 
CHECK(status in ('valid', 'expired') ),
FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID),
FOREIGN KEY (medical_ID) REFERENCES Medical_Leave(request_ID),
FOREIGN KEY (unpaid_ID) REFERENCES Unpaid_Leave(request_ID));

CREATE TABLE Payroll (
ID int PRIMARY KEY IDENTITY(1,1), 
payment_date date,
final_salary_amount decimal (10,1), 
from_date date, 
to_date date, 
comments varchar (150), 
bonus_amount decimal (10,2),
deductions_amount decimal (10,2), 
emp_ID int, 
FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID));

CREATE TABLE Attendance (
attendance_ID int PRIMARY KEY IDENTITY(1,1), 
date date, 
check_in_time time, 
check_out_time time,
status varchar (50) DEFAULT 'absent', 
emp_ID int ,
total_duration AS check_out_time- check_in_time,
CHECK (status in ('absent', 'attended')),
FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID)); 

CREATE TABLE Deduction (
deduction_ID int IDENTITY(1,1),
emp_ID int , 
date date,
amount decimal (10,2),
type varchar (50),
status varchar (50) default 'pending', 
unpaid_ID int , 
attendance_ID int,
CHECK(type in ('missing_hours', 'missing_days', 'unpaid')),
CHECK(status in ('pending', 'finalized')),
FOREIGN KEY (emp_ID) REFERENCES Employee (employee_ID),
FOREIGN KEY (unpaid_ID) REFERENCES Unpaid_Leave (request_ID),
FOREIGN KEY (attendance_ID) REFERENCES Attendance (attendance_ID),
PRIMARY KEY(deduction_ID, emp_ID)
);

CREATE TABLE Performance (
performance_ID int PRIMARY KEY IDENTITY(1,1),
rating int,
comments varchar (50),
semester char (3), 
emp_ID int, 
FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID),
CHECK (rating BETWEEN 1 AND 5)
) ;

CREATE TABLE Employee_Replace_Employee (
Emp1_ID int ,
Emp2_ID int ,
from_date date, 
to_date date,
PRIMARY KEY (Emp1_ID, Emp1_ID),
FOREIGN KEY (Emp1_ID) REFERENCES Employee (Employee_ID),
FOREIGN KEY (Emp2_ID) REFERENCES Employee (Employee_ID));

CREATE TABLE Employee_Approve_Leave (
Emp1_ID int,
Leave_ID int, 
status varchar (50),
PRIMARY KEY (Emp1_ID, Leave_ID),
FOREIGN KEY (Emp1_ID) REFERENCES Employee (Employee_ID),
FOREIGN KEY (Leave_ID) REFERENCES Leave (request_ID));

go;

EXEC createAllTables;

GO
CREATE PROCEDURE dropAllTables 
AS 

DROP TABLE Department, Employee, Employee_Phone, Role, Employee_Role, Role_existsIn_Department, Leave, Annual_Leave, Accidental_Leave, Medical_Leave, Unpaid_Leave, Compensation_Leave, Document, Payroll , Attendance, Deduction, Performance, Employee_Replace_Employee, Employee_Approve_Leave;

go;

EXEC dropAllTables;

go 
CREATE PROCEDURE dropAllProceduresFunctionsViews 
AS 
DROP PROCEDURE createAllTables ,dropAllTables,clearAllTables ;
GO;

go
CREATE PROCEDURE clearAllTables 
AS 

Truncate table Department;
truncate table Employee;
truncate table Employee_Phone;
truncate table Role;
truncate table Employee_Role;
truncate table Role_existsIn_Department;
truncate table Leave;
truncate table Annual_Leave;
truncate table Accidental_Leave;
truncate table Medical_Leave;
truncate table Unpaid_Leave; 
truncate table Compensation_Leave;
truncate table Document;
truncate table Payroll;
truncate table Attendance;
truncate table Deduction;
truncate table Performance;
truncate table Employee_Replace_Employee;
truncate table Employee_Approve_Leave;
go;

EXEC clearAllTables;

go
 
 CREATE PROCEDURE  Intitiate_Attendance 
AS 
DECLARE @currentday DATE = CURRENT_TIMESTAMP;
INSERT INTO Attendance (date, check_in_time, check_out_time, total_duration, status, emp_ID)
SELECT @currentday, NULL, NULL, NULL, 'Absent', employee_ID
FROM Employee
WHERE employee_ID NOT IN (
    SELECT emp_ID 
    FROM Attendance 
    WHERE date = @currentday
);

go

EXEC Intitiate_Attendance ;

 --faridaaaaaa

 --2.5)o)
GO
CREATE PROC  Dean_andHR_Evaluation
@employee_ID int,
@rating int,
@comment varchar(50),
@semester char(3)
AS

INSERT INTO Performance
VALUES (@rating, @comment, @semester, @employee_ID);

GO; 

--2.5)n)
GO
CREATE PROC  Submit_compensation
@employee_ID int, 
@compensation_date date, 
@reason varchar(50), 
@date_of_original_workday date, 
@replacement_emp int
AS
DECLARE @HRrep_id int;
DECLARE @req_id int;
DECLARE @employee_departement VARCHAR (50);

INSERT INTO Leave (date_of_request, start_date, end_date)
VALUES(CURRENT_TIMESTAMP, @compensation_date, @compensation_date);

--how to get the req_id of the leave?

INSERT INTO Compensation_Leave
VALUES (@req_id, @reason, @date_of_original_workday, @employee_ID, @replacement_emp);

INSERT INTO Employee_Replace_Employee
VALUES (@employee_ID, @replacement_emp, @compensation_date,@compensation_date);

SELECT @employee_departement = E.dept_name
FROM Employee E
WHERE E.employee_ID = @employee_ID;

SELECT TOP 1 @HRrep_id = E.employee_ID 
FROM Employee E INNER JOIN Employee_Role R ON (E.employee_ID= R.emp_ID)
WHERE R.role_name = ('HR_Representative_'+ @employee_departement) AND E.employment_status='active';

INSERT INTO Employee_Approve_Leave (Emp1_ID , Leave_ID , status)
VALUES (@HRrep_id , @req_id, 'pending');

GO;

--2.5)k)
GO
CREATE PROC Submit_medical
@employee_ID int, 
@start_date date, 
@end_date date, 
@type varchar(50), 
@insurance_status bit, 
@disability_details varchar(50),
@document_description varchar(50), 
@file_name varchar(50)
AS 

DECLARE @req_id int;
DECLARE @HRrep_id INT;
DECLARE @employee_dep VARCHAR(50);
DECLARE @medical_dr_id INT;

INSERT INTO Leave (date_of_request, start_date, end_date)
VALUES (CURRENT_TIMESTAMP, @start_date, @end_date);

INSERT INTO Medical_Leave (request_ID, insurance_status, disability_details, type, Emp_ID)
VALUES (@req_id, @insurance_status, @disability_details, @type, @employee_ID);

INSERT INTO Document (type, description, file_name , creation_date, expiry_date, status, emp_ID,medical_ID, unpaid_ID)
VALUES ('medical report', @document_description, @file_name, CURRENT_TIMESTAMP, NULL,'valid',@employee_ID, @req_id, NULL);

SELECT TOP 1 @medical_dr_id = E.employee_ID
FROM Employee E INNER JOIN Employee_Role R ON (E.employee_ID = R.emp_ID)
WHERE E.employment_status = 'active'AND R.role_name= 'Medical Doctor'; 

SELECT @employee_dep = E.dept_name
FROM Employee E
WHERE E.employee_ID = @employee_ID;

SELECT TOP 1 @HRrep_id = E.employee_ID 
FROM Employee E INNER JOIN Employee_Role R ON (E.employee_ID= R.emp_ID)
WHERE R.role_name = ('HR_Representative_'+ @employee_dep) AND E.employment_status='active';

INSERT INTO Employee_Approve_Leave (Emp1_ID , Leave_ID , status)
VALUES (@HRrep_id , @req_id, 'pending');

INSERT INTO Employee_Approve_Leave (Emp1_ID , Leave_ID , status)
VALUES (@medical_dr_id , @req_id, 'pending');

GO;

--2.5)L)
GO
CREATE PROC Submit_unpaid
@employee_ID int, 
@start_date date, 
@end_date date,
@document_description varchar(50), 
@file_name varchar(50)
AS

DECLARE @employee_dep VARCHAR(50);
DECLARE @HRrep_id INT;
DECLARE @req_id int;
DECLARE @president_id int;
DECLARE @employee_role VARCHAR(50);
DECLARE @HR_manager_id int;
DECLARE @higher_rank_emp_id int ;
DECLARE @emp_rank int ;

INSERT INTO Leave (date_of_request, start_date, end_date)
VALUES (CURRENT_TIMESTAMP, @start_date, @end_date);

INSERT INTO Unpaid_Leave (request_ID, Emp_ID) 
VALUES (@req_id, @employee_ID);

INSERT INTO Document (type, description, file_name, creation_date, expiry_date, status, emp_ID, medical_id,unpaid_id)
VALUES ('memo', @document_description, @file_name, CURRENT_TIMESTAMP, NULL, 'valid', @employee_ID, null, @req_id);

--Employee_Role (emp_ID int (FK), role_name varchar(50) (FK))

SELECT @employee_dep = E.dept_name 
FROM Employee E 
WHERE E.employee_ID = @employee_ID;

SELECT @employee_role = R.role_name
FROM Employee_Role R
WHERE R.emp_ID = @employee_ID ;

SELECT @president_id = R.emp_ID
FROM Employee_Role R
WHERE R.role_name = 'President';


IF @employee_role in ('Dean', 'Vice Dean')
BEGIN 
	SELECT TOP 1 @HRrep_id = E.employee_ID 
	FROM Employee E INNER JOIN Employee_Role R ON (E.employee_ID= R.emp_ID)
	WHERE R.role_name = ('HR_Representative_'+ @employee_dep) AND E.employment_status='active';

	INSERT INTO Employee_Approve_Leave (Emp1_ID , Leave_ID , status)
	VALUES (@HRrep_id , @req_id, 'pending');

	INSERT INTO Employee_Approve_Leave (Emp1_ID , Leave_ID , status)
	VALUES (@president_id , @req_id, 'pending');
END 
ELSE IF @employee_dep LIKE 'HR'
BEGIN 
	SELECT TOP 1 @HR_manager_id = E.employee_ID
	FROM Employee E INNER JOIN Employee_Role R ON (E.employee_ID = R.emp_ID)
	WHERE E.employment_status = 'active' AND R.role_name = 'HR Manager';

	INSERT INTO Employee_Approve_Leave (Emp1_ID , Leave_ID , status)
	VALUES (@HR_manager_id, @req_id, 'pending');

	INSERT INTO Employee_Approve_Leave (Emp1_ID , Leave_ID , status)
	VALUES (@president_id , @req_id, 'pending');
END 
ELSE 
BEGIN 
	SELECT TOP 1 @HRrep_id = E.employee_ID 
	FROM Employee E INNER JOIN Employee_Role R ON (E.employee_ID= R.emp_ID)
	WHERE R.role_name = ('HR_Representative_'+ @employee_dep) AND E.employment_status='active';

	INSERT INTO Employee_Approve_Leave (Emp1_ID , Leave_ID , status)
	VALUES (@HRrep_id , @req_id, 'pending');   --HR representative 

	INSERT INTO Employee_Approve_Leave (Emp1_ID , Leave_ID , status)
	VALUES (@president_id, @req_id, 'pending');   --upper board departement 
	
	SELECT @emp_rank = R.rank 
	FROM Employee E inner join Employee_Role ER ON (E.employee_ID = ER.emp_ID)INNER JOIN Role R ON (ER.role_name = R.role_name)
	WHERE  E.employee_id = @employee_ID ;

	SELECT TOP 1 @higher_rank_emp_id = E.employee_ID
	FROM  Employee E INNER JOIN Employee_Role ER ON (E.employee_ID = ER.emp_ID)INNER JOIN Role R ON (ER.role_name = R.role_name)
	WHERE E.employment_status = 'active' AND R.rank < @emp_rank ;

	INSERT INTO Employee_Approve_Leave (Emp1_ID , Leave_ID , status)
	VALUES (@higher_rank_emp_id, @req_id, 'pending');  --Higher ranking employee 
END

GO;


--2.5)m)

GO
CREATE PROC Upperboard_approve_unpaids
@request_ID int, 
@Upperboard_ID int
AS
--Employee_Approve_Leave (Emp1_ID int (FK), Leave_ID int (FK), status: varchar(50))
--Employee_ Approve _Employee. Emp1_ID references Employee. Employee_ID
--Employee_ Approve _Employee. Leave_ID references Leave.request_ID

UPDATE Employee_Approve_Leave 
SET status = 'approved'
WHERE status <> 'rejected' AND Leave_ID = @request_ID AND Emp1_ID = @Upperboard_ID 
AND EXISTS (
SELECT *
FROM Document D
WHERE D.unpaid_ID = @request_ID AND D.type = 'memo' AND D.status = 'valid')
AND EXISTS (
SELECT *
FROM Unpaid_Leave UL
WHERE UL.request_ID = @request_ID);

go 


CREATE PROCEDURE Update_Status_Doc 
AS 

if expiry_date  < CURRENT_TIMESTAMP 
	update document
	set status='expired';


go
EXEC Update_Status_Doc ;


go


CREATE PROCEDURE Remove_Deductions 
AS 

DELETE FROM Deduction 
where emp_ID IN (
	select employee_ID 
	from Employee
	WHERE employment_status = 'resigned'
        );

 go
 EXEC Remove_Deductions ;



go


 CREATE PROCEDURE  Update_Employment_Status 
 
  @Employee_ID int 
AS 

SELECT employee_ID
	FROM Employee
	WHERE employee_ID = @Employee_ID 
 
 --if employment_status ='active'
 --update Employee

go
EXEC  Update_Employment_Status ;


go


CREATE PROCEDURE Create_Holiday 
AS

CREATE TABLE Holiday(
 holiday_id int primary key identity(1,1),
 name varchar(50),
 from_date date,
 to_date date
);

go
EXEC Create_Holiday ;


go


CREATE PROCEDURE Add_Holiday 

 @holiday_name varchar(50),
 @from_date date ,
 @to_date date

 AS

 INSERT INTO Holiday (name, from_date, to_date)
    VALUES (@holiday_name, @from_date, @to_date);
 go;

 EXEC Add_Holiday;


 go
 


 



