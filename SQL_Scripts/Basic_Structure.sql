CREATE DATABasE University_HR_ManagementSystem_28;

GO


USE University_HR_ManagementSystem_28;

GO
CREATE PROC createAllTables
as 

CREATE TABLE Department (
name varchar (50) PRIMARY KEY , 
building_location varchar (50)
);

CREATE TABLE Employee (
employee_ID int IDENTITY(1,1) PRIMARY KEY , 
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
salary decimal(10,2),
hire_date date, 
last_working_date date, 
dept_name varchar (50),
FOREIGN KEY (dept_name) REFERENCES Department(name),
CHECK (employment_status in ('active', 'onleave', 'notice_period', 'resigned')),
CHECK (type_of_contract in ('full_time', 'part_time'))
);

CREATE TABLE Employee_Phone (
emp_ID int ,
phone_num char (11),
PRIMARY KEY (emp_ID,phone_num),
FOREIGN KEY(emp_ID) REFERENCES Employee(employee_ID)
);

CREATE TABLE Role (
role_name varchar (50) PRIMARY KEY , 
title varchar (50), 
description varchar (50), 
rank int, 
base_salary decimal (10,2),
percentage_YOE decimal (4,2), 
percentage_overtime decimal (4,2),
annual_balance int, 
accidental_balance int
);

CREATE TABLE Employee_Role (
emp_ID int , 
role_name varchar(50),
PRIMARY KEY(emp_ID, role_name),
FOREIGN KEY(emp_ID) REFERENCES Employee(employee_ID),
FOREIGN KEY(role_name) REFERENCES Role (role_name)
);

CREATE TABLE Role_existsIn_Department (
department_name VARCHAR(50), 
Role_name VARCHAR(50),
PRIMARY KEY(department_name, Role_name),
FOREIGN KEY (department_name) REFERENCES Department(name),
FOREIGN KEY (Role_name) REFERENCES Role (role_name)
) ;

CREATE TABLE Leave (
request_ID int IDENTITY(1,1) PRIMARY KEY , 
date_of_request date, 
start_date date, 
end_date date, 
final_approval_status varchar (50) DEFAULT 'pending',
---num_days as end_date - start_date+1
-- not allowed
CHECK (final_approval_status IN ('approved', 'rejected', 'pending')),
    num_days as (DATEDIFF(day, start_date, end_date) + 1) -- found this instead can we use it?

);

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
FOREIGN KEY (replacement_emp) REFERENCES Employee(employee_ID)
);


CREATE TABLE  Document (
document_ID int IDENTITY(1,1) PRIMARY KEY , 
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
FOREIGN KEY (unpaid_ID) REFERENCES Unpaid_Leave(request_ID)
);

CREATE TABLE Payroll (
ID int IDENTITY(1,1) PRIMARY KEY , 
payment_date date,
final_salary_amount decimal (10,1), 
from_date date, 
to_date date, 
comments varchar (150), 
bonus_amount decimal (10,2),
deductions_amount decimal (10,2), 
emp_ID int, 
FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID)
);

CREATE TABLE Attendance (
attendance_ID int IDENTITY(1,1) PRIMARY KEY , 
date date, 
check_in_time time, 
check_out_time time,
status varchar (50) DEFAULT 'absent', 
emp_ID int ,
total_duration AS (DATEDIFF(MINUTE, check_in_time, check_out_time)), --duration in minutes--
CHECK (status in ('absent', 'attended')),
FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID)
); 

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
performance_ID int IDENTITY(1,1) PRIMARY KEY ,
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
PRIMARY KEY (Emp1_ID, Emp2_ID),
FOREIGN KEY (Emp1_ID) REFERENCES Employee (Employee_ID),
FOREIGN KEY (Emp2_ID) REFERENCES Employee (Employee_ID)
);

CREATE TABLE Employee_Approve_Leave (
Emp1_ID int,
Leave_ID int, 
status varchar (50),
PRIMARY KEY (Emp1_ID, Leave_ID),
FOREIGN KEY (Emp1_ID) REFERENCES Employee (Employee_ID),
FOREIGN KEY (Leave_ID) REFERENCES Leave (request_ID)
);

go


GO
CREATE PROC dropAllTables
AS
    DROP TABLE Employee_Approve_Leave;
    DROP TABLE Employee_Replace_Employee;
    DROP TABLE Performance;
    DROP TABLE Deduction;
    DROP TABLE Attendance;
    DROP TABLE Payroll;
    DROP TABLE Document;
    DROP TABLE Compensation_Leave;
    DROP TABLE Unpaid_Leave;
    DROP TABLE Medical_Leave;
    DROP TABLE Accidental_Leave;
    DROP TABLE Annual_Leave;
    DROP TABLE [Leave];
    DROP TABLE Role_existsIn_Department;
    DROP TABLE Employee_Role;
    DROP TABLE Role;
    DROP TABLE Employee_Phone;
    DROP TABLE Employee;
    DROP TABLE Department;
GO


GO
CREATE PROC dropAllProceduresFunctionsViews
AS
    -- DROP ALL VIEWS-----
    DROP VIEW allEmployeeProfiles;
    DROP VIEW NoEmployeeDept;
    DROP VIEW allPerformance;
    DROP VIEW allRejectedMedicals;
    DROP VIEW allEmployeeAttendance;
    -- DROP ALL FUNCTIONS---
    DROP FUNCTION HRLoginValidation;
    DROP FUNCTION Bonus_amount;
    DROP FUNCTION EmployeeLoginValidation;
    DROP FUNCTION MyPerformance;
    DROP FUNCTION MyAttendance;
    DROP FUNCTION Last_month_payroll;
    DROP FUNCTION Deductions_Attendance;
    DROP FUNCTION Is_On_Leave;
    DROP FUNCTION Status_leaves;
    -- DROP ALL STORED PROCEDURES-----
    DROP PROC createAllTables;
    DROP PROC dropAllTables;
    DROP PROC clearAllTables;
    DROP PROC Update_Status_Doc;         
    DROP PROC Remove_Deductions;
    DROP PROC Update_Employment_Status;
    DROP PROC Create_Holiday;
    DROP PROC Add_Holiday;
    DROP PROC Initiate_Attendance;
    DROP PROC Update_Attendance;
    DROP PROC Remove_Holiday;
    DROP PROC Remove_DayOff;
    DROP PROC Remove_Approved_Leaves;
    DROP PROC Replace_employee;
    DROP PROC HR_approval_an_acc;
    DROP PROC HR_approval_unpaid;
    DROP PROC HR_approval_comp;
    DROP PROC Deduction_hours;
    DROP PROC Deduction_days;
    DROP PROC Deduction_unpaid;
    DROP PROC Add_Payroll;
    DROP PROC Submit_annual;
    DROP PROC Submit_accidental;
    DROP PROC Submit_medical;
    DROP PROC Submit_unpaid;
    DROP PROC Upperboard_approve_annual;
    DROP PROC Upperboard_approve_unpaids;
    DROP PROC Submit_compensation;
    DROP PROC Dean_andHR_Evaluation;

GO


