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

-- this is a demo script

select * from department;
 