GO
CREATE PROC clearAllTables
AS
    TRUNCATE TABLE Employee_Approve_Leave;
    TRUNCATE TABLE Employee_Replace_Employee;
    TRUNCATE TABLE Performance;
    TRUNCATE TABLE Deduction;
    TRUNCATE TABLE Attendance;
    TRUNCATE TABLE Payroll;
    TRUNCATE TABLE Document;
    TRUNCATE TABLE Compensation_Leave;
    TRUNCATE TABLE Unpaid_Leave;
    TRUNCATE TABLE Medical_Leave;
    TRUNCATE TABLE Accidental_Leave;
    TRUNCATE TABLE Annual_Leave;
    TRUNCATE TABLE [Leave];          
    TRUNCATE TABLE Role_existsIn_Department;
    TRUNCATE TABLE Employee_Role;
    TRUNCATE TABLE Role;
    TRUNCATE TABLE Employee_Phone;
    TRUNCATE TABLE Employee;
    TRUNCATE TABLE Department;
GO;


GO
 
 CREATE PROC  Intitiate_Attendance 
as 
DECLARE @currentday DATE = CURRENT_TIMESTAMP;
INSERT INTO Attendance (date, check_in_time, check_out_time, total_duration, status, emp_ID)
SELECT @currentday, NULL, NULL, NULL, 'Absent', employee_ID
FROM Employee
WHERE employee_ID NOT IN (
    SELECT emp_ID 
    FROM Attendance 
    WHERE date = @currentday
);

GO

EXEC Intitiate_Attendance ;



GO

CREATE PROC Update_Attendance
    @EmpID INT,
    @CheckIn TIME,
    @CheckOut TIME
as
BEGIN


    DECLARE @currentday DATE = CURRENT_TIMESTAMP;
    DECLARE @Status VARCHAR(10);
    DECLARE @TDuration TIME;

    
    IF @CheckIn IS NOT NULL AND @CheckOut IS NOT NULL
        SET @TDuration = @CheckOut - @CheckIn;
    ELSE
        SET @TDuration = NULL;

    
    IF @CheckIn IS NOT NULL AND @CheckOut IS NOT NULL
        SET @Status = 'Attended';
    ELSE
        SET @Status = 'Absent';

    
    UPDATE Attendance
    SET 
        check_in_time = @CheckIn,
        check_out_time = @CheckOut,
        total_duration = @TDuration,
        status = @Status
    WHERE emp_ID = @EmpID AND date = @currentday;
END;
GO
EXEC Update_Attendance;

GO
  
CREATE PROC Remove_Holiday
as
BEGIN
    DELETE Attend
    FROM Attendance Attend
    INNER JOIN Holiday H
    ON Attend.date >= H.from_date 
   AND Attend.date <= H.to_date;
END;
GO
EXEC Remove_Holiday;
GO 

CREATE PROC Remove_DayOff
    @employee_id INT
as
BEGIN
    

    DECLARE @dayoff VARCHAR(50);
    DECLARE @dayoff_num INT;

    DECLARE @curr_m INT = MONTH(CURRENT_TIMESTAMP);
    DECLARE @curr_y INT = YEAR(CURRENT_TIMESTAMP);

   
    SELECT @dayoff = official_day_off
    FROM Employee
    WHERE employee_ID = @employee_id;

   
    IF @dayoff = 'Sunday'
        SET @dayoff_num = 1;
    ELSE IF @dayoff = 'Monday'
        SET @dayoff_num = 2;
    ELSE IF @dayoff = 'Tuesday'
        SET @dayoff_num = 3;
    ELSE IF @dayoff = 'Wednesday'
        SET @dayoff_num = 4;
    ELSE IF @dayoff = 'Thursday'
        SET @dayoff_num = 5;
    ELSE IF @dayoff = 'Friday'
        SET @dayoff_num = 6;
    ELSE IF @dayoff = 'Saturday'
        SET @dayoff_num = 7;

    
    DELETE FROM Attendance
    WHERE emp_ID = @employee_id
      AND status = 'Absent'
      AND DATEPART(WEEKDAY, date) = @dayoff_num
      AND MONTH(date) = @curr_month
      AND YEAR(date) = @curr_year;
END
GO
EXEC Remove_DayOff;
GO
CREATE PROC Remove_Approved_Leaves
    @employee_id INT
as
BEGIN
    

    DELETE A
    FROM Attendance A
     INNER JOIN Leave L 
        ON A.date >= L.start_date AND A.date <= L.end_date
    WHERE A.emp_ID = @employee_id
      AND L.final_approval_status = 'approved'
      AND L.request_ID IN (
            SELECT request_ID FROM Annual_Leave WHERE emp_ID = @employee_id
            UNION
            SELECT request_ID FROM Accidental_Leave WHERE emp_ID = @employee_id
            UNION
            SELECT request_ID FROM Medical_Leave WHERE emp_ID = @employee_id
            UNION
            SELECT request_ID FROM Unpaid_Leave WHERE emp_ID = @employee_id
            UNION
            SELECT request_ID FROM Compensation_Leave WHERE emp_ID = @employee_id
      );
END
GO
EXEC Remove_Approved_Leaves;
GO

 --faridaaaaaa

 --2.5)o)
GO
CREATE PROC  Dean_andHR_Evaluation
@employee_ID int,
@rating int,
@comment varchar(50),
@semester char(3)
as

INSERT INTO Performance
VALUES (@rating, @comment, @semester, @employee_ID);

GO 

--2.5)n)
GO
CREATE PROC  Submit_compensation
@employee_ID int, 
@compensation_date date, 
@reason varchar(50), 
@date_of_original_workday date, 
@replacement_emp int
as
DECLARE @HRrep_id int;
DECLARE @employee_departement VARCHAR (50);
DECLARE @get_req_id int;

INSERT INTO Leave (date_of_request, start_date, end_date)
VALUES(CURRENT_TIMESTAMP, @compensation_date, @compensation_date);

--how to get the req_id of the leave?
SET @get_req_id= SCOPE_IDENTITY();


INSERT INTO Compensation_Leave (request_ID, reason, date_of_original_workday, emp_ID, replacement_emp)
VALUES (@get_req_id, @reason, @date_of_original_workday, @employee_ID, @replacement_emp);

INSERT INTO Employee_Replace_Employee
VALUES (@employee_ID, @replacement_emp, @compensation_date,@compensation_date);

SELECT @employee_departement = E.dept_name
FROM Employee E
WHERE E.employee_ID = @employee_ID;

SELECT TOP 1 @HRrep_id = E.employee_ID 
FROM Employee E INNER JOIN Employee_Role R ON (E.employee_ID= R.emp_ID)
WHERE R.role_name = ('HR_Representative_'+ @employee_departement) AND E.employment_status='active';

INSERT INTO Employee_Approve_Leave (Emp1_ID , Leave_ID , status)
VALUES (@HRrep_id , @get_req_id, 'pending');

GO

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
as 

DECLARE @get_req_id int;
DECLARE @HRrep_id INT;
DECLARE @employee_dep VARCHAR(50);
DECLARE @medical_dr_id INT;

INSERT INTO Leave (date_of_request, start_date, end_date)
VALUES (CURRENT_TIMESTAMP, @start_date, @end_date);

SET @get_req_id= SCOPE_IDENTITY();

INSERT INTO Medical_Leave (request_ID, insurance_status, disability_details, type, Emp_ID)
VALUES (@get_req_id, @insurance_status, @disability_details, @type, @employee_ID);

INSERT INTO Document (type, description, file_name , creation_date, expiry_date, status, emp_ID,medical_ID, unpaid_ID)
VALUES ('Medical', @document_description, @file_name, CURRENT_TIMESTAMP, NULL,'valid',@employee_ID, @get_req_id, NULL);

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
VALUES (@HRrep_id , @get_req_id, 'pending');

INSERT INTO Employee_Approve_Leave (Emp1_ID , Leave_ID , status)
VALUES (@medical_dr_id , @get_req_id, 'pending');

GO

--2.5)L)
GO
CREATE PROC Submit_unpaid
@employee_ID int, 
@start_date date, 
@end_date date,
@document_description varchar(50), 
@file_name varchar(50)
as

DECLARE @employee_dep VARCHAR(50);
DECLARE @HRrep_id INT;
DECLARE @get_req_id int;
DECLARE @president_id int;
DECLARE @employee_role VARCHAR(50);
DECLARE @HR_manager_id int;
DECLARE @higher_rank_emp_id int ;
DECLARE @emp_rank int ;

INSERT INTO Leave (date_of_request, start_date, end_date)
VALUES (CURRENT_TIMESTAMP, @start_date, @end_date);

SET @get_req_id= SCOPE_IDENTITY();

INSERT INTO Unpaid_Leave (request_ID, Emp_ID) 
VALUES (@get_req_id, @employee_ID);

INSERT INTO Document (type, description, file_name, creation_date, expiry_date, status, emp_ID, medical_id,unpaid_id)
VALUES ('Memo', @document_description, @file_name, CURRENT_TIMESTAMP, NULL, 'valid', @employee_ID, null, @get_req_id);

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
	VALUES (@HRrep_id , @get_req_id, 'pending');

	INSERT INTO Employee_Approve_Leave (Emp1_ID , Leave_ID , status)
	VALUES (@president_id , @get_req_id, 'pending');
END 
ELSE IF @employee_dep LIKE 'HR%'
BEGIN 
	SELECT TOP 1 @HR_manager_id = E.employee_ID
	FROM Employee E INNER JOIN Employee_Role R ON (E.employee_ID = R.emp_ID)
	WHERE E.employment_status = 'active' AND R.role_name = 'HR Manager';

	INSERT INTO Employee_Approve_Leave (Emp1_ID , Leave_ID , status)
	VALUES (@HR_manager_id, @get_req_id, 'pending');

	INSERT INTO Employee_Approve_Leave (Emp1_ID , Leave_ID , status)
	VALUES (@president_id ,@get_req_id, 'pending');
END 
ELSE 
BEGIN 
	SELECT TOP 1 @HRrep_id = E.employee_ID 
	FROM Employee E INNER JOIN Employee_Role R ON (E.employee_ID= R.emp_ID)
	WHERE R.role_name = ('HR_Representative_'+ @employee_dep) AND E.employment_status='active';

	INSERT INTO Employee_Approve_Leave (Emp1_ID , Leave_ID , status)
	VALUES (@HRrep_id , @get_req_id, 'pending');   --HR representative 

    INSERT INTO Employee_Approve_Leave VALUES (@president_id, @get_req_id, 'pending'); --upperboard president
	
	SELECT @emp_rank = R.rank 
	FROM Employee E inner join Employee_Role ER ON (E.employee_ID = ER.emp_ID)INNER JOIN Role R ON (ER.role_name = R.role_name)
	WHERE  E.employee_id = @employee_ID ;

	SELECT TOP 1 @higher_rank_emp_id = E.employee_ID
	FROM  Employee E INNER JOIN Employee_Role ER ON (E.employee_ID = ER.emp_ID)INNER JOIN Role R ON (ER.role_name = R.role_name)
	WHERE E.employment_status = 'active' AND R.rank < @emp_rank AND E.employee_ID <> @president_id AND E.employee_ID <> @HRrep_id
    AND E.employee_ID <> @employee_ID;

	INSERT INTO Employee_Approve_Leave (Emp1_ID , Leave_ID , status)
	VALUES (@higher_rank_emp_id, @get_req_id, 'pending');  --Higher ranking employee 
END

GO


--2.5)m)

GO
CREATE PROC Upperboard_approve_unpaids
@request_ID int, 
@Upperboard_ID int
as
--Employee_Approve_Leave (Emp1_ID int (FK), Leave_ID int (FK), status: varchar(50))
--Employee_ Approve _Employee. Emp1_ID references Employee. Employee_ID
--Employee_ Approve _Employee. Leave_ID references Leave.request_ID

UPDATE Employee_Approve_Leave 
SET status = 'approved'
WHERE Leave_ID = @request_ID AND Emp1_ID = @Upperboard_ID 
AND EXISTS (
SELECT *
FROM Document D
WHERE D.unpaid_ID = @request_ID AND D.type = 'Memo' AND D.status = 'valid')
AND EXISTS (
SELECT *
FROM Unpaid_Leave UL
WHERE UL.request_ID = @request_ID);

GO 


CREATE PROC Update_Status_Doc 
as 

if expiry_date  < CURRENT_TIMESTAMP 
	update document
	set status='expired';


GO
EXEC Update_Status_Doc ;


GO


CREATE PROC Remove_Deductions 
as 

DELETE FROM Deduction 
where emp_ID IN (
	select employee_ID 
	from Employee
	WHERE employment_status = 'resigned'
        );

 GO
 EXEC Remove_Deductions ;



GO


 CREATE PROC  Update_Employment_Status 
 
  @Employee_ID int 
as 

SELECT employee_ID
	FROM Employee
	WHERE employee_ID = @Employee_ID 
 
 --if employment_status ='active'
 --update Employee

GO
EXEC  Update_Employment_Status ;


GO


CREATE PROC Create_Holiday 
as

CREATE TABLE Holiday(
 holiday_id int primary key identity(1,1),
 name varchar(50),
 from_date date,
 to_date date
);

GO
EXEC Create_Holiday ;


GO


CREATE PROC Add_Holiday 

 @holiday_name varchar(50),
 @from_date date ,
 @to_date date

 as

 INSERT INTO Holiday (name, from_date, to_date)
    VALUES (@holiday_name, @from_date, @to_date);
 GO

 EXEC Add_Holiday;


 
--2.3(k)--
GO
CREATE PROC Replace_employee
    @Emp1_ID   INT,     
    @Emp2_ID   INT,      
    @from_date DATE,
    @to_date   DATE
AS
    DECLARE
        @isBusy INT;
    SET @isBusy = 0;
    -- 1) Basic validation--------------
    IF @Emp1_ID = @Emp2_ID
        RETURN;
    -- Invalid date range
    IF @from_date IS NULL OR @to_date IS NULL OR @from_date > @to_date
        RETURN;
    SELECT @isBusy = @isBusy + COUNT(*)
    FROM Leave L
    LEFT OUTER JOIN Annual_Leave       AL ON AL.request_ID = L.request_ID
    LEFT OUTER JOIN Accidental_Leave   AC ON AC.request_ID = L.request_ID
    LEFT OUTER JOIN Medical_Leave      ML ON ML.request_ID = L.request_ID
    LEFT OUTER JOIN Unpaid_Leave       UL ON UL.request_ID = L.request_ID
    LEFT OUTER JOIN Compensation_Leave CL ON CL.request_ID = L.request_ID
    WHERE L.final_approval_status = 'approved'
      AND L.start_date <= @to_date
      AND L.end_date   >= @from_date
      AND (
            AL.emp_ID = @Emp2_ID
         OR AC.emp_ID = @Emp2_ID
         OR ML.emp_ID = @Emp2_ID
         OR UL.emp_ID = @Emp2_ID
         OR CL.emp_ID = @Emp2_ID
      );

    SELECT @isBusy = @isBusy + COUNT(*)
    FROM Employee_Replace_Employee
    WHERE Emp2_ID   = @Emp2_ID
      AND from_date <= @to_date
      AND to_date   >= @from_date;
    IF @isBusy > 0
        RETURN;
    INSERT INTO Employee_Replace_Employee (Emp1_ID, Emp2_ID, from_date, to_date)
    VALUES (@Emp1_ID, @Emp2_ID, @from_date, @to_date);
GO;

--2.4(b)---
GO
CREATE PROC HR_approval_an_acc
    @request_ID INT,
    @HR_ID      INT
AS
    DECLARE 
        @emp_ID             INT,
        @start_date         DATE,
        @end_date           DATE,
        @num_days           INT,
        @annual_balance     INT,
        @accidental_balance INT,
        @leave_type         VARCHAR(50),
        @status             VARCHAR(50),
        @date_of_request    DATE,
        @replacement_emp    INT,
        @isBusy             INT,
        @prevRejected       INT,
        @type_of_contract   VARCHAR(50), 
        @pendingHigher INT;
    SET @pendingHigher = 0;
    SET @emp_ID       = NULL;
    SET @status       = NULL;
    SET @isBusy       = 0;
    SET @prevRejected = 0;

    SELECT @emp_ID = emp_ID
    FROM Annual_Leave
    WHERE request_ID = @request_ID;
    IF @emp_ID IS NOT NULL
    BEGIN
        SET @leave_type = 'annual';
    END
    ELSE
    BEGIN
        SELECT @emp_ID = emp_ID
        FROM Accidental_Leave
        WHERE request_ID = @request_ID;

        IF @emp_ID IS NOT NULL
            SET @leave_type = 'accidental';
    END
    SELECT 
        @start_date      = L.start_date, 
        @end_date        = L.end_date,
        @num_days        = L.num_days,
        @date_of_request = L.date_of_request
    FROM Leave L              
    WHERE L.request_ID = @request_ID;

    SELECT 
        @annual_balance     = annual_balance,
        @accidental_balance = accidental_balance,
        @type_of_contract   = type_of_contract      
    FROM Employee
    WHERE employee_ID = @emp_ID;

    SELECT @prevRejected = COUNT(*)
    FROM Employee_Approve_Leave
    WHERE Leave_ID = @request_ID
      AND status   = 'rejected';

    IF @prevRejected > 0
    BEGIN
        SET @status = 'rejected';
    END

IF @status IS NULL AND @leave_type = 'annual'
BEGIN
    SELECT @pendingHigher = COUNT(*)
        FROM Employee_Approve_Leave
        WHERE Leave_ID = @request_ID
          AND Emp1_ID <> @HR_ID
          AND status = 'pending';

        IF @pendingHigher > 0
            RETURN;
END
    IF @status IS NULL AND @leave_type = 'annual'
    BEGIN
        IF @type_of_contract = 'part_time'
        BEGIN
            SET @status = 'rejected';
        END
    END
    IF @status IS NULL AND @leave_type = 'annual'
    BEGIN
        SELECT @replacement_emp = replacement_emp
        FROM Annual_Leave
        WHERE request_ID = @request_ID;

        IF @replacement_emp IS NULL
        BEGIN
            SET @status = 'rejected';     
        END
        ELSE
        BEGIN
            SET @isBusy = 0;
            --  Replacement is on approved leave during the same period
            SELECT @isBusy = @isBusy + COUNT(*)
            FROM Leave L
            LEFT OUTER JOIN Annual_Leave       AL ON AL.request_ID = L.request_ID
            LEFT OUTER JOIN Accidental_Leave   AC ON AC.request_ID = L.request_ID
            LEFT OUTER JOIN Medical_Leave      ML ON ML.request_ID = L.request_ID
            LEFT OUTER JOIN Unpaid_Leave       UL ON UL.request_ID = L.request_ID
            LEFT OUTER JOIN Compensation_Leave CL ON CL.request_ID = L.request_ID
            WHERE L.final_approval_status = 'approved'
              AND L.start_date <= @end_date
              AND L.end_date   >= @start_date
              AND (
                    AL.emp_ID = @replacement_emp
                 OR AC.emp_ID = @replacement_emp
                 OR ML.emp_ID = @replacement_emp
                 OR UL.emp_ID = @replacement_emp
                 OR CL.emp_ID = @replacement_emp
              );
            --Replacement is already replacing someone
            SELECT @isBusy = @isBusy + COUNT(*)
            FROM Employee_Replace_Employee
            WHERE Emp2_ID   = @replacement_emp
              AND from_date <= @end_date
              AND to_date   >= @start_date;

            IF @isBusy > 0
                SET @status = 'rejected';
        END
    END

    IF @status IS NULL
    BEGIN
        IF @leave_type = 'annual'
        BEGIN
            IF @num_days <= @annual_balance
                SET @status = 'approved';
            ELSE
                SET @status = 'rejected';
        END
        ELSE IF @leave_type = 'accidental'
        BEGIN
            IF @num_days = 1
               AND @accidental_balance >= 1
               AND DATEDIFF(DAY, @date_of_request, CasT(GETDATE() as DATE)) <= 2
                SET @status = 'approved';
            ELSE
                SET @status = 'rejected';
        END
        ELSE
        BEGIN
            SET @status = 'rejected';
        END
    END
    INSERT INTO Employee_Approve_Leave (Emp1_ID, Leave_ID, status)
    VALUES (@HR_ID, @request_ID, @status);
    UPDATE Leave
    SET final_approval_status = @status
    WHERE request_ID = @request_ID;
    IF @status = 'approved'
    BEGIN
        IF @leave_type = 'annual'
        BEGIN
            UPDATE Employee
            SET annual_balance = annual_balance - @num_days
            WHERE employee_ID = @emp_ID;
        END
        ELSE IF @leave_type = 'accidental'
        BEGIN
            UPDATE Employee
            SET accidental_balance = accidental_balance - 1
            WHERE employee_ID = @emp_ID;
        END
    END
GO;

--2.4(c)---
GO
CREATE PROC HR_approval_unpaid 
    @request_ID INT, 
    @HR_ID      INT 
AS
    DECLARE 
        @emp_ID         INT,
        @num_days       INT,
        @annual_balance INT,
        @status         VARCHAR(50),
        @prevRejected   INT,
        @pendinGOthers  INT,
        @type_of_contract VARCHAR(50);

    SET @status        = NULL;
    SET @prevRejected  = 0;
    SET @pendinGOthers = 0;

    SELECT @emp_ID = emp_ID
    FROM Unpaid_Leave
    WHERE request_ID = @request_ID;
    IF @emp_ID IS NULL
    BEGIN
        SET @status = 'rejected';
        INSERT INTO Employee_Approve_Leave (Emp1_ID, Leave_ID, status)
        VALUES (@HR_ID, @request_ID, @status);
        UPDATE Leave
        SET final_approval_status = @status
        WHERE request_ID = @request_ID;

        RETURN;
    END

    SELECT @num_days = num_days
    FROM Leave
    WHERE request_ID = @request_ID;

    SELECT 
        @annual_balance   = annual_balance,
        @type_of_contract = type_of_contract
    FROM Employee
    WHERE employee_ID = @emp_ID;

    SELECT @prevRejected = COUNT(*)
    FROM Employee_Approve_Leave
    WHERE Leave_ID = @request_ID
      AND status   = 'rejected';

    IF @prevRejected > 0
    BEGIN
        SET @status = 'rejected';
    END

    IF @status IS NULL
    BEGIN
        SELECT @pendinGOthers = COUNT(*)
        FROM Employee_Approve_Leave
        WHERE Leave_ID = @request_ID
          AND Emp1_ID <> @HR_ID
          AND status = 'pending';

        IF @pendinGOthers > 0
        BEGIN
            -- Others haven't decided yet -> HR should not act
            RETURN;
        END
    END

    IF @status IS NULL
    BEGIN
        IF @type_of_contract = 'part_time'
        BEGIN
            SET @status = 'rejected';
        END
        ELSE
        BEGIN
            IF @annual_balance = 0 AND @num_days <= 30
                SET @status = 'approved';
            ELSE
                SET @status = 'rejected';
        END
    END
    INSERT INTO Employee_Approve_Leave (Emp1_ID, Leave_ID, status)
    VALUES (@HR_ID, @request_ID, @status);
    UPDATE Leave
    SET final_approval_status = @status
    WHERE request_ID = @request_ID;
GO;

--2.4(d)--
GO
CREATE PROC HR_approval_comp
    @request_ID INT,
    @HR_ID      INT
AS
    DECLARE
        @emp_ID                   INT,
        @reason                   VARCHAR(50),
        @date_of_original_workday DATE,
        @start_date               DATE,
        @end_date                 DATE,
        @date_of_request          DATE,
        @status                   VARCHAR(50),
        @workedMinutes            INT,
        @attStatus                VARCHAR(50),
        @hasAttendance            INT,
        @validReason              BIT,
        @replacement_emp          INT,
        @isBusy                   INT,
        @official_day             VARCHAR(50),
        @prevRejected             INT;   

    SET @status        = NULL;
    SET @workedMinutes = 0;
    SET @hasAttendance = 0;
    SET @validReason   = 0;
    SET @isBusy        = 0;
    SET @prevRejected  = 0;

    SELECT 
        @emp_ID                   = emp_ID,
        @reason                   = reason,
        @date_of_original_workday = date_of_original_workday,
        @replacement_emp          = replacement_emp
    FROM Compensation_Leave
    WHERE request_ID = @request_ID;

    IF @emp_ID IS NULL
    BEGIN
        SET @status = 'rejected';

        INSERT INTO Employee_Approve_Leave (Emp1_ID, Leave_ID, status)
        VALUES (@HR_ID, @request_ID, @status);

        UPDATE [Leave]
        SET final_approval_status = @status
        WHERE request_ID = @request_ID;

        RETURN;
    END

    SELECT 
        @start_date      = L.start_date,
        @end_date        = L.end_date,
        @date_of_request = L.date_of_request
    FROM Leave L
    WHERE L.request_ID = @request_ID;

    SELECT @prevRejected = COUNT(*)
    FROM Employee_Approve_Leave
    WHERE Leave_ID = @request_ID
      AND status   = 'rejected';

    IF @prevRejected > 0
    BEGIN
        SET @status = 'rejected';
    END

    IF @status IS NULL
    BEGIN
        SELECT @official_day = official_day_off
        FROM Employee
        WHERE employee_ID = @emp_ID;

        -- If the original workday is NOT the official day off -> reject
        IF DATENAME(WEEKDAY, @date_of_original_workday) <> @official_day
        BEGIN
            SET @status = 'rejected';
        END
    END

    IF @status IS NULL
    BEGIN
        IF @reason IS NOT NULL AND @reason <> ''
            SET @validReason = 1;
        ELSE
            SET @validReason = 0;
    END
    --    Employee must have attended and worked >= 8 hours-----
    IF @status IS NULL
    BEGIN
        SELECT 
            @hasAttendance = COUNT(*),
            @workedMinutes = MAX(DATEDIFF(MINUTE, check_in_time, check_out_time)),
            @attStatus     = MAX(status)
        FROM Attendance
        WHERE emp_ID = @emp_ID
          AND date = @date_of_original_workday;

        IF @hasAttendance = 0 OR @attStatus <> 'attended' OR @workedMinutes < 480
        BEGIN
            SET @status = 'rejected';
        END
    END

    -- 7) Check same-month condition: request vs original workday--
    IF @status IS NULL
    BEGIN
        IF NOT (YEAR(@date_of_request) = YEAR(@date_of_original_workday)
            AND MONTH(@date_of_request) = MONTH(@date_of_original_workday))
        BEGIN
            SET @status = 'rejected';
        END
    END
    -- 8) Compensation day must also be in the same month--------
    IF @status IS NULL
    BEGIN
        IF NOT (YEAR(@start_date) = YEAR(@date_of_original_workday)
            AND MONTH(@start_date) = MONTH(@date_of_original_workday))
        BEGIN
            SET @status = 'rejected';
        END
    END
    -- 9) Check replacement employee availability---
    IF @status IS NULL
    BEGIN
        IF @replacement_emp IS NULL
        BEGIN
            SET @status = 'rejected';
        END
        ELSE
        BEGIN
            SET @isBusy = 0;
            --  Replacement is on approved leave during compensation period
            SELECT @isBusy = @isBusy + COUNT(*)
            FROM Leave L
            LEFT JOIN Annual_Leave       AL ON AL.request_ID = L.request_ID
            LEFT JOIN Accidental_Leave   AC ON AC.request_ID = L.request_ID
            LEFT JOIN Medical_Leave      ML ON ML.request_ID = L.request_ID
            LEFT JOIN Unpaid_Leave       UL ON UL.request_ID = L.request_ID
            LEFT JOIN Compensation_Leave CL ON CL.request_ID = L.request_ID
            WHERE L.final_approval_status = 'approved'
              AND L.start_date <= @end_date
              AND L.end_date   >= @start_date
              AND (
                    AL.emp_ID = @replacement_emp
                 OR AC.emp_ID = @replacement_emp
                 OR ML.emp_ID = @replacement_emp
                 OR UL.emp_ID = @replacement_emp
                 OR CL.emp_ID = @replacement_emp
              );

            -- Replacement is already replacing someone in that period
            SELECT @isBusy = @isBusy + COUNT(*)
            FROM Employee_Replace_Employee
            WHERE Emp2_ID   = @replacement_emp
              AND from_date <= @end_date
              AND to_date   >= @start_date;

            IF @isBusy > 0
                SET @status = 'rejected';
        END
    END

    IF @status IS NULL
    BEGIN
        IF @validReason = 1
            SET @status = 'approved';
        ELSE
            SET @status = 'rejected';
    END

    INSERT INTO Employee_Approve_Leave (Emp1_ID, Leave_ID, status)
    VALUES (@HR_ID, @request_ID, @status);
    UPDATE Leave
    SET final_approval_status = @status
    WHERE request_ID = @request_ID;
GO;

---2.4(e)---
GO
CREATE PROC Deduction_hours
    @employee_ID INT
AS
    DECLARE
        @year                INT,
        @month               INT,
        @salary              DECIMAL(10,2),
        @base_salary         DECIMAL(10,2),
        @perc_YOE            DECIMAL(5,2),
        @YOE                 INT,
        @rate_per_hour       DECIMAL(10,4),
        @totalMissingMinutes INT,
        @missingHours        DECIMAL(10,4),
        @amount              DECIMAL(10,2),
        @first_attendance_id INT,
        @first_missing_date  DATE;

    SET @year  = YEAR(GETDATE());
    SET @month = MONTH(GETDATE());
    -- 1) Get highest-rank role and get its base salary and per yoe-----
    SELECT TOP 1
        @base_salary = R.base_salary,
        @perc_YOE    = R.percentage_YOE
    FROM Employee_Role ER
    JOIN Role R ON ER.role_name = R.role_name
    WHERE ER.emp_ID = @employee_ID
    ORDER BY R.rank DESC;       

    SELECT @YOE = years_of_experience
    FROM Employee
    WHERE employee_ID = @employee_ID;

    IF @base_salary IS NULL
        RETURN;  -- employee has no role ? no deduction

    SET @salary =@base_salary + (@perc_YOE / 100.0) * @YOE * @base_salary;
    SET @rate_per_hour = (@salary / 30.0) / 8.0;
    -- 3) Sum total missing minutes for this month----
    SELECT 
        @totalMissingMinutes = SUM(
            Case 
                WHEN status = 'attended'
                     AND DATEDIFF(MINUTE, check_in_time, check_out_time) < 480
                THEN 480 - DATEDIFF(MINUTE, check_in_time, check_out_time)
                ELSE 0
            END
        )
    FROM Attendance
    WHERE emp_ID = @employee_ID
      AND YEAR([date])  = @year
      AND MONTH([date]) = @month;

    IF @totalMissingMinutes IS NULL OR @totalMissingMinutes <= 0
        RETURN;
    -- 4) Get FIRST day with missing hours (month)----------
    SELECT TOP 1
        @first_attendance_id = attendance_ID,
        @first_missing_date  = [date]
    FROM Attendance
    WHERE emp_ID = @employee_ID
      AND YEAR([date])  = @year
      AND MONTH([date]) = @month
      AND status = 'attended'
      AND DATEDIFF(MINUTE, check_in_time, check_out_time) < 480
    ORDER BY [date], attendance_ID;

    IF @first_attendance_id IS NULL
        RETURN;
    SET @missingHours = @totalMissingMinutes / 60.0;
    SET @amount       = @rate_per_hour * @missingHours;

    INSERT INTO Deduction (emp_ID, [date], amount, type, unpaid_ID, attendance_ID)
    VALUES (@employee_ID, @first_missing_date, @amount, 'missing_hours', NULL, @first_attendance_id);
end


 GO;

 --2.5 f

 CREATE FUNCTION  Is_On_Leave
 (@employee_ID int, @from date, @to date )
 Returns bit 
AS
 Begin
 declare @Y bit =0;

if EXISTS(

 select Leave.start_date,Leave.end_date,Leave.request_ID -- start and end ??

 from Leave left outer join Annual_Leave on (Leave.request_ID = Annual_Leave.request_ID)
left outer join Accidental_Leave on (Annual_Leave.request_ID = Accidental_Leave.request_ID)
left outer join Medical_Leave on ( Accidental_Leave.request_ID=Medical_Leave.request_ID)
left outer join Unpaid_Leave on (Medical_Leave.request_ID=Unpaid_Leave.request_ID)
left outer join Compensation_Leave on (Unpaid_Leave.request_ID=Compensation_Leave.request_ID)

where (   
            @employee_ID=Annual_Leave.emp_ID
            or
            @employee_ID=Accidental_Leave.emp_ID
            or
            @employee_ID=Compensation_Leave.emp_ID
            or
            @employee_ID=Medical_Leave.Emp_ID
            or
            @employee_ID=Unpaid_Leave.Emp_ID
            )
    AND Leave.start_date <= @to       
          AND Leave.end_date >= @from
    )

 Set @Y= 1

 
Return @Y
end
--2.4(h)--
GO

CREATE FUNCTION Bonus_amount
(
    @employee_ID INT
)
RETURNS DECIMAL(10,2)
as
BEGIN
    DECLARE
        @base_salary      DECIMAL(10,2),
        @perc_YOE         DECIMAL(5,2),
        @YOE              INT,
        @salary           DECIMAL(10,2),
        @rate_per_hour    DECIMAL(10,4),
        @extraMinutes     INT,
        @extraHours       DECIMAL(10,4),
        @overtime_factor  DECIMAL(4,2),
        @bonus            DECIMAL(10,2),
        @year             INT,
        @month            INT;
    -- Work on current year & month
    SET @year  = YEAR(GETDATE());
    SET @month = MONTH(GETDATE());
    -- 1) Get highest-rank role and its base_salary, YOE% and overtime%
    SELECT TOP 1
        @base_salary     = R.base_salary,
        @perc_YOE        = R.percentage_YOE,
        @overtime_factor = R.percentage_overtime
    FROM Employee_Role ER
    JOIN Role R ON ER.role_name = R.role_name
    WHERE ER.emp_ID = @employee_ID
    ORDER BY R.rank;          -- highest rank = smallest rank value

    SELECT @YOE = years_of_experience
    FROM Employee
    WHERE employee_ID = @employee_ID;

    -- If no role or no experience info, bonus = 0
    IF @base_salary IS NULL OR @YOE IS NULL
        RETURN 0;

    -- If no overtime factor, treat as 0
    IF @overtime_factor IS NULL
        SET @overtime_factor = 0;
    SET @salary =@base_salary + (@perc_YOE / 100.0) * @YOE * @base_salary;
    SET @rate_per_hour = (@salary / 30.0) / 8.0;
    SELECT 
        @extraMinutes = SUM(
            CasE 
                WHEN status = 'attended'
                     AND DATEDIFF(MINUTE, check_in_time, check_out_time) > 480
                THEN DATEDIFF(MINUTE, check_in_time, check_out_time) - 480
                ELSE 0
            END
        )
    FROM Attendance
    WHERE emp_ID = @employee_ID
      AND YEAR([date])  = @year
      AND MONTH([date]) = @month;
    -- No overtime ? bonus = 0
    IF @extraMinutes IS NULL OR @extraMinutes <= 0
        RETURN 0;
    SET @extraHours = @extraMinutes / 60.0;
    SET @bonus = @rate_per_hour * ((@overtime_factor * @extraHours) / 100.0);

    RETURN @bonus;
END
GO


--2.5(a)--
GO
CREATE FUNCTION EmployeeLoginValidation
(
    @employee_ID INT,
    @password    VARCHAR(50)
)
RETURNS BIT
as
BEGIN
    DECLARE @success BIT = 0;  -- default false

    SELECT @success = 1
    FROM Employee
    WHERE employee_ID = @employee_ID
      AND password = @password;

    RETURN @success;
END
GO


--2.5(b)---
GO
CREATE FUNCTION MyPerformance
(
    @employee_ID INT,
    @semester    CHAR(3)
)
RETURNS TABLE
as
RETURN
(
    SELECT 
        performance_ID,rating,comments,semester,emp_ID
    FROM Performance
    WHERE emp_ID = @employee_ID
      AND semester = @semester
);
GO

--2.2)a)
GO
CREATE VIEW allEmployeeProfiles
as 

SELECT  employee_ID, first_name,last_name, gender, email, address, years_of_experience,
official_day_off,type_of_contract,employment_status,
annual_balance, accidental_balance
FROM Employee ;

GO


--2.2)b)

GO
CREATE VIEW NoEmployeeDept
as 

SELECT D.name, COUNT (E.employee_ID) as employee_count
FROM Department D LEFT OUTER JOIN Employee E ON (E.dept_name = D.name)
GROUP BY D.name;

GO

--2.2)c)
GO 
CREATE VIEW allPerformance
as

SELECT *
FROM Performance 
WHERE semester like 'W%';
GO


--- Yasmin Was HERE--
--2.2)D) yasmin  DONE
GO

CREATE VIEW allRejectedMedicals
as
SELECT *
FROM Medical_Leave ML INNER JOIN Leave L ON ML.request_ID = L.request_ID
WHERE L.final_approval_status = 'rejected';

--2.2)e) yasmin DONE

GO

CREATE VIEW allEmployeeAttendance
as
SELECT * 
FROM Attendance --- am i allowed to use this? how else would i check the date is yesterday?
WHERE status = 'attended' AND date = Cast (DATEADD (day,-1,GETDATE()) as date) ;
GO

--2.4)a) yasmin DONE

CREATE FUNCTION HRLoginValidation
(@employee_ID int , @password varchar(50))
returns bit
as
begin
DECLARE @success bit
if EXISTS (SELECT * FROM Employee E INNER JOIN Employee_Role R 
ON E.employee_ID = R.emp_ID
WHERE E.employee_ID= @employee_ID AND
E.password= @password AND
ER.role_name LIKE 'HR%' 
AND E.employment_status='active')

set @success=1
else
set @success=0
return @success
end
go

-- helper function to calculate salary DONE
go

CREATE FUNCTION Calc_Salary (@employee_ID int)
returns decimal (10,2)
AS
begin
DECLARE @salary decimal (10,2) = 0.0;
DECLARE @base_salary decimal (10,2)
DECLARE @perc_YOE DECIMAL(5,2);
DECLARE @YOE INT;

SELECT TOP 1
        @base_salary = R.base_salary,
        @perc_YOE    = R.percentage_YOE
    FROM Employee_Role ER
    JOIN Role R ON ER.role_name = R.role_name
    WHERE ER.emp_ID = @employee_ID
    ORDER BY R.rank DESC;       

    SELECT @YOE = years_of_experience
    FROM Employee
    WHERE employee_ID = @employee_ID;

    IF @base_salary IS NULL

    SET @salary =@base_salary + (@perc_YOE / 100.0) * @YOE * @base_salary;
      return @salary
end
go
--2.4)f) yasmin Add deduction due to missing days DONE
     

  CREATE PROC Deduction_days
  @employee_id INT
    as
    BEGIN
   declare @salary as  decimal (10,2)
   declare @ded_per_day as decimal (10,2)
   set @salary  = dbo.Calc_Salary (@employee_ID )
   set @ded_per_day = @salary /22.0 -- rate per day

   Insert INTO Deduction (emp_ID, date, amount, type,  unpaid_ID, attendance_ID) 
    SELECT A.emp_ID, A.date, @ded_per_day , 'missing_days', NULL, A.attendance_ID
    FROM Attendance A 
    WHERE A.emp_ID = @employee_ID
    AND A.check_in_time IS NULL
    AND A.check_out_time IS NULL;

    END
    go
-- 2.4)g) yasmin Add deduction due to unpaid leave.
-- WORKING ON IT GIVE ME A MIN
CREATE PROCEDURE Deduction_unpaid
    @employee_ID INT
AS
BEGIN
 declare @salary as  decimal (10,2)
   declare @ded_per_day as decimal (10,2)
   set @salary  = dbo.Calc_Salary (@employee_ID )
   set @ded_per_day = @salary /22.0 -- rate per day

  -- INSERT INTO Deduction (emp_ID, date, amount, type,  unpaid_ID, attendance_ID)


END 
GO


--2.4)I) yasmin DONE




CREATE PROC Add_Payroll 
@employee_ID int,
@from date, 
@to date
as
DECLARE @Bonus decimal (10,2)
DECLARE @totalDeductions decimal (10,2)
DECLARE @final_salary_amount decimal (10,1)

set @Bonus = dbo.Bonus_amount (@employee_ID)

set @totalDeductions = (SELECT SUM (amount) FROM Deduction 
WHERE emp_ID = @employee_ID AND date BETWEEN @from AND @to and status = 'pending' )

set @final_salary_amount =  dbo.Calc_Salary (@employee_ID ) + @Bonus - @totalDeductions

GO
INSERT INTO
Payroll ( payment_date, final_salary_amount, from_date,
to_date,  bonus_amount, deductions_amount, emp_ID ) --how am i supposed to add comments??

VALUES ( GETDATE(), @final_salary_amount,@from,
@to,  @Bonus, @totalDeductions, @employee_ID)

UPDATE Deduction
SET status = 'finalized'
WHERE emp_ID = @employee_ID AND date BETWEEN @from AND @to and status = 'pending'

go
--2.5)G) yasmin Apply for an annual leave   


---2.5)I) yasmin As a Dean/Vice-dean/President I can approve/reject annual
--leaves

--2.5)J) yasmin Apply for an accidental leave.


--2.5 h

CREATE FUNCTION Status_leaves
 (@employee_ID INT)
 RETURNS TABLE
 AS
 RETURN 
(
 SELECT Leave.request_ID, Leave.date_of_request, Leave.final_approval_status

FROM leave inner join Annual_Leave on (Leave.request_ID=Annual_Leave.request_ID)

where month(date_of_request)=month (CURRENT_TIMESTAMP)  
AND @employee_ID =Annual_Leave.emp_ID 

UNION 

SELECT Leave.request_ID, Leave.date_of_request, Leave.final_approval_status

FROM leave inner join Accidental_Leave on (Leave.request_ID=Accidental_Leave.request_ID)

where month(date_of_request)=month (CURRENT_TIMESTAMP)  
AND @employee_ID =Accidental_Leave.emp_ID 


 )

 go
 -- yasmeen added this part for testing
 go
 --2.3 F
 CREATE PROC Intitiate_Attendance 
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



go
--2.3 g
CREATE PROC Update_Attendance
    @EmpID INT,
    @CheckIn TIME,
    @CheckOut TIME
AS
BEGIN


    DECLARE @currentday DATE = CURRENT_TIMESTAMP;
    DECLARE @Status VARCHAR(10);
    DECLARE @TDuration TIME;

    
    IF @CheckIn IS NOT NULL AND @CheckOut IS NOT NULL
        SET @TDuration = @CheckOut - @CheckIn;
    ELSE
        SET @TDuration = NULL;

    
    IF @CheckIn IS NOT NULL AND @CheckOut IS NOT NULL
        SET @Status = 'Attended';
    ELSE
        SET @Status = 'Absent';

    
    UPDATE Attendance
    SET 
        check_in_time = @CheckIn,
        check_out_time = @CheckOut,
        total_duration = @TDuration,
        status = @Status
    WHERE emp_ID = @EmpID AND date = @currentday;
END;
go
EXEC Update_Attendance;


go




--2.3 g
go

CREATE PROC Update_Attendance
    @EmpID INT,
    @CheckIn TIME,
    @CheckOut TIME
AS
BEGIN


    DECLARE @currentday DATE = CURRENT_TIMESTAMP;
    DECLARE @Status VARCHAR(10);
    DECLARE @TDuration TIME;

    
    IF @CheckIn IS NOT NULL AND @CheckOut IS NOT NULL
        SET @TDuration = @CheckOut - @CheckIn;
    ELSE
        SET @TDuration = NULL;

    
    IF @CheckIn IS NOT NULL AND @CheckOut IS NOT NULL
        SET @Status = 'Attended';
    ELSE
        SET @Status = 'Absent';

    
    UPDATE Attendance
    SET 
        check_in_time = @CheckIn,
        check_out_time = @CheckOut,
        total_duration = @TDuration,
        status = @Status
    WHERE emp_ID = @EmpID AND date = @currentday;
END;
go
EXEC Update_Attendance;

go
  --2.3 h
CREATE PROC Remove_Holiday
AS
BEGIN
    DELETE Attend
    FROM Attendance Attend
    INNER JOIN Holiday H
    ON Attend.date >= H.from_date 
   AND Attend.date <= H.to_date;
END;
go
EXEC Remove_Holiday;
go 

go 
--2.3 i
CREATE PROC Remove_DayOff
    @employee_id INT
AS
BEGIN
    

    DECLARE @dayoff VARCHAR(50);
    DECLARE @dayoff_num INT;

    DECLARE @curr_m INT = MONTH(CURRENT_TIMESTAMP);
    DECLARE @curr_y INT = YEAR(CURRENT_TIMESTAMP);

   
    SELECT @dayoff = official_day_off
    FROM Employee
    WHERE employee_ID = @employee_id;

   
    IF @dayoff = 'Sunday'
        SET @dayoff_num = 1;
    ELSE IF @dayoff = 'Monday'
        SET @dayoff_num = 2;
    ELSE IF @dayoff = 'Tuesday'
        SET @dayoff_num = 3;
    ELSE IF @dayoff = 'Wednesday'
        SET @dayoff_num = 4;
    ELSE IF @dayoff = 'Thursday'
        SET @dayoff_num = 5;
    ELSE IF @dayoff = 'Friday'
        SET @dayoff_num = 6;
    ELSE IF @dayoff = 'Saturday'
        SET @dayoff_num = 7;

    
    DELETE FROM Attendance
    WHERE emp_ID = @employee_id
      AND status = 'Absent'
      AND DATEPART(WEEKDAY, date) = @dayoff_num
      AND MONTH(date) = @curr_month
      AND YEAR(date) = @curr_year;
END;
go
EXEC Remove_DayOff;
go
--2.3 j
CREATE PROCEDURE Remove_Approved_Leaves
    @employee_id INT
AS
BEGIN
    

    DELETE A
    FROM Attendance A
     INNER JOIN Leave L 
        ON A.date >= L.start_date AND A.date <= L.end_date
    WHERE A.emp_ID = @employee_id
      AND L.final_approval_status = 'approved'
      AND L.request_ID IN (
            SELECT request_ID FROM Annual_Leave WHERE emp_ID = @employee_id
            UNION
            SELECT request_ID FROM Accidental_Leave WHERE emp_ID = @employee_id
            UNION
            SELECT request_ID FROM Medical_Leave WHERE emp_ID = @employee_id
            UNION
            SELECT request_ID FROM Unpaid_Leave WHERE emp_ID = @employee_id
            UNION
            SELECT request_ID FROM Compensation_Leave WHERE emp_ID = @employee_id
      );
END;
go
EXEC Remove_Approved_Leaves;
go
--2.5 b
CREATE FUNCTION MyPerformance
(
    @employee_ID INT,
    @semester CHAR(3)
)
RETURNS TABLE
AS
RETURN
(
    SELECT performance_ID, rating, comments, semester, emp_ID
    FROM Performance
    WHERE emp_ID = @employee_ID
      AND semester = @semester
);
GO
--2.5 c
CREATE FUNCTION MyAttendance
(
    @employee_ID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        Att.attendance_ID,
        Att.date,
        Att.check_in_time,
        Att.check_out_time,
        Att.total_duration,
        Att.status,
        Att.emp_ID
    FROM Attendance Att
    INNER JOIN Employee E
        ON Att.emp_ID = E.employee_ID
    WHERE 
        Att.emp_ID = @employee_ID
        AND MONTH(Att.date) = MONTH(CURRENT_TIMESTAMP)
        AND YEAR(Att.date)  = YEAR(CURRENT_TIMESTAMP)
        AND NOT 
        (
            Att.status = 'Absent'
            AND DATEPART(WEEKDAY, Att.date) =
                CASE E.official_day_off
                    WHEN 'Sunday' THEN 1
                    WHEN 'Monday' THEN 2
                    WHEN 'Tuesday' THEN 3
                    WHEN 'Wednesday' THEN 4
                    WHEN 'Thursday' THEN 5
                    WHEN 'Friday' THEN 6
                    WHEN 'Saturday' THEN 7
                END
        )
);
GO
--2.5 d
CREATE FUNCTION Last_month_payroll
(
    @employee_ID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        ID, payment_date, final_salary_amount,
        from_date, to_date, comments, 
        bonus_amount, deductions_amount, emp_ID
    FROM Payroll
    WHERE emp_ID = @employee_ID
      AND MONTH(to_date) = 
            CASE 
                WHEN MONTH(CURRENT_TIMESTAMP) = 1 
                     THEN 12
                ELSE MONTH(CURRENT_TIMESTAMP) - 1
            END
      AND YEAR(to_date) =
            CASE 
                WHEN MONTH(CURRENT_TIMESTAMP) = 1
                     THEN YEAR(CURRENT_TIMESTAMP) - 1
                ELSE YEAR(CURRENT_TIMESTAMP)
            END
);
GO
 
