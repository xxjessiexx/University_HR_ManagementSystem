CREATE DATABASE University_HR_ManagementSystem_28;

GO

USE University_HR_ManagementSystem_28;

--2.1(b)
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
FOREIGN KEY (dept_name) REFERENCES Department(name) on update cascade,
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
FOREIGN KEY(emp_ID) REFERENCES Employee(employee_ID) on update cascade,
FOREIGN KEY(role_name) REFERENCES Role (role_name) on update cascade
);

CREATE TABLE Role_existsIn_Department (
department_name VARCHAR(50), 
Role_name VARCHAR(50),
PRIMARY KEY(department_name, Role_name),
FOREIGN KEY (department_name) REFERENCES Department(name) on update cascade,
FOREIGN KEY (Role_name) REFERENCES Role (role_name) on update cascade
) ;

CREATE TABLE Leave (
request_ID int IDENTITY(1,1) PRIMARY KEY , 
date_of_request date, 
start_date date, 
end_date date, 
final_approval_status varchar (50) DEFAULT 'pending',
CHECK (final_approval_status IN ('approved', 'rejected', 'pending')),
num_days as (DATEDIFF(day, start_date, end_date) + 1) 

);

CREATE TABLE Annual_Leave (
request_ID int PRIMARY KEY , 
emp_ID int , 
replacement_emp int, 
FOREIGN KEY (emp_id) REFERENCES Employee(employee_ID) on update cascade,
FOREIGN KEY (request_ID) REFERENCES Leave (request_ID) on update cascade,
FOREIGN KEY (replacement_emp) REFERENCES Employee (employee_ID) on update cascade);

CREATE TABLE Accidental_Leave (
request_ID int PRIMARY KEY,
emp_ID int,
FOREIGN KEY (request_ID) REFERENCES Leave (request_ID) on update cascade,
FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID) on update cascade);

CREATE TABLE Medical_Leave (
request_ID int PRIMARY KEY , 
insurance_status BIT,
disability_details varchar (50), 
type varchar (50), 
Emp_ID int,
FOREIGN KEY (request_ID) REFERENCES Leave (request_ID) on update cascade,
FOREIGN KEY (Emp_ID) REFERENCES Employee(employee_ID) on update cascade,
CHECK (type in ('sick', 'maternity'))
) ;

CREATE TABLE Unpaid_Leave (
request_ID int PRIMARY KEY, 
Emp_ID int, 
FOREIGN KEY (request_ID) REFERENCES Leave (request_ID)on update cascade,
FOREIGN KEY (Emp_ID) REFERENCES Employee(employee_ID) on update cascade
);

CREATE TABLE Compensation_Leave (
request_ID int PRIMARY KEY,
reason varchar(50), 
date_of_original_workday date, 
emp_ID int ,
replacement_emp int,
FOREIGN KEY (request_ID) REFERENCES Leave(request_ID) on update cascade,
FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID) on update cascade,
FOREIGN KEY (replacement_emp) REFERENCES Employee(employee_ID) on update cascade
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
FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID) on update cascade,
FOREIGN KEY (medical_ID) REFERENCES Medical_Leave(request_ID) on update cascade,
FOREIGN KEY (unpaid_ID) REFERENCES Unpaid_Leave(request_ID) on update cascade
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
total_duration AS (DATEDIFF(MINUTE, check_in_time, check_out_time)), 
CHECK (status in ('absent', 'attended')),
FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID) on update cascade
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
FOREIGN KEY (emp_ID) REFERENCES Employee (employee_ID)on update cascade,
FOREIGN KEY (unpaid_ID) REFERENCES Unpaid_Leave (request_ID) on update cascade,
FOREIGN KEY (attendance_ID) REFERENCES Attendance (attendance_ID) on update cascade,
PRIMARY KEY(deduction_ID, emp_ID)
);

CREATE TABLE Performance (
performance_ID int IDENTITY(1,1) PRIMARY KEY ,
rating int,
comments varchar (50),
semester char (3), 
emp_ID int, 
FOREIGN KEY (emp_ID) REFERENCES Employee(employee_ID) on update cascade,
CHECK (rating BETWEEN 1 AND 5)
) ;

CREATE TABLE Employee_Replace_Employee (
Table_ID int IDENTITY(1,1),
Emp1_ID int ,
Emp2_ID int ,
from_date date, 
to_date date,
PRIMARY KEY (Table_ID, Emp1_ID, Emp2_ID),
FOREIGN KEY (Emp1_ID) REFERENCES Employee (Employee_ID) on update cascade,
FOREIGN KEY (Emp2_ID) REFERENCES Employee (Employee_ID) on update cascade
);

CREATE TABLE Employee_Approve_Leave (
Emp1_ID int,
Leave_ID int, 
status varchar (50),
PRIMARY KEY (Emp1_ID, Leave_ID),
FOREIGN KEY (Emp1_ID) REFERENCES Employee (Employee_ID) on update cascade,
FOREIGN KEY (Leave_ID) REFERENCES Leave (request_ID) on update cascade,
CHECK (status in ('approved', 'rejected', 'pending'))
);

go

--2.1(c)
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
    DROP TABLE IF EXISTS Holiday; -- do i need to drop holiday table?? YES
GO


 --2.1(d)
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
    DROP FUNCTION HRLoginValidation; --do i need to drop my helper functionss?? DROP  REMEBER
    DROP FUNCTION Bonus_amount;
    DROP FUNCTION EmployeeLoginValidation;
    DROP FUNCTION MyPerformance;
    DROP FUNCTION MyAttendance;
    DROP FUNCTION Last_month_payroll;
    DROP FUNCTION Deductions_Attendance;
    DROP FUNCTION Is_On_Leave;
    DROP FUNCTION Status_leaves;
    drop function if exists Deduction_per_day
    drop function if exists type_contract
    drop function if exists getRole
    drop function if exists getDep
    drop function if exists HR_rep
    drop function if exists getDeans
    drop function if exists get_President
    drop function if exists get_HR_Manager
    drop function if exists CalculateDays
    drop function if exists Calc_Salary
    drop function if exists get_hr_rep_for_emp

    -- DROP ALL STORED PROCEDURES-----
    DROP PROC createAllTables;
    DROP PROC dropAllTables;
    DROP PROC clearAllTables;
    DROP PROC Update_Status_Doc;         
    DROP PROC Remove_Deductions;
    DROP PROC Update_Employment_Status;
    DROP PROC Create_Holiday;
    DROP PROC Add_Holiday;
    DROP PROC Intitiate_Attendance ;
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

--2.1(e)
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
GO
-- YASMIN'S HELPER FNS
   go
  CREATE FUNCTION Deduction_per_day
  (@employee_ID int)
     returns decimal (10,2)
     AS
     begin
     DECLARE @salary decimal (10,2)
     DECLARE @ded_per_day decimal (10,2)
     set @salary  = dbo.Calc_Salary (@employee_ID )
     set @ded_per_day = @salary /22.0
     return @ded_per_day
     END
     go


CREATE FUNCTION type_contract(@employee_ID INT) returns varchar(50) --checks for part time contract <3
AS
BEGIN
   declare @part_time_check varchar(50) ;
   select @part_time_check = type_of_contract
    FROM Employee
    WHERE employee_ID = @employee_ID;
    return @part_time_check;
END
GO
CREATE FUNCTION getRole(@employee_ID INT) returns varchar(50) --gets the role of an employee <3
AS
BEGIN
DECLARE @role varchar(50);
   SELECT TOP 1 @role = R.role_name
    FROM Employee E 
    inner join Employee_Role ER ON E.employee_ID = ER.emp_ID
    inner join Role R ON ER.role_name = R.role_name
    WHERE E.employee_ID = @employee_ID
    ORDER BY R.rank ASC;

RETURN @role
END
GO
CREATE FUNCTION getDep(@employee_ID INT) returns varchar(50) --returns the department my emp works in <3
AS
BEGIN
DECLARE @dep varchar(50);
SELECT @dep = E.dept_name
FROM Employee E
WHERE E.employee_ID = @employee_ID

RETURN @dep
END
GO

CREATE FUNCTION HR_rep(@employee_ID INT) returns INT --get the representative for your employee  in same dep<3
AS
BEGIN
   DECLARE @HRrep INT;
   DECLARE @dep VARCHAR(50) =  dbo.getDep(@employee_ID) ;
   declare @returned int
   DECLARE @CurrentDate DATE = CAST(GETDATE() AS DATE);
   SELECT TOP 1 @HRrep = E.employee_ID 
    FROM Employee E 
    INNER JOIN Employee_Role R ON E.employee_ID = R.emp_ID
    WHERE R.role_name = ('HR_Representative_' + @dep) ;

    if EXISTS (SELECT 1 FROM Employee WHERE employee_ID = @HRrep AND employment_status = 'active')
    begin
    set @returned = @HRrep
    end
    else 
    begin

    select top 1 @returned = Emp2_ID from Employee_Replace_Employee 
    where Emp1_ID = @HRrep AND from_date <= @CurrentDate AND to_date >= @CurrentDate
    order by Table_ID desc
    end
    return @returned

END
GO

CREATE FUNCTION get_Dean(@dep VARCHAR(50)) returns INT -- get id dean/vice dean in same dep <3
AS
BEGIN
DECLARE @d_vd INT
SELECT TOP 1 @d_vd = e.employee_ID
FROM Employee E INNER JOIN  Employee_Role ER ON E.employee_ID = ER.emp_ID
INNER JOIN Role R ON R.role_name = ER.role_name
WHERE E.dept_name = @dep AND R.role_name IN ('Dean','Vice Dean')
AND E.employment_status = 'active'
ORDER BY R.rank ASC
RETURN @d_vd;

END
GO

CREATE FUNCTION get_President() returns INT -- get id dean/vice dean in same dep with rank higher than input
AS
BEGIN
DECLARE @PresidentID INT;

    SELECT TOP 1 @PresidentID = E.employee_ID
    FROM Employee E 
    INNER JOIN Employee_Role ER ON E.employee_ID = ER.emp_ID
    INNER JOIN Role R ON R.role_name = ER.role_name
    WHERE R.role_name like 'President' or R.role_name like 'Vice%President' 
    AND E.employment_status = 'active'
    ORDER BY R.rank ASC; 
    
    RETURN @PresidentID;
END

go


CREATE FUNCTION get_HR_Manager() returns INT -- get id HR in same dep with rank higher than input 
AS
BEGIN
DECLARE @HR INT
SELECT TOP 1 @HR = E.employee_ID
FROM Employee E INNER JOIN  Employee_Role ER ON E.employee_ID = ER.emp_ID
INNER JOIN Role R ON R.role_name = ER.role_name
WHERE  R.role_name like 'HR%Manager' 
ORDER BY R.rank ASC
RETURN @HR;
END

go
go
CREATE FUNCTION CalculateDays
(
    @Leave_Start DATE,
    @Leave_End DATE,
    @Month_Date DATE 
)
RETURNS INT
AS
BEGIN
    
    DECLARE @Month_Start DATE = DATEFROMPARTS(YEAR(@Month_Date), MONTH(@Month_Date), 1);
    DECLARE @Month_End DATE = EOMONTH(@Month_Date);  
    DECLARE @S DATE = @Leave_Start; 
    DECLARE @E DATE = @Leave_End;     
    DECLARE @days INT;

    IF @S < @Month_Start
        SET @S = @Month_Start;
 
    IF @E > @Month_End
        SET @E = @Month_End;
     IF @S > @E
        SET @days = 0;
    ELSE
        
        SET @days = DATEDIFF(DAY, @S, @E) + 1;
        
    RETURN @days;
END;
GO

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

--2.2)a)
GO
CREATE VIEW allEmployeeProfiles
as 

SELECT  employee_ID, first_name,last_name, gender, email, address, years_of_experience,
official_day_off,type_of_contract,employment_status,annual_balance, accidental_balance
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
SELECT L.request_ID AS "leave request id",
    L.date_of_request as "date of request",
    L.start_date as "start date",
    L.end_date as "end date",
    L.final_approval_status as "approval status",
    L.num_days as "number of days",
    
    M.insurance_status,
    M.disability_details,
    M.type,
    M.Emp_ID AS Employee_ID_ML 
FROM Medical_Leave M INNER JOIN Leave L ON M.request_ID = L.request_ID
WHERE L.final_approval_status = 'rejected';


--2.2)e) yasmin 
GO
CREATE  VIEW allEmployeeAttendance
as
SELECT * 
FROM Attendance 
WHERE status = 'attended' AND date = CAST(DATEADD(day, -1, current_timestamp ) AS DATE)  ;
GO
--2.3(a)
GO
CREATE PROC Update_Status_Doc 
as 
update document
set status = 'expired'
where expiry_date < CURRENT_TIMESTAMP;
GO

--2.3(b)
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

-- 2.3)c) Update the employees employment_status daily yasmin
go
CREATE PROC Update_Employment_Status
    @Employee_ID int
AS
BEGIN
    declare @Today DATE = CAST(GETDATE() AS DATE);
    
   declare @IsOnLeave BIT = dbo.Is_On_Leave(@Employee_ID, @Today, @Today);
    
    declare @CurrentStatus VARCHAR(50);
    
    SELECT @CurrentStatus = employment_status
    FROM Employee
    WHERE employee_ID = @Employee_ID;

    IF @CurrentStatus = 'active' AND @IsOnLeave = 1
    BEGIN
        UPDATE Employee
        SET employment_status = 'onleave'
        WHERE employee_ID = @Employee_ID;
    END
    
    ELSE IF @CurrentStatus = 'onleave' AND @IsOnLeave = 0
    BEGIN
        UPDATE Employee
        SET employment_status = 'active'
        WHERE employee_ID = @Employee_ID;
    END
END
GO


--2.3(d)
GO
CREATE PROC Create_Holiday 
as

CREATE TABLE Holiday(
 holiday_id int identity(1,1) primary key ,
 name varchar(50),
 from_date date,
 to_date date
);
GO


--2.3(e)
GO
CREATE PROC Add_Holiday 

 @holiday_name varchar(50),
 @from_date date ,
 @to_date date

 as

 INSERT INTO Holiday (name, from_date, to_date)
    VALUES (@holiday_name, @from_date, @to_date);
GO

--2.3(f)
GO
CREATE PROC  Intitiate_Attendance 
as 
DECLARE @currentday DATE = CAST(GETDATE() AS DATE);
INSERT INTO Attendance (date, check_in_time, check_out_time,  status, emp_ID)
SELECT @currentday, NULL, NULL, 'absent', employee_ID
FROM Employee
WHERE employee_ID NOT IN (
    SELECT emp_ID 
    FROM Attendance 
    WHERE date = @currentday
);

GO


--2.3(g)
GO
CREATE PROC Update_Attendance
     @Employee_id INT, 
     @check_in TIME,
     @check_out TIME
AS
BEGIN
    DECLARE @currentday DATE = CAST(GETDATE() AS DATE);
    DECLARE @Status VARCHAR(10);
    -- Determine status
    IF @check_in IS NOT NULL AND @check_out IS NOT NULL
        SET @Status = 'attended';    
    ELSE
        SET @Status = 'absent';

    UPDATE Attendance
    SET 
        check_in_time = @check_in,
        check_out_time = @check_out,
        status = @Status
    WHERE emp_ID = @Employee_id 
      AND [date] = @currentday;
END
GO




--2.3(h)
GO
CREATE PROC Remove_Holiday
AS
BEGIN
    DELETE 
    FROM Attendance 
    WHERE Attendance.attendance_ID IN (SELECT Attendance.attendance_ID FROM Attendance INNER JOIN Holiday H
    ON Attendance.date >= H.from_date
    AND Attendance.date <= H.to_date);
    
END;
go

--2.3 (i)
GO
CREATE PROC Remove_DayOff
    @Employee_id INT
AS
BEGIN
    SET DATEFIRST 7;    -- Ensure Sunday = 1

    DECLARE @dayoff VARCHAR(50);
    DECLARE @dayoff_num INT;
    DECLARE @curr_month INT = MONTH(GETDATE());
    DECLARE @curr_year  INT = YEAR(GETDATE());

    -- Get employees official weekly day off
    SELECT @dayoff = official_day_off
    FROM Employee
    WHERE employee_ID = @Employee_id;

    -- Map weekday name to number
    IF @dayoff = 'Sunday'      SET @dayoff_num = 1;
    ELSE IF @dayoff = 'Monday' SET @dayoff_num = 2;
    ELSE IF @dayoff = 'Tuesday' SET @dayoff_num = 3;
    ELSE IF @dayoff = 'Wednesday' SET @dayoff_num = 4;
    ELSE IF @dayoff = 'Thursday' SET @dayoff_num = 5;
    ELSE IF @dayoff = 'Friday' SET @dayoff_num = 6;
    ELSE IF @dayoff = 'Saturday' SET @dayoff_num = 7;

    DELETE FROM Attendance
    WHERE emp_ID = @Employee_id
      AND status = 'absent'             
      AND DATEPART(WEEKDAY, [date]) = @dayoff_num
      AND MONTH([date]) = @curr_month
      AND YEAR([date]) = @curr_year;
END
GO


--2.3(j)
go
CREATE PROCEDURE Remove_Approved_Leaves
    @Employee_id INT
AS
BEGIN

    DELETE A
    FROM Attendance A
     INNER JOIN Leave L 
        ON A.date >= L.start_date AND A.date <= L.end_date
    WHERE A.emp_ID = @Employee_id
      AND L.final_approval_status = 'approved'
      AND L.request_ID IN (
            SELECT request_ID FROM Annual_Leave WHERE emp_ID = @Employee_id
            UNION
            SELECT request_ID FROM Accidental_Leave WHERE emp_ID = @Employee_id
            UNION
            SELECT request_ID FROM Medical_Leave WHERE emp_ID = @Employee_id
            UNION
            SELECT request_ID FROM Unpaid_Leave WHERE emp_ID = @Employee_id
            UNION
            SELECT request_ID FROM Compensation_Leave WHERE emp_ID = @Employee_id
      );
END;
go

--2.3(k)
GO
CREATE PROC Replace_employee
    @Emp1_ID   INT,     
    @Emp2_ID   INT,      
    @from_date DATE,
    @to_date   DATE
AS
    DECLARE
        @isBusy    INT,
        @exists1   INT,
        @exists2   INT;

    SET @isBusy = 0;

    -- Validate both employees exist -------------------------
    SELECT @exists1 = COUNT(*) FROM Employee WHERE employee_ID = @Emp1_ID;
    SELECT @exists2 = COUNT(*) FROM Employee WHERE employee_ID = @Emp2_ID;

    IF @exists1 = 0 OR @exists2 = 0
        RETURN;  -- one (or both) employees don’t exist
    -- Basic validation --------------------------------------
    IF @Emp1_ID = @Emp2_ID
        RETURN;  -- cannot replace yourself

    IF @from_date IS NULL OR @to_date IS NULL OR @from_date > @to_date
        RETURN;  -- invalid date range

    --  Check that Emp2 is NOT on approved leave in interval
    SELECT @isBusy = @isBusy + COUNT(*)
    FROM [Leave] L
    LEFT JOIN Annual_Leave       AL ON AL.request_ID = L.request_ID
    LEFT JOIN Accidental_Leave   AC ON AC.request_ID = L.request_ID
    LEFT JOIN Medical_Leave      ML ON ML.request_ID = L.request_ID
    LEFT JOIN Unpaid_Leave       UL ON UL.request_ID = L.request_ID
    LEFT JOIN Compensation_Leave CL ON CL.request_ID = L.request_ID
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
    -- 3) Check that Emp2 is NOT already replacing someone else in an overlapping period
  
    SELECT @isBusy = @isBusy + COUNT(*)
    FROM Employee_Replace_Employee ERE
    WHERE ERE.Emp2_ID   = @Emp2_ID
      AND ERE.from_date <= @to_date
      AND ERE.to_date   >= @from_date;

    IF @isBusy > 0
        RETURN;   -- Emp2 is busy (on leave or already replacing)
    INSERT INTO Employee_Replace_Employee (Emp1_ID, Emp2_ID, from_date, to_date)
    VALUES (@Emp1_ID, @Emp2_ID, @from_date, @to_date);
GO


--2.4(a) yasmin DONE
CREATE FUNCTION HRLoginValidation
(@employee_ID int , @password varchar(50))
returns bit
as
begin
DECLARE @success bit
if EXISTS (SELECT * 
FROM Employee E INNER JOIN Employee_Role R 
ON E.employee_ID = R.emp_ID
WHERE E.employee_ID= @employee_ID AND
E.password= @password AND
e.dept_name like '%HR%'
AND E.employment_status <> 'resigned') 

set @success=1
else
set @success=0
return @success
end
go 


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
    WHERE Leave_ID = @request_ID AND Emp1_ID <> @HR_ID
      AND status   = 'rejected';

    IF @prevRejected > 0
    BEGIN
        SET @status = 'rejected';
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
             ---check that emp2 isnt already replacing another emp during that period 
            SELECT @isBusy = @isBusy + COUNT(*)
            FROM Employee_Replace_Employee
            WHERE Emp2_ID   = @replacement_emp
              AND Emp1_ID  <> @emp_ID
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
               AND DATEDIFF(DAY, @date_of_request, CAST(GETDATE() as DATE)) <= 2
                SET @status = 'approved';
            ELSE
                SET @status = 'rejected';
        END
        ELSE
        BEGIN
            SET @status = 'rejected';
        END
    END
    SELECT @pendingHigher = COUNT(*)
        FROM Employee_Approve_Leave
        WHERE Leave_ID = @request_ID
          AND Emp1_ID <> @HR_ID
          AND status = 'pending';

        IF @pendingHigher > 0
            RETURN;
        -- If HR already has an entry, update it; otherwise insert a new one
    IF EXISTS (
        SELECT 1 
        FROM Employee_Approve_Leave
        WHERE Emp1_ID = @HR_ID
          AND Leave_ID = @request_ID
    )
    BEGIN
        UPDATE Employee_Approve_Leave
        SET status = @status
        WHERE Emp1_ID = @HR_ID
          AND Leave_ID = @request_ID;
    END
    ELSE
    BEGIN
        INSERT INTO Employee_Approve_Leave (Emp1_ID, Leave_ID, status)
        VALUES (@HR_ID, @request_ID, @status);
    END

    UPDATE [Leave]
    SET final_approval_status = @status
    WHERE request_ID = @request_ID;
    IF @status = 'approved'
    BEGIN
        IF @leave_type = 'annual'
        BEGIN
            UPDATE Employee
            SET annual_balance = annual_balance - @num_days
            WHERE employee_ID = @emp_ID;

            INSERT INTO Employee_Replace_Employee (Emp1_ID, Emp2_ID, from_date, to_date)
            VALUES (@emp_ID, @replacement_emp, @start_date, @end_date);
        END
        ELSE IF @leave_type = 'accidental'
        BEGIN
            UPDATE Employee
            SET accidental_balance = accidental_balance - 1
            WHERE employee_ID = @emp_ID;
        END
    END   
GO


--2.4(c)-
GO
CREATE PROC HR_approval_unpaid 
    @request_ID INT, 
    @HR_ID      INT 
AS
    DECLARE 
        @emp_ID                 INT,
        @num_days               INT,
        @annual_balance         INT,
        @status                 VARCHAR(50),
        @prevRejected           INT,
        @pendinGOthers          INT,
        @type_of_contract       VARCHAR(50),
        @start_date             DATE,
        @approvedUnpaidThisYear INT;

    SET @status        = NULL;
    SET @prevRejected  = 0;
    SET @pendinGOthers = 0;
    SET @approvedUnpaidThisYear=0;

    SELECT @emp_ID = emp_ID
    FROM Unpaid_Leave
    WHERE request_ID = @request_ID;

    IF @emp_ID IS NULL
    BEGIN
        SET @status = 'rejected';

     -- If HR already has an entry, update it; otherwise insert a new one
    IF EXISTS (
        SELECT 1 
        FROM Employee_Approve_Leave
        WHERE Emp1_ID = @HR_ID
          AND Leave_ID = @request_ID
    )
    BEGIN
        UPDATE Employee_Approve_Leave
        SET status = @status
        WHERE Emp1_ID = @HR_ID
          AND Leave_ID = @request_ID;
    END
    ELSE
    BEGIN
        INSERT INTO Employee_Approve_Leave (Emp1_ID, Leave_ID, status)
        VALUES (@HR_ID, @request_ID, @status);
    END

    UPDATE [Leave]
    SET final_approval_status = @status
    WHERE request_ID = @request_ID;


    RETURN;
    END

    SELECT 
        @num_days   = num_days,
        @start_date = start_date
    FROM Leave
    WHERE request_ID = @request_ID;

    SELECT 
        @annual_balance   = annual_balance,
        @type_of_contract = type_of_contract
    FROM Employee
    WHERE employee_ID = @emp_ID;

    -- If previously rejected, keep it rejected
    SELECT @prevRejected = COUNT(*)
    FROM Employee_Approve_Leave
    WHERE Leave_ID = @request_ID AND Emp1_ID <> @HR_ID
      AND status   = 'rejected';

    IF @prevRejected > 0
    BEGIN
        SET @status = 'rejected';
    END

    

    -- Check if employee already has an approved unpaid leave this year
    IF @status IS NULL
    BEGIN
        SELECT @approvedUnpaidThisYear = COUNT(*)
        FROM Unpaid_Leave UL
        JOIN [Leave] L ON UL.request_ID = L.request_ID
        WHERE UL.emp_ID = @emp_ID AND L.request_ID <> @request_ID
          AND L.final_approval_status = 'approved'
          AND YEAR(L.start_date) = YEAR(@start_date);

        IF @approvedUnpaidThisYear >= 1
        BEGIN
            SET @status = 'rejected';
        END
    END

    --Check contract type + annual balance + max 30 days
    IF @status IS NULL
    BEGIN
        IF @type_of_contract = 'part_time'
        BEGIN
            SET @status = 'rejected';
        END
        ELSE
        BEGIN
            IF @annual_balance = 0 AND @num_days <= 30
            begin
                SET @status = 'approved';
                SELECT @pendinGOthers = COUNT(*)
                FROM Employee_Approve_Leave
                WHERE Leave_ID = @request_ID
                  AND Emp1_ID <> @HR_ID
                  AND status = 'pending';

                IF @pendinGOthers > 0
                    RETURN;
            end
            ELSE
                SET @status = 'rejected';
        END
    END
    
        -- If HR already has an entry, update it; otherwise insert a new one
    IF EXISTS (
        SELECT 1 
        FROM Employee_Approve_Leave
        WHERE Emp1_ID = @HR_ID
          AND Leave_ID = @request_ID
    )
    BEGIN
        UPDATE Employee_Approve_Leave
        SET status = @status
        WHERE Emp1_ID = @HR_ID
          AND Leave_ID = @request_ID;
    END
    ELSE
    BEGIN
        INSERT INTO Employee_Approve_Leave (Emp1_ID, Leave_ID, status)
        VALUES (@HR_ID, @request_ID, @status);
    END

    UPDATE [Leave]
    SET final_approval_status = @status
    WHERE request_ID = @request_ID;

GO


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

         -- If HR already has an entry, update it; otherwise insert a new one
    IF EXISTS (
        SELECT 1 
        FROM Employee_Approve_Leave
        WHERE Emp1_ID = @HR_ID
          AND Leave_ID = @request_ID
    )
    BEGIN
        UPDATE Employee_Approve_Leave
        SET status = @status
        WHERE Emp1_ID = @HR_ID
          AND Leave_ID = @request_ID;
    END
    ELSE
    BEGIN
        INSERT INTO Employee_Approve_Leave (Emp1_ID, Leave_ID, status)
        VALUES (@HR_ID, @request_ID, @status);
    END

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
    WHERE Leave_ID = @request_ID AND Emp1_ID <> @HR_ID
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

    --  Check same-month condition: request vs original workday--
    IF @status IS NULL
    BEGIN
        IF NOT (YEAR(@date_of_request) = YEAR(@date_of_original_workday)
            AND MONTH(@date_of_request) = MONTH(@date_of_original_workday))
        BEGIN
            SET @status = 'rejected';
        END
    END
    -- Compensation day must also be in the same month--------
    IF @status IS NULL
    BEGIN
        IF NOT (YEAR(@start_date) = YEAR(@date_of_original_workday)
            AND MONTH(@start_date) = MONTH(@date_of_original_workday))
        BEGIN
            SET @status = 'rejected';
        END
    END
    -- Check replacement employee availability---
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
             ---check that emp2 isnt already replacing another emp during that period 
            SELECT @isBusy = @isBusy + COUNT(*)
            FROM Employee_Replace_Employee
            WHERE Emp2_ID   = @replacement_emp
              AND Emp1_ID  <> @emp_ID
              AND from_date <= @end_date
              AND to_date   >= @start_date;
        END
    END

    IF @status IS NULL
    BEGIN
        IF @validReason = 1
            SET @status = 'approved';
        ELSE
            SET @status = 'rejected';
    END

        -- If HR already has an entry, update it; otherwise insert a new one
    IF EXISTS (
        SELECT 1 
        FROM Employee_Approve_Leave
        WHERE Emp1_ID = @HR_ID
          AND Leave_ID = @request_ID
    )
    BEGIN
        UPDATE Employee_Approve_Leave
        SET status = @status
        WHERE Emp1_ID = @HR_ID
          AND Leave_ID = @request_ID;
    END
    ELSE
    BEGIN
        INSERT INTO Employee_Approve_Leave (Emp1_ID, Leave_ID, status)
        VALUES (@HR_ID, @request_ID, @status);
    END

    UPDATE [Leave]
    SET final_approval_status = @status
    WHERE request_ID = @request_ID;
    --populate Employee_Replace_Employee since leave approved
    IF @status = 'approved'
    BEGIN
        INSERT INTO Employee_Replace_Employee (Emp1_ID, Emp2_ID, from_date, to_date)
        VALUES (@emp_ID, @replacement_emp, @start_date, @end_date);
           
    END
GO

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
    ORDER BY R.rank ;       

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
    -- Get FIRST day with missing hours (month)----------
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

    INSERT INTO Deduction (emp_ID, date, amount, type, unpaid_ID, attendance_ID)
    VALUES (@employee_ID, @first_missing_date, @amount, 'missing_hours', NULL, @first_attendance_id);
 GO

 --2.4)f) yasmin Add deduction due to missing days DONE
  CREATE PROC Deduction_days
  @employee_id INT
    as
    BEGIN
   
   declare @ded_per_day as decimal (10,2) = dbo.Deduction_per_day (@employee_ID);

   Insert INTO Deduction (emp_ID, date, amount, type,  unpaid_ID, attendance_ID) 
    SELECT A.emp_ID, A.date, @ded_per_day , 'missing_days', NULL, A.attendance_ID
    FROM Attendance A 
    WHERE A.emp_ID = @employee_ID
    AND A.check_in_time IS NULL
    AND A.check_out_time IS NULL
    AND NOT EXISTS (
            SELECT 1
            FROM Deduction D
            WHERE D.attendance_ID = A.attendance_ID
            AND D.type = 'missing_days'
        );

    END
 go

-- 2.4)g) yasmin Add deduction due to unpaid leave.

GO
CREATE PROC Deduction_unpaid 
    @employee_ID INT
AS
BEGIN
   
  declare @ded_per_day as decimal (10,2) = dbo.Deduction_per_day (@employee_ID);
  DECLARE @MonthStart DATE = DATEFROMPARTS(YEAR(GETDATE()),MONTH(GETDATE()), 1);
  DECLARE @MonthEnd DATE = EOMONTH(GETDATE());
  DECLARE @NextMonthStart DATE = DATEADD(month, 1, @MonthStart);
  DECLARE @NextMonthEnd DATE = EOMONTH(@NextMonthStart);
  DECLARE @CurrentDate DATE = CAST(GETDATE() AS DATE);

   INSERT INTO Deduction (emp_ID, date, amount, type,  unpaid_ID, attendance_ID)
   SELECT U.emp_ID,  @CurrentDate,
  ( @ded_per_day *(dbo.CalculateDays(L.start_date ,l.end_date ,@MonthStart)) )
    , 'unpaid', 
    L.request_ID, null
   FROM  Leave L inner join Unpaid_Leave U on L.request_ID=U.request_ID
   WHERE L.final_approval_status = 'approved' 
   AND U.Emp_ID = @employee_ID
   AND L.end_date >= @MonthStart
   AND L.start_date <= @MonthEnd
   AND dbo.CalculateDays(L.start_date, L.end_date, @MonthStart) > 0
   and not exists(
    select 1
    from  Deduction D
            WHERE D.unpaid_ID   =  l.request_ID
          AND D.emp_ID = U.Emp_ID
            AND MONTH(D.date) = MONTH(@MonthStart) 
            AND YEAR(D.date) = YEAR(@MonthStart)  )

   INSERT INTO Deduction (emp_ID, date, amount, type,  unpaid_ID, attendance_ID)
   SELECT U.emp_ID,  @NextMonthStart,
  ( @ded_per_day *(dbo.CalculateDays(L.start_date ,l.end_date ,@NextMonthStart)) )
    , 'unpaid', 
    L.request_ID, null
   FROM  Leave L inner join Unpaid_Leave U on L.request_ID=U.request_ID
   WHERE L.final_approval_status = 'approved' 
   AND U.Emp_ID = @employee_ID
  AND L.end_date >= @NextMonthStart 
   AND L.start_date <= @NextMonthEnd
   AND dbo.CalculateDays(L.start_date, L.end_date, @MonthStart) > 0
   and not exists(
    select 1
    from  Deduction D
            WHERE D.unpaid_ID   =  l.request_ID
          AND D.emp_ID = U.Emp_ID
          AND MONTH(D.date) = MONTH(@NextMonthStart) 
          AND YEAR(D.date) = YEAR(@NextMonthStart)
);

END 
GO

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


--2.4)I) yasmin DONE
CREATE PROC Add_Payroll
@employee_ID int,
@from date,
@to date
as
begin
    DECLARE @Bonus decimal (10,2);
    DECLARE @totalDeductions decimal (10,2);
    DECLARE @final_salary_amount decimal (10,1);
    DECLARE @Payroll_Comment varchar (150);
   
    set @Bonus = dbo.Bonus_amount (@employee_ID);

    set @totalDeductions = ISNULL((
        SELECT SUM (amount) 
        FROM Deduction
        WHERE emp_ID = @employee_ID AND date BETWEEN @from AND @to and status = 'pending' 
    ), 0);

    set @final_salary_amount = dbo.Calc_Salary (@employee_ID ) + @Bonus - @totalDeductions;

 
IF @totalDeductions > 0 AND @Bonus > 0
    SET @Payroll_Comment = 'Contains bonus and deductions.';
ELSE IF @totalDeductions > 0
    SET @Payroll_Comment = 'Contains deductions.';
ELSE IF @Bonus > 0
    SET @Payroll_Comment = 'Contains bonus ';
ELSE
    SET @Payroll_Comment = 'Standard monthly payroll';


INSERT INTO
Payroll ( payment_date, final_salary_amount, from_date,
to_date, bonus_amount, deductions_amount, emp_ID, comments ) 

VALUES ( GETDATE(), @final_salary_amount, @from,
@to, @Bonus, @totalDeductions, @employee_ID, @Payroll_Comment ) 
    
    UPDATE Deduction
    SET status = 'finalized'
    WHERE emp_ID = @employee_ID AND date BETWEEN @from AND @to and status = 'pending';
end
go

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
    DECLARE @success BIT = 0; 

    SELECT @success = 1
    FROM Employee
    WHERE employee_ID = @employee_ID
      AND password = @password
      and employment_status  <> 'resigned';

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
GO
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
 
--2.5(e)
GO
CREATE FUNCTION Deductions_Attendance
 (@employee_ID INT ,@month INT )
 RETURNS TABLE
 AS
 RETURN 
(
 SELECT D.emp_ID,D.date,D.amount,D.type,D.status,D.unpaid_ID,D.attendance_ID
FROM Deduction as D
 WHERE D.emp_ID=@employee_ID AND month (D.date)=@month AND 
 D.type in ('missing_hours', 'missing_days')
 )
GO


--2.5 f
GO
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



go

--2.5)G) yasmin Apply for an annual leave   
CREATE PROC Submit_annual
@employee_ID int,
@replacement_emp int,
@start_date date,
@end_date date
as
BEGIN

   if(not exists (select * from Employee E where E.employee_ID = @replacement_emp ) OR
   not exists (select * from Employee E where E.employee_ID = @employee_ID )) -- the employees do not exist
   begin
   return;
   end

    declare @contract_type varchar(50) = dbo.type_contract (@employee_ID );
    declare @role varchar(50) = dbo.getRole(@employee_ID);
    declare @dep varchar(50) = dbo.getDep(@employee_ID );
    declare @HR int = dbo.HR_rep(@employee_ID ); 
    DECLARE @id INT;
    DECLARE @ApproverID INT;
    if (@contract_type = 'part_time') 
    begin
    return;
    end

    begin
    --1) insert into leave  DONE
     INSERT INTO Leave (date_of_request, start_date, end_date)
     VALUES(CURRENT_TIMESTAMP, @start_date, @end_date);

     SET @id = SCOPE_IDENTITY();

    --2) insert into annual leave DONE
    INSERT INTO Annual_Leave (request_ID, emp_ID,replacement_emp)
    VALUES (@id, @employee_ID,@replacement_emp);



    if (@role in ('Vice Dean','Dean'))   
    begin
    -- insert into emp app req for 'higher rank'
    SET @ApproverID = dbo.get_President();
    IF @ApproverID IS NOT NULL 
          INSERT INTO Employee_Approve_Leave VALUES (@ApproverID, @id, 'pending')
    IF @HR IS NOT NULL 
       INSERT INTO Employee_Approve_Leave(Emp1_ID, Leave_ID, status) VALUES (@HR, @id, 'pending');
    end
        else if (@role LIKE 'HR%Representative%')  
        begin
        --insert into emp app req for 'higher rank in hr' 
          set @ApproverID = dbo.get_HR_Manager();
          if @ApproverID IS NOT NULL
          insert into Employee_Approve_Leave(Emp1_ID, Leave_ID, status) VALUES (@ApproverID, @id, 'pending');
        end
        else
        begin
          -- insert into emp app req for normal employees
         set @ApproverID = dbo.get_Dean(@dep); 
         if @ApproverID IS NOT NULL
         insert into Employee_Approve_Leave(Emp1_ID, Leave_ID, status) VALUES (@ApproverID, @id, 'pending');
           
        IF @HR IS NOT NULL
            INSERT INTO Employee_Approve_Leave(Emp1_ID, Leave_ID, status) VALUES (@HR, @id, 'pending');  
        end

      end
END
GO



--2.5 (h)
GO
CREATE FUNCTION Status_leaves
 (@employee_ID INT)
 RETURNS TABLE
 AS
 RETURN 
(
 SELECT Leave.request_ID, Leave.date_of_request, Leave.final_approval_status

FROM Leave inner join Annual_Leave on (Leave.request_ID=Annual_Leave.request_ID)

where month(date_of_request) = month (CURRENT_TIMESTAMP)  
AND @employee_ID =Annual_Leave.emp_ID 

UNION 

SELECT Leave.request_ID, Leave.date_of_request, Leave.final_approval_status

FROM leave inner join Accidental_Leave on (Leave.request_ID=Accidental_Leave.request_ID)

where month(date_of_request)=month (CURRENT_TIMESTAMP)  
AND @employee_ID =Accidental_Leave.emp_ID 

)
go



---2.5)I) yasmin As a Dean/Vice-dean/President I can approve/reject annual leaves <3

CREATE PROC Upperboard_approve_annual
@request_ID int,
@Upperboard_ID int,
@replacement_ID int
as
BEGIN 
    declare @employee_ID INT;
    declare @from DATE;
    declare @to DATE;
    
    declare @dep1 VARCHAR(50);
    declare @dep2 VARCHAR(50);
    declare @contract_type VARCHAR(50);
    declare @role VARCHAR(50) = dbo.getRole(@Upperboard_ID); 
   if(not exists (select * from leave l where l.request_ID = @request_ID ) OR
   not exists (select * from Employee E where E.employee_ID = @Upperboard_ID ) OR
   not exists (select * from Employee E where E.employee_ID = @replacement_ID )
   OR exists (SELECT 1 FROM Leave WHERE request_ID = @request_ID AND final_approval_status = 'rejected') )-- the leave/employees do not exist

   begin
   return;
   end
 
    if ( @role <> 'President' AND @role NOT LIKE 'Vice%Dean' AND @role <> 'Dean' ) 
    begin 
    return 
    end;

    select @employee_ID = a.emp_ID , @from = l.start_date,@to = l.end_date --gets the start and end dates
    from leave l inner join Annual_Leave a on l.request_ID = a.request_ID
    where l.request_ID = @request_ID and l.final_approval_status = 'pending';

    IF @employee_ID IS NULL RETURN;

    declare @is_on_leave int = dbo.Is_On_Leave(@replacement_ID,@from,@to);

   set @dep1 = dbo.getDep(@employee_ID );
   set @dep2 = dbo.getDep(@replacement_ID );
   set @contract_type  = dbo.type_contract (@employee_ID ); --part time check added <3

  

    if (@contract_type = 'part_time'or @dep1 <> @dep2 or @is_on_leave = 1) --if not same dep/ part time reject/on leave
    begin
    --update final status to rejected
    update leave 
    set final_approval_status = 'rejected' where request_ID = @request_ID and final_approval_status = 'pending' ;
    --update rejected in employee_approve_leave
    UPDATE Employee_Approve_Leave 
    SET status = 'rejected'
    WHERE Leave_ID = @request_ID AND Emp1_ID = @Upperboard_ID --and status = 'pending';
                            
    return;
    end  
   
    UPDATE Employee_Approve_Leave 
    SET status = 'approved'
    WHERE Leave_ID = @request_ID AND Emp1_ID = @Upperboard_ID -- and status = 'pending';
    

END



--2.5)J) yasmin Apply for an accidental leave.  
GO
CREATE PROC Submit_accidental
    @employee_ID INT, 
    @start_date DATE,
    @end_date DATE 
AS             

BEGIN
    ---WHY IS IT RETURNNG A  MEDICAL DR?
    DECLARE @employee_dep VARCHAR(50) ;
    DECLARE @get_req_id INT;
    declare @contract_type varchar(50) = dbo.type_contract (@employee_ID )
    declare @dep varchar(50) = dbo.getDep(@employee_ID );
    declare @role varchar(50) = dbo.getRole(@employee_ID);  
    DECLARE @duration_days INT = DATEDIFF(DAY, @start_date, @end_date) + 1;
    DECLARE @ApproverID INT;
    if(not exists (select * from Employee E where E.employee_ID =  @employee_ID )) 
    begin
    print 'This employee does not exist in our current database';
    return;
    end

    if (@contract_type = 'part_time') -- Reject part time employees
    begin
    print 'A part time employee may not request a leave';
    return;
    end

    --insert into leave
    INSERT INTO Leave (date_of_request, start_date, end_date)
    VALUES(CURRENT_TIMESTAMP, @start_date, @end_date);
    
    SET @get_req_id = SCOPE_IDENTITY();   

    --insert into accidental leave
    INSERT INTO Accidental_Leave (request_ID, emp_ID)
    VALUES (@get_req_id, @employee_ID)

    if(@role like 'HR%Representative%') 
    begin
     DECLARE @HRmanager INT = dbo.get_HR_Manager(); 
     SET @ApproverID = @HRmanager;
    end
    else if (@role not like 'HR%Representative%') 
     begin
    SET @ApproverID = dbo.HR_rep(@employee_ID);
     end

     INSERT INTO Employee_Approve_Leave (Emp1_ID , Leave_ID , status)
     VALUES (@ApproverID , @get_req_id, 'pending');
     
END
GO


 --faridaaaaaa
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
DECLARE @HRrep_id INT = dbo.HR_rep(@employee_ID);
DECLARE @employee_dep VARCHAR(50)= dbo.getDep(@employee_ID);
DECLARE @medical_dr_id INT;
DECLARE @check bit;

INSERT INTO Leave (date_of_request, start_date, end_date)  --insert into leave 
VALUES (CURRENT_TIMESTAMP, @start_date, @end_date);

SET @get_req_id= SCOPE_IDENTITY();       --get req id

INSERT INTO Medical_Leave (request_ID, insurance_status, disability_details, type, Emp_ID)    --insert into medical 
VALUES (@get_req_id, @insurance_status, @disability_details, @type, @employee_ID);

INSERT INTO Document (type, description, file_name , creation_date, expiry_date, status, emp_ID,medical_ID, unpaid_ID)   --insert into doc
VALUES ('Medical', @document_description, @file_name, CURRENT_TIMESTAMP, NULL,'valid',@employee_ID, @get_req_id, NULL);

SELECT TOP 1 @medical_dr_id = E.employee_ID
FROM Employee E INNER JOIN Employee_Role R ON (E.employee_ID = R.emp_ID)
WHERE E.employment_status = 'active'AND R.role_name= 'Medical Doctor'; 

    IF @HRrep_id IS NULL
    BEGIN
        DECLARE @HRrep_valid_id int = dbo.get_hr_rep_for_emp(@employee_id)  -- get the hr id that is on leave 
        SELECT @HRrep_id = RE.Emp2_ID 
        FROM Employee_Replace_Employee RE 
        WHERE @HRrep_valid_id = RE.Emp1_ID AND RE.from_date <= CURRENT_TIMESTAMP AND RE.to_date >= CURRENT_TIMESTAMP    --- get the employee id who replaces him 
END 


if EXISTS (
SELECT *
FROM Employee E INNER JOIN Employee_Role R ON (E.employee_ID = R.emp_ID)
WHERE R.role_name LIKE 'HR_representative_%' AND E.employee_ID = @employee_ID ) 
    SET @check = 1
ELSE 
    SET @check =0



 if @check =0

    INSERT INTO Employee_Approve_Leave (Emp1_ID , Leave_ID , status)
    VALUES (@HRrep_id , @get_req_id, 'pending');
else 
    BEGIN 
    DECLARE @hr_manager_id int;
    SELECT TOP 1 @hr_manager_id = R.emp_ID
    FROM Employee_Role R 
    WHERE R.role_name ='HR Manager'

     INSERT INTO Employee_Approve_Leave (Emp1_ID , Leave_ID , status)
    VALUES (@hr_manager_id , @get_req_id, 'pending');
END 

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

DECLARE @employee_dep VARCHAR(50)= dbo.getDep(@employee_ID);
DECLARE @HRrep_id INT = dbo.HR_rep(@employee_ID);
DECLARE @get_req_id int;
DECLARE @president_id int;
DECLARE @HR_manager_id int;
DECLARE @emp_rank int ;
DECLARE @check bit;

INSERT INTO Leave (date_of_request, start_date, end_date)
VALUES (CURRENT_TIMESTAMP, @start_date, @end_date);

SET @get_req_id= SCOPE_IDENTITY();

INSERT INTO Unpaid_Leave (request_ID, Emp_ID) 
VALUES (@get_req_id, @employee_ID);

INSERT INTO Document (type, description, file_name, creation_date, expiry_date, status, emp_ID, medical_id,unpaid_id)
VALUES ('Memo', @document_description, @file_name, CURRENT_TIMESTAMP, NULL, 'valid', @employee_ID, null, @get_req_id);

IF exists (
SELECT *
FROM Employee_Role R
WHERE R.emp_ID = @employee_ID AND (R.role_name = 'Dean' or R.role_name = 'Vice Dean'))
	SET @check =1
ELSE 
	SET @check=0


SELECT @president_id = R.emp_ID
FROM Employee_Role R
WHERE R.role_name = 'President';


IF @check=1 
BEGIN 

	IF @HRrep_id IS NULL
BEGIN
        DECLARE @HRrep_valid_id1 int = dbo.get_hr_rep_for_emp(@employee_id)  -- get the hr id that is on leave 
        SELECT @HRrep_id = RE.Emp2_ID 
        FROM Employee_Replace_Employee RE 
        WHERE @HRrep_valid_id1 = RE.Emp1_ID AND RE.from_date <= CURRENT_TIMESTAMP AND RE.to_date >= CURRENT_TIMESTAMP   --- get the employee id who replaces him 
END


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

		IF @HRrep_id IS NULL
BEGIN
        DECLARE @HRrep_valid_id int = dbo.get_hr_rep_for_emp(@employee_id)  -- get the hr id that is on leave 
        SELECT @HRrep_id = RE.Emp2_ID 
        FROM Employee_Replace_Employee RE 
        WHERE @HRrep_valid_id = RE.Emp1_ID AND RE.from_date <= CURRENT_TIMESTAMP AND RE.to_date >= CURRENT_TIMESTAMP   --- get the employee id who replaces him 
END

	INSERT INTO Employee_Approve_Leave (Emp1_ID , Leave_ID , status)
	VALUES (@HRrep_id , @get_req_id, 'pending');   --HR representative 

    INSERT INTO Employee_Approve_Leave VALUES (@president_id, @get_req_id, 'pending'); --upperboard president
	
	SELECT @emp_rank = R.rank 
	FROM Employee E inner join Employee_Role ER ON (E.employee_ID = ER.emp_ID)INNER JOIN Role R ON (ER.role_name = R.role_name)
	WHERE  E.employee_id = @employee_ID ;

	--SELECT TOP 1 @higher_rank_emp_id = E.employee_ID
	--fROM  Employee E INNER JOIN Employee_Role ER ON (E.employee_ID = ER.emp_ID)INNER JOIN Role R ON (ER.role_name = R.role_name)
	--WHERE E.employment_status = 'active' AND R.rank < @emp_rank AND E.employee_ID <> @president_id AND E.employee_ID <> @HRrep_id
    --AND E.employee_ID <> @employee_ID;

    DECLARE @higher_rank_emp_id INT = dbo.get_Higher_Dean(@emp_rank,@employee_dep)

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

--rejecting 
UPDATE Employee_Approve_Leave
    SET status = 'rejected'
    WHERE Leave_ID = @request_ID
      AND Emp1_ID = @Upperboard_ID
      AND status = 'pending'  
      AND NOT EXISTS (
            SELECT *
            FROM Document D
            WHERE D.unpaid_ID = @request_ID AND D.type = 'Memo' AND D.status = 'valid'
      );

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
DECLARE @HRrep_id int= dbo.HR_rep(@employee_ID);
DECLARE @employee_departement VARCHAR (50)  = dbo.getDep(@employee_ID);
DECLARE @get_req_id int;
DECLARE @check bit;

INSERT INTO Leave (date_of_request, start_date, end_date)
VALUES(CURRENT_TIMESTAMP, @compensation_date, @compensation_date);

SET @get_req_id= SCOPE_IDENTITY();

INSERT INTO Compensation_Leave (request_ID, reason, date_of_original_workday, emp_ID, replacement_emp)
VALUES (@get_req_id, @reason, @date_of_original_workday, @employee_ID, @replacement_emp);

if EXISTS (
SELECT *
FROM Employee E INNER JOIN Employee_Role R ON (E.employee_ID = R.emp_ID)
WHERE R.role_name LIKE 'HR_representative_%' AND E.employee_ID = @employee_ID ) 
    SET @check = 1
ELSE 
    SET @check =0


IF @HRrep_id IS NULL
BEGIN
        DECLARE @HRrep_valid_id int = dbo.get_hr_rep_for_emp(@employee_id)  -- get the hr id that is on leave 
        SELECT @HRrep_id = RE.Emp2_ID 
        FROM Employee_Replace_Employee RE 
        WHERE @HRrep_valid_id = RE.Emp1_ID AND RE.from_date <= CURRENT_TIMESTAMP AND RE.to_date >= CURRENT_TIMESTAMP    --- get the employee id who replaces him 
END

if @check =0

    INSERT INTO Employee_Approve_Leave (Emp1_ID , Leave_ID , status)
    VALUES (@HRrep_id , @get_req_id, 'pending');
else 
    BEGIN 
    DECLARE @hr_manager_id int;
    SELECT TOP 1 @hr_manager_id = R.emp_ID
    FROM Employee_Role R 
    WHERE R.role_name ='HR Manager'

     INSERT INTO Employee_Approve_Leave (Emp1_ID , Leave_ID , status)
    VALUES (@hr_manager_id , @get_req_id, 'pending');
END 



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








 -------------------------TESTING---------------------------------
  PRINT '--- 2.1  BASIC STRUCTURE TESTS ---';
 exec createAllTables
 exec dropAllTables
 exec dropAllProceduresFunctionsViews
 exec createAllTables
 exec Create_Holiday
 exec clearAllTables

 
                   ---------------------------------
 PRINT '--- 2.2 Displaying All Required Views (2.2) ---';
GO

-- 2.2(a) Fetch details for all employees
SELECT * FROM allEmployeeProfiles;

-- 2.2(b) Fetch the number of employees per department
SELECT * FROM NoEmployeeDept;

-- 2.2(c) Fetch details for the performance of all employees in all Winter semesters.
SELECT * FROM allPerformance;

-- 2.2(d) Fetch details of all rejected medical leaves.
SELECT * FROM allRejectedMedicals;

-- 2.2(e) Fetch the attendance records for all employees for yesterday.
SELECT * FROM allEmployeeAttendance;
GO

                   ---------------------------------
PRINT '--- 2.3 Running Detailed Utility Test Cases ---';
GO

-- --- TEST CASES FOR 2.3.c: Update_Employment_Status ---
-- T1: Execute on Emp 11 (Leave ended 11/01, should be active)
EXEC Update_Employment_Status 11;
SELECT 'C1: Emp 11 Status (Leave Ended)' AS Test, employment_status FROM Employee WHERE employee_ID = 11;
-- Expected: active

-- T2: Execute on Emp 12 (Was onleave, leave ended 10/30, should switch to active)
EXEC Update_Employment_Status 12;
SELECT 'C2: Emp 12 Status (Switch onleave->active)' AS Test, employment_status FROM Employee WHERE employee_ID = 12;
-- Expected: active

-- --- TEST CASES FOR 2.3.f & g: Attendance ---
EXEC Intitiate_Attendance;
SELECT 'A1: Attendance Initialized Count' AS Test, COUNT(*) AS Init_Records FROM Attendance WHERE date = CAST(GETDATE() AS DATE);
-- Expected count: 18

EXEC Update_Attendance @Employee_id = 1, @check_in = '09:00:00', @check_out = '17:00:00'; -- 8 hours worked
SELECT 'A2: Attendance Update Duration' AS Test, status, total_duration FROM Attendance WHERE emp_ID = 1 AND date = CAST(GETDATE() AS DATE);
-- Expected total_duration: 480

-- --- TEST CASES FOR 2.3.j: Remove Approved Leaves ---
-- T6: Delete approved leave records for Emp 8 (ReqID 1 was 10-26 to 11-01)
EXEC Remove_Approved_Leaves 8;
SELECT 'A6: Approved Leaves Deletion Check' AS Test, COUNT(*) AS Records_Remaining 
FROM Attendance 
WHERE emp_ID = 8 AND date BETWEEN '2025-10-26' AND '2025-11-01';
-- Expected count: 0

-- --- TEST CASES FOR 2.3.a, b: Cleanup ---
-- T7: Update Document Status (Should set old Docs (10, 11) to 'expired')
EXEC Update_Status_Doc;
SELECT 'L1: Document Expiry Check' AS Test, document_ID, status 
FROM Document 
WHERE document_ID IN (10, 11);
-- Expected status: expired

-- T8: Remove Deductions for Resigned Emp (Emp 17 is 'resigned')
EXEC Remove_Deductions;
SELECT 'L2: Resigned Deductions Check' AS Test, COUNT(*) AS Emp17_Deductions 
FROM Deduction 
WHERE emp_ID = 17;
-- Expected count: 0
GO
PRINT '--- Running Detailed Deduction and Approval Tests (2.4) ---';
GO
-- Assuming current date is 2025-11-23 (Sunday)



                   ---------------------------------

PRINT '--- 2.4 Running Detailed Deduction and Approval Tests  ---';
GO

-- --- DEDUCTION TESTS ---
-- T1: Deduction Hours (Emp 1, Att ID 7 is 30 mins short)
EXEC Deduction_hours 1;
SELECT 'D1: Missing Hours Inserted' AS Test, amount, status FROM Deduction WHERE emp_ID = 1 AND attendance_ID = 7;

-- T3: Deduction Days (Emp 1, Absent 10-27)
EXEC Deduction_days 1;
SELECT 'D3: Missing Days Inserted' AS Test, amount, status FROM Deduction WHERE emp_ID = 1 AND attendance_ID = 5;

-- T5: Add Payroll (Finalize all pending deductions for Emp 1 in October)
EXEC Add_Payroll 1, '2025-10-01', '2025-10-31';
SELECT 'D5: Payroll Finalization Check' AS Test, final_salary_amount, deductions_amount FROM Payroll WHERE emp_ID = 1 AND from_date = '2025-10-01';

-- T6: Deduction Check (Ensure no duplicates added after finalization)
EXEC Deduction_hours 1;
SELECT 'D6: Duplicate Deduction Check (Should be 0)' AS Test, COUNT(*) FROM Deduction WHERE emp_ID = 1 AND date > '2025-10-31' AND status = 'pending';

-- --- APPROVAL TESTS ---
-- T1: Compensation Success (ReqID 17, Emp 8, Worked 480 mins)
EXEC HR_approval_comp 17, 4;
SELECT 'L1: Comp Approval Status' AS Test, final_approval_status FROM Leave WHERE request_ID = 17;

-- T2: Compensation Fail (ReqID 18, Emp 1, Worked 360 mins)
EXEC HR_approval_comp 18, 5;
SELECT 'L2: Comp Fail Status (Hours)' AS Test, final_approval_status FROM Leave WHERE request_ID = 18;

-- T5: Accidental Success (ReqID 6, Emp 1)
EXEC HR_approval_an_acc 6, 5;
SELECT 'L5: Accidental Success Status & Balance' AS Test, L.final_approval_status, E.accidental_balance FROM Leave L JOIN Employee E ON E.employee_ID = 1 WHERE L.request_ID = 6;

-- T3: Annual Fail (ReqID 3, Emp 3, 0 Balance)
EXEC HR_approval_an_acc 3, 5;
SELECT 'L3: Annual Fail Status (Balance)' AS Test, final_approval_status FROM Leave WHERE request_ID = 3;

-- T4: Accidental Fail (ReqID 8, Emp 3, Late submission)
EXEC HR_approval_an_acc 8, 5;
SELECT 'L4: Accidental Fail Status (Time)' AS Test, final_approval_status FROM Leave WHERE request_ID = 8;

-- T6: Unpaid Fail (ReqID 14, Emp 1, 42 days duration)
EXEC HR_approval_unpaid 14, 5;
SELECT 'L6: Unpaid Fail Status (Max Days)' AS Test, final_approval_status FROM Leave WHERE request_ID = 14;
GO
-- Assuming current date is 2025-11-23 (Sunday)

                   ---------------------------------

PRINT '--- 2.5 EMPLOYEE SUBMISSION AND APPROVAL TESTS ---';
-- --- PART 1: SUBMISSION TESTS ---

-- T1: Annual Leave Success (Emp 9: MET, Full-Time)
EXEC Submit_annual @employee_ID = 9, @replacement_emp = 1, @start_date = '2025-12-15', @end_date = '2025-12-18';
DECLARE @AnnReqID_S1 INT = SCOPE_IDENTITY();
SELECT 'S1: Annual Routing' AS Test, Emp1_ID AS Approver_ID, status FROM Employee_Approve_Leave WHERE Leave_ID = @AnnReqID_S1;
-- Expected Approvers: 5 (HR Rep MET), 13 (Dean MET)

-- T2: Annual Leave Failure (Emp 6: BI, Part-Time)
EXEC Submit_annual @employee_ID = 6, @replacement_emp = 1, @start_date = '2025-12-15', @end_date = '2025-12-18';
SELECT 'S2: Part-Time Fail Check' AS Test, COUNT(*) AS New_Leave_Records FROM Leave WHERE start_date = '2025-12-15' AND request_ID > @AnnReqID_S1;
-- Expected: 0

-- T3: Accidental Leave (Emp 9: MET)
EXEC Submit_accidental @employee_ID = 9, @start_date = '2025-11-25', @end_date = '2025-11-25';
DECLARE @AccReqID_S3 INT = SCOPE_IDENTITY();
SELECT 'S3: Accidental Routing Check' AS Test, Emp1_ID AS Approver_ID FROM Employee_Approve_Leave WHERE Leave_ID = @AccReqID_S3;
-- Expected Approver: 5 (HR Rep MET)

-- T5: Unpaid Leave (Emp 13: Dean MET) - Routing requires President + HR Rep
EXEC Submit_unpaid @employee_ID = 13, @start_date = '2026-01-01', @end_date = '2026-01-10', @document_description = 'Dean Unpaid', @file_name = 'dean_memo.pdf';
DECLARE @UnpReqID_S5 INT = SCOPE_IDENTITY();
SELECT 'S5: Dean Unpaid Routing' AS Test, Emp1_ID AS Approver_ID FROM Employee_Approve_Leave WHERE Leave_ID = @UnpReqID_S5 ORDER BY Emp1_ID;
-- Expected Approvers: 5 (HR Rep MET), 15 (President)

-- --- PART 2: APPROVAL TESTS (2.5.i) ---

-- T6: A1 - Dean Approves (Success: Same Dept, Rep Available)
EXEC Upperboard_approve_annual @request_ID = @AnnReqID_S1, @Upperboard_ID = 13, @replacement_ID = 1;
SELECT 'A1: Dean Approval Status' AS Test, status FROM Employee_Approve_Leave WHERE Leave_ID = @AnnReqID_S1 AND Emp1_ID = 13;
-- Expected: approved

-- T7: A3 - Dean Rejects (Failure: Different Dept, Dean MET on BI employee)
EXEC Upperboard_approve_annual @request_ID = 2, @Upperboard_ID = 13, @replacement_ID = 11;
SELECT 'A3: Cross-Dept Rejection Check' AS Test, status FROM Employee_Approve_Leave WHERE Leave_ID = 2 AND Emp1_ID = 13;
-- Expected: rejected

-- --- PART 3: FUNCTION OUTPUT CHECK ---

-- T8: Function check F4 (Status Leaves)
SELECT 'F4: Submitted Leaves (Emp 8)' AS Test, * FROM dbo.Status_leaves(8);

-- T9: Function check F3 (Last Month Payroll)
SELECT 'F3: Last Month Payroll (Emp 1)' AS Test, * FROM dbo.Last_month_payroll(1);
GO
-- --- DEDUCTION TESTS ---
-- T1: Deduction Hours (Emp 1, Att ID 7 is 30 mins short)
EXEC Deduction_hours 1;
SELECT 'D1: Missing Hours Inserted' AS Test, amount, status FROM Deduction WHERE emp_ID = 1 AND attendance_ID = 7;

-- T3: Deduction Days (Emp 1, Absent 10-27)
EXEC Deduction_days 1;
SELECT 'D3: Missing Days Inserted' AS Test, amount, status FROM Deduction WHERE emp_ID = 1 AND attendance_ID = 5;

-- T5: Add Payroll (Finalize all pending deductions for Emp 1 in October)
EXEC Add_Payroll 1, '2025-10-01', '2025-10-31';
SELECT 'D5: Payroll Finalization Check' AS Test, final_salary_amount, deductions_amount FROM Payroll WHERE emp_ID = 1 AND from_date = '2025-10-01';

-- T6: Deduction Check (Ensure no duplicates added after finalization)
EXEC Deduction_hours 1;
SELECT 'D6: Duplicate Deduction Check (Should be 0)' AS Test, COUNT(*) FROM Deduction WHERE emp_ID = 1 AND date > '2025-10-31' AND status = 'pending';

-- --- APPROVAL TESTS ---
-- T1: Compensation Success (ReqID 17, Emp 8, Worked 480 mins)
EXEC HR_approval_comp 17, 4;
SELECT 'L1: Comp Approval Status' AS Test, final_approval_status FROM Leave WHERE request_ID = 17;

-- T2: Compensation Fail (ReqID 18, Emp 1, Worked 360 mins)
EXEC HR_approval_comp 18, 5;
SELECT 'L2: Comp Fail Status (Hours)' AS Test, final_approval_status FROM Leave WHERE request_ID = 18;

-- T5: Accidental Success (ReqID 6, Emp 1)
EXEC HR_approval_an_acc 6, 5;
SELECT 'L5: Accidental Success Status & Balance' AS Test, L.final_approval_status, E.accidental_balance FROM Leave L JOIN Employee E ON E.employee_ID = 1 WHERE L.request_ID = 6;

-- T3: Annual Fail (ReqID 3, Emp 3, 0 Balance)
EXEC HR_approval_an_acc 3, 5;
SELECT 'L3: Annual Fail Status (Balance)' AS Test, final_approval_status FROM Leave WHERE request_ID = 3;

-- T4: Accidental Fail (ReqID 8, Emp 3, Late submission)
EXEC HR_approval_an_acc 8, 5;
SELECT 'L4: Accidental Fail Status (Time)' AS Test, final_approval_status FROM Leave WHERE request_ID = 8;

-- T6: Unpaid Fail (ReqID 14, Emp 1, 42 days duration)
EXEC HR_approval_unpaid 14, 5;
SELECT 'L6: Unpaid Fail Status (Max Days)' AS Test, final_approval_status FROM Leave WHERE request_ID = 14;
GO
    ------------EXTRA-----------------
PRINT '---  LEAVE SUBMISSION AND APPROVAL TESTS ---';
GO

-- 1. TEST ANNUAL LEAVE (2.5.g) - SUCCESS PATH
-- Emp 9 (Amr Diab): 10 Annual Days, Full-Time. Replacement: Emp 1 (Jack John)
EXEC Submit_annual @employee_ID = 9, @replacement_emp = 1, @start_date = '2025-12-05', @end_date = '2025-12-06';
DECLARE @AnnReqID_Success INT = SCOPE_IDENTITY();
PRINT 'Annual Leave Submitted (Success Path): ' + CAST(@AnnReqID_Success AS VARCHAR);

-- VERIFY ROUTING: Should route to Dean (13) and HR Rep (5)
SELECT 'Annual Routing Check (Emp 9)' AS Test, Emp1_ID AS Approver_ID, status
FROM Employee_Approve_Leave
WHERE Leave_ID = @AnnReqID_Success;
-- Expected Approvers: 13 (Dean) and 5 (HR Rep)

-- 2. UPPERBOARD APPROVAL (2.5.i) - SUCCESS
EXEC Upperboard_approve_annual @request_ID = @AnnReqID_Success, @Upperboard_ID = 13, @replacement_ID = 1;
SELECT 'Annual UB Approval (Dean 13)' AS Test, status 
FROM Employee_Approve_Leave 
WHERE Leave_ID = @AnnReqID_Success AND Emp1_ID = 13;
-- Expected: approved

-- 3. HR FINAL APPROVAL (2.4.b) - SUCCESS & BALANCE DEDUCTION
EXEC HR_approval_an_acc @request_ID = @AnnReqID_Success, @HR_ID = 5;
SELECT 'Annual Final Status (Approved)' AS Test, L.final_approval_status, E.annual_balance 
FROM Leave L JOIN Employee E ON E.employee_ID = 9 WHERE L.request_ID = @AnnReqID_Success;
-- Expected Status: approved. Expected Balance: 8 (Original 10 - 2 days)

-- 4. TEST ANNUAL LEAVE (2.5.g) - INVALID DATA (Part-Time Check)
-- Emp 6 (Mohamed Ahmed) is Part-Time (Should fail silently)
EXEC Submit_annual @employee_ID = 6, @replacement_emp = 1, @start_date = '2025-12-10', @end_date = '2025-12-11';
-- VERIFY: Check if any new leave was created after the last one (@AnnReqID_Success)
SELECT 'Part-Time Submission Check' AS Test, COUNT(*) AS New_Leave_Records 
FROM Leave 
WHERE request_ID > @AnnReqID_Success AND start_date = '2025-12-10';
-- Expected: 0

-- 5. TEST ACCIDENTAL LEAVE (2.5.j) - INVALID DATA (Duration Check)
-- Emp 1 (Jack John) - Duration > 1 day (Should fail silently)
EXEC Submit_accidental @employee_ID = 1, @start_date = '2025-12-08', @end_date = '2025-12-09';
-- VERIFY: Check if any new leave was created after the last one
SELECT 'Accidental Duration Check' AS Test, COUNT(*) AS New_Leave_Records 
FROM Leave 
WHERE start_date = '2025-12-08';
-- Expected: 0
GO
PRINT '--- III. DEDUCTION AND PAYROLL TESTS ---';
GO

-- 6. TEST UNPAID DEDUCTION (2.4.g) - Multi-Month Split
-- Emp 8 (Magy Zaki): Daily Rate ~1818.18. Approved Leave: Nov 20 to Dec 2.
-- We must use an existing approved leave: ReqID 1 (Emp 8) is approved from 10-26 to 11-01 (7 days)

-- 6a. RUN DEDUCTION (NOVEMBER Context)
-- Should calculate the 1 day falling in Nov (Nov 1)
EXEC Deduction_unpaid @employee_ID = 8;
SELECT 'UNPAID DEDUCTION NOV (1 Day)' AS Test, amount, date 
FROM Deduction 
WHERE emp_ID = 8 AND unpaid_ID = 1 AND date = '2025-11-01';
-- Expected: Amount should be 1818.18 (1 day)

-- 7. TEST DEDUCTION_HOURS (2.4.e)
-- Emp 1: 30 minutes missing on 10-15-2025 (Attendance ID 7). Rate per hour ~166.67.
EXEC Deduction_hours @employee_ID = 1;
SELECT 'MISSING HOURS DEDUCTION' AS Test, amount, status 
FROM Deduction 
WHERE emp_ID = 1 AND type = 'missing_hours' AND status = 'pending' AND attendance_ID = 7;
-- Expected: Amount should be ~83.335

-- 8. GENERATE PAYROLL (2.4.i)
-- Use Emp 1 (Jack John) for Nov payroll.
EXEC Add_Payroll @employee_ID = 1, @from = '2025-11-01', @to = '2025-11-30';

-- VERIFY 1: Finalization Check
SELECT 'DEDUCTION STATUS FINALIZED' AS Test, status, COUNT(*) AS Finalized_Count 
FROM Deduction 
WHERE emp_ID = 1 AND date >= '2025-11-01' AND status = 'finalized';
-- Expected: Finalized_Count should be 2 (The Unpaid deduction + Missing Hours deduction)

-- VERIFY 2: Payroll Record Check
SELECT 'FINAL PAYROLL CREATED' AS Test, final_salary_amount, comments 
FROM Payroll 
WHERE emp_ID = 1 AND from_date = '2025-11-01';
-- Expected final_salary_amount: Should equal Base Salary (40000) - Total Deductions (1818.18 + 83.335)
GO


PRINT '--- YASMINS HELPER FUNCTION VERIFICATION  IGNORE---';
GO

-- Employee 1 (Jack John): TA, 0 YOE, Base 40000. Dept: MET.
-- Employee 11 (Ahmed Salaheldin): Dean, 20 YOE, Base 60000. Dept: BI.

-- 1. Test Calc_Salary (Should return 40000.00 for Emp 1)
SELECT dbo.Calc_Salary(1) AS Salary_Emp1_Expected_40000;

-- 2. Test Deduction_per_day (Emp 1 Daily Rate: 40000 / 22 days)
SELECT dbo.Deduction_per_day(1) AS Daily_Deduction_Emp1; 
-- Expected: ~1818.18

-- 3. Test getDep and getRole (Emp 11)
SELECT dbo.getDep(11) AS Emp11_Dept, dbo.getRole(11) AS Emp11_Role;
-- Expected: BI, Dean

-- 4. Test HR_rep (Should find Emp 5, Menna Shalaby)
SELECT dbo.HR_rep(1) AS HR_Rep_ID_for_MET;
-- Expected: 5

-- 5. Test Is_On_Leave (Emp 12: Nagy Zaki, is currently 'onleave' until 10-30-2025)
SELECT dbo.Is_On_Leave(12, '2025-10-25', '2025-10-28') AS Emp12_OnLeave_Expected_1;
-- Expected: 1 (True)
SELECT dbo.Is_On_Leave(12, '2025-11-01', '2025-11-05') AS Emp12_NotOnLeave_Expected_0;
-- Expected: 0 (False)
GO

 -------------------------INSERTION--------------------------------
 exec createAllTables
------
insert into Department (name,building_location)
values ('MET','C building')
insert into Department (name,building_location)
values ('BI','B building')
insert into Department (name,building_location)
values ('HR','N building')
insert into Department (name,building_location)
values ('Medical','B building')

select * from Department
----------------------
insert into Employee (first_name,last_name,email,
password,address,gender,official_day_off,years_of_experience,
national_ID,employment_status, type_of_contract,emergency_contact_name,
emergency_contact_phone,annual_balance,accidental_balance,hire_date,
last_working_date,dept_name)
values  ('Jack','John','jack.john@guc.edu.eg','123','new cairo',
'M','Saturday',0,'1234567890123456','active','full_time',
'Sarah','01234567892',
30,6,'09-01-2025',null,'MET'),

('Ahmed','Zaki','ahmed.zaki@guc.edu.eg','345',
'New Giza',
'M','Saturday',2,'1234567890123457','active','full_time',
'Mona Zaki','01234567893',
27,0,'09-01-2020',NULL,'BI'), -- EMPLOYEE WITH ZERO ACCIDENTAL LEAVES

('Sarah','Sabry','sarah.sabry@guc.edu.eg','567',
'Korba',
'F','Thursday',5,'1234567890123458','active','full_time',
'Hanen Turk','01234567894',
0,4,'09-01-2020',NULL,'MET'), -- EMPLOYEE WITH ZERO ANNUAL LEAVES

 ('Ahmed','Helmy','ahmed.helmy@guc.edu.eg','908',
'new Cairo',
'M','Thursday',2,'1234567890123459','active','full_time',
'Mona Zaki','01234567895',
8,4,'09-01-2019',NULL,'HR'), -- HR Employee

('Menna','Shalaby','menna.shalaby@guc.edu.eg','670',
'Heliopolis',
'F','Saturday',0,'1234567890123451','active','full_time',
'Mayan Samir','01234567896',
6,2,'09-01-2018',NULL,'HR'), 

('Mohamed','Ahmed','mohamed.ahmedy@guc.edu.eg','9087',
'Nasr City',
'M','Saturday',7,'1234567890123452','active','part_time',
'Marwan Samir','01234567897',
NULL,6,'09-01-2025',NULL,'BI'), --Part timer

('Esraa','Ahmed','esraa.ahmedy@guc.edu.eg','5690',
'New Cairo',
'F','Saturday',2,'1234567890123453','active','full_time',
'Magy Ahmed','01234567898',
36,6,'09-01-2024',NULL,'Medical'), --Medical DR

 ('Magy','Zaki','magy.zaki@guc.edu.eg','3790',
'6th of October city',
'F','Thursday',4,'1234567890123454','onleave','full_time',
'Mariam Ahmed','01234567899',
0,6,'01-01-2023',NULL,'BI'),

('Amr','Diab','amr.diab@guc.edu.eg','8954',
'Heliopolis',
'M','Saturday',4,'1234567890123450','active','full_time',
'Dina','01234567891',
10,10,'09-01-2023',NULL,'MET'),

 ('Marwan','Khaled','marwan.Khaled@guc.edu.eg','9023',
'New Cairo',
'M','Saturday',12,'1234567890123455','active','full_time',
'Omar Ahmed','01234567840',
NULL,NULL,'09-01-2024',NULL,'HR') , --HR Manager

('Ahmed','Salaheldin','ahmed.salaheldin@guc.edu.eg',
'a@123',
'Heliopolis',
'M','Saturday',20,'1234567890123460','active','full_time',
'Dina Ahmed','01234567811',
50,12,'09-01-2009',NULL,'BI'), --DEAN BI 

('Nagy','Zaki','nagy.zaki@guc.edu.eg',
'n@123',
'New Cairo',
'M','Thursday',15,'1234567890123450','onleave','full_time',
'Mona Ragy','01234567821',
40,20,'09-01-2010',NULL,'BI'), --VICE_DEAN BI 

('Hazem','Ali','hazem.ali@guc.edu.eg','h@123',
'New Giza',
'M','Saturday',30,'1234567890123420','active','full_time',
'Fatma Alaa','01234567871',
55,25,'09-01-2008',NULL,'MET'), --DEAN MET 

('Hadeel','Adel','hadeel.adel@guc.edu.eg','ha@123',
'Korba',
'F','Saturday',20,'1234567890123220','active','full_time',
'Mariam Alaa','01234567861',
3,12,'09-01-2010',NULL,'MET'), --vice_dean MET 

('Ali','Mohamed','ali.mohamed@guc.edu.eg','am@123',
'New Cairo',
'M','Saturday',35,'1234567890123120','active','full_time',
'Hesham Ali','01234567761',
null,null,'09-01-2002',null,null), --President 

 ('Donia','Tarek','donia.tarek@guc.edu.eg','dt@123',
'New Cairo',
'F','Saturday',22,'1234567891123120','active','full_time',
'Yasmine Tarek','01234267761',
null,null,'09-01-2006',null,null), --vice President

('Karim','Abdelaziz','karim.abdelaziz@guc.edu.eg',
'ka@123','New Cairo','M','Wednesday',4,'1234567890123120','resigned','full_time',
'Maged ElKedwany','01234277761',
0,0,'09-01-2020','09-20-2025','MET'), --Resigned

('Ghada','Adel','ghada.adel@guc.edu.eg','ga@123',
'Korba',
'F','Saturday',2,'1234567811123120','notice_period','full_time',
'Taha Hussein','01234277761',
0,4,'01-01-2024',NULL,'BI') , --notice_period

('Yasmine','AbdelAziz','yasmine.abdelaziz@guc.edu.eg',
'ya@123','Nasr City','F','Monday',8,'1234567111123120','notice_period',
'full_time','Ramez','01234777761',10,5,'09-01-2022',NULL,'MET')


SELECT * FROM Employee
----------------------------
insert into Employee_Phone (emp_id,phone_num) values (1,'01234567890')
insert into Employee_Phone (emp_id,phone_num) values (2,'01234567891')
insert into Employee_Phone (emp_id,phone_num) values (3,'01234567892')
insert into Employee_Phone (emp_id,phone_num) values (4,'01234567893')
insert into Employee_Phone (emp_id,phone_num) values (5,'01234567894')
insert into Employee_Phone (emp_id,phone_num) values (6,'01234567895')
insert into Employee_Phone (emp_id,phone_num) values (7,'01234567896')
insert into Employee_Phone (emp_id,phone_num) values (8,'01234567897')
insert into Employee_Phone (emp_id,phone_num) values (9,'01234567898')
insert into Employee_Phone (emp_id,phone_num) values (10,'01234567899')
insert into Employee_Phone (emp_id,phone_num) values (11,'01234567880')
insert into Employee_Phone (emp_id,phone_num) values (11,'01234567881')
insert into Employee_Phone (emp_id,phone_num) values (12,'01234567882')
insert into Employee_Phone (emp_id,phone_num) values (13,'01234567883')
insert into Employee_Phone (emp_id,phone_num) values (14,'01234567884')
insert into Employee_Phone (emp_id,phone_num) values (15,'01234567885')
insert into Employee_Phone (emp_id,phone_num) values (16,'01234567886')
insert into Employee_Phone (emp_id,phone_num) values (17,'01234567887')
insert into Employee_Phone (emp_id,phone_num) values (18,'01234567888')
insert into Employee_Phone (emp_id,phone_num) values (19,'01234567889')
insert into Employee_Phone (emp_id,phone_num) values (19,'01234567800')

select * from Employee_Phone
------------------
insert into role (role_name,title,description,rank,base_salary,
percentage_YOE,percentage_overtime,annual_balance,
accidental_balance)
values ('President','Upper Board','Manage University',
1,100000,25.00,25.00,NULL,NULL)
insert into role (role_name,title,description,rank,base_salary,
percentage_YOE,percentage_overtime,annual_balance,
accidental_balance)
values ('Vice President','Upper Board','Helps the president.',
2,75000,20.00,20.00,NULL,NULL)
insert into role (role_name,title,description,rank,base_salary,
percentage_YOE,percentage_overtime,annual_balance,
accidental_balance)
values ('Dean','PHD Holder','Manage the Academic Department.',
3,60000,18.00,18.00,40,12)
insert into role (role_name,title,description,rank,base_salary,
percentage_YOE,percentage_overtime,annual_balance,
accidental_balance)
values ('Vice Dean','PHD Holder','Helps the Dean.',
4,55000,15.00,15.00,35,12)
insert into role (role_name,title,description,rank,base_salary,
percentage_YOE,percentage_overtime,annual_balance,
accidental_balance)
values ('HR Manager','Manager','Manage the HR Department.',
3,60000,18.00,18.00,40,12)
insert into role (role_name,title,description,rank,base_salary,
percentage_YOE,percentage_overtime,annual_balance,
accidental_balance)
values ('HR_Representative_MET','Representative','Assigned to MET department',
4,50000,15.00,15.00,35,12)
insert into role (role_name,title,description,rank,base_salary,
percentage_YOE,percentage_overtime,annual_balance,
accidental_balance)
values ('HR_Representative_BI','Representative','Assigned to BI department',
4,50000,15.00,15.00,35,12)
insert into role (role_name,title,description,rank,base_salary,
percentage_YOE,percentage_overtime,annual_balance,
accidental_balance)
values ('Lecturer','PHD Holder','Delivering Academic Courses.',
5,45000,12.00,12.00,30,12)
insert into role (role_name,title,description,rank,base_salary,
percentage_YOE,percentage_overtime,annual_balance,
accidental_balance)
values ('Teaching Assistant','Master Holder','Assists the Lecturer.',
6,40000,10.00,10.00,30,6)
insert into role (role_name,title,description,rank,base_salary,
percentage_YOE,percentage_overtime,annual_balance,
accidental_balance)
values ('Medical Doctor','Dr','Diagnosing and managing patients’health conditions',
null,35000,10.00,10.00,30,6)
select * from Role
select * from Department
select * from Employee
--------------------------------
insert into Employee_Role (emp_ID,role_name)
values (1,'Teaching Assistant') --MET
insert into Employee_Role (emp_ID,role_name)
values (2,'Teaching Assistant') --BI
insert into Employee_Role (emp_ID,role_name)
values (3,'Lecturer') --MET
insert into Employee_Role (emp_ID,role_name)
values (4,'HR_Representative_BI')
insert into Employee_Role (emp_ID,role_name)
values (5,'HR_Representative_MET')
insert into Employee_Role (emp_ID,role_name)
values (6,'Lecturer') --BI
insert into Employee_Role (emp_ID,role_name)
values (7,'Medical Doctor')
insert into Employee_Role (emp_ID,role_name)
values (8,'Teaching Assistant') --BI
insert into Employee_Role (emp_ID,role_name)
values (9,'Teaching Assistant') --MET
insert into Employee_Role (emp_ID,role_name)
values (10,'HR Manager') 
insert into Employee_Role (emp_ID,role_name)
values (11,'Dean') --BI
insert into Employee_Role (emp_ID,role_name)
values (11,'Lecturer') --BI 
insert into Employee_Role (emp_ID,role_name)
values (12,'Vice Dean') --BI
insert into Employee_Role (emp_ID,role_name)
values (12,'Lecturer') --BI 
insert into Employee_Role (emp_ID,role_name)
values (13,'Dean') --MET
insert into Employee_Role (emp_ID,role_name)
values (13,'Lecturer') --MET 
insert into Employee_Role (emp_ID,role_name)
values (14,'Vice Dean') --MET
insert into Employee_Role (emp_ID,role_name)
values (14,'Lecturer') --MET 
insert into Employee_Role (emp_ID,role_name)
values (15,'President')
insert into Employee_Role (emp_ID,role_name)
values (16,'Vice President')
insert into Employee_Role (emp_ID,role_name)
values (17,'Lecturer') --MET 
insert into Employee_Role (emp_ID,role_name)
values (18,'Teaching Assistant') --	BI 
insert into Employee_Role (emp_ID,role_name)
values (19,'Lecturer') --MET 
select * from Employee_Role
---------------------------------------------
insert into Role_existsIn_Department (department_name,Role_name)
values ('BI','Dean')
insert into Role_existsIn_Department (department_name,Role_name)
values ('BI','Vice Dean')
insert into Role_existsIn_Department (department_name,Role_name)
values ('BI','Lecturer')
insert into Role_existsIn_Department (department_name,Role_name)
values ('BI','Teaching Assistant')
insert into Role_existsIn_Department (department_name,Role_name)
values ('MET','Dean')
insert into Role_existsIn_Department (department_name,Role_name)
values ('MET','Vice Dean')
insert into Role_existsIn_Department (department_name,Role_name)
values ('MET','Lecturer')
insert into Role_existsIn_Department (department_name,Role_name)
values ('MET','Teaching Assistant')
insert into Role_existsIn_Department (department_name,Role_name)
values ('HR','HR_Representative_BI')
insert into Role_existsIn_Department (department_name,Role_name)
values ('HR','HR_Representative_MET')
insert into Role_existsIn_Department (department_name,Role_name)
values ('HR','HR Manager')
insert into Role_existsIn_Department (department_name,Role_name)
values ('Medical','Medical Doctor')

select * from Role_existsIn_Department
------------------------------------------------------
--annual approved TA ID =8
insert into leave (date_of_request,start_date,end_date
,final_approval_status)
values ('10-10-2025','10-26-2025','11-01-2025','approved') 
--annual approved vice DeanID=12
insert into leave (date_of_request,start_date,end_date
,final_approval_status)
values ('09-15-2025','10-19-2025','10-30-2025','approved') 
-- WILL BE rejected no balance id=3
insert into leave (date_of_request,start_date,end_date
,final_approval_status)
values ('10-09-2025','10-28-2025','10-28-2025','PENDING')
-- should be rejected since person of replacement vice dean on leave
insert into leave (date_of_request,start_date,end_date
,final_approval_status)
values ('10-15-2025','10-30-2025','11-01-2025','pending')
--Annual submitted by HR id 5 replacement-id 4.will be rejected since 
--employee id =4 day-off between this range
insert into leave (date_of_request,start_date,end_date
,final_approval_status)
values ('10-26-2025','10-28-2025','10-30-2025','pending') 

-- accidental  (6,7,8)
-- approved
insert into leave (date_of_request,start_date,end_date
,final_approval_status)
values ('10-27-2025','10-26-2025','10-26-2025','pending') 
-- should be rejected 0due to balance
insert into leave (date_of_request,start_date,end_date
,final_approval_status)
values ('10-27-2025','10-26-2025','10-26-2025','pending') 
-- rejection due to late submission after 48 hours
insert into leave (date_of_request,start_date,end_date
,final_approval_status)
values ('10-26-2025','10-22-2025','10-22-2025','pending')

-- medical (9,10,11,12)
-- Pending sick leave
insert into leave (date_of_request,start_date,end_date
,final_approval_status)
values ('10-28-2025','10-30-2025','10-30-2025','pending')
-- approved maternity leave
insert into leave (date_of_request,start_date,end_date
,final_approval_status)
values ('09-13-2022','11-21-2022','03-21-2023','approved')
insert into leave (date_of_request,start_date,end_date
,final_approval_status)
values ('01-12-2024','02-13-2024','06-13-2024','approved')
-- should be rejected maternity Leave due to egyptian labor Law
insert into leave (date_of_request,start_date,end_date
,final_approval_status)
values ('09-13-2025','11-13-2025','03-13-2026','pending')

-- unpaid (13,14,15,16)
--approved case
insert into leave (date_of_request,start_date,end_date
,final_approval_status)
values ('07-13-2025','08-13-2025','09-09-2025','approved')
--should be rejected since duration is more than 30 days
insert into leave (date_of_request,start_date,end_date
,final_approval_status)
values ('08-13-2025','11-02-2025','12-13-2025','Pending')
--should be rejected employee can only get  1 approved unpaid leave per year
-- request id =13
insert into leave (date_of_request,start_date,end_date
,final_approval_status)
values ('11-15-2025','11-27-2025','12-02-2025','Pending')
--should be approved , balance=0 employee-id=8
insert into leave (date_of_request,start_date,end_date
,final_approval_status)
values ('10-15-2025','11-20-2025','12-02-2025','Pending')

--Compensation (17,18,19,20)
--approved 
insert into leave (date_of_request,start_date,end_date
,final_approval_status)
values ('10-05-2025','10-06-2025','10-06-2025','approved') 
--rejected less than 8 hours --attendance table 
insert into leave (date_of_request,start_date,end_date
,final_approval_status)
values ('10-26-2025','10-29-2025','10-29-2025','pending')
--should be rejected not same month  --attendance table
insert into leave (date_of_request,start_date,end_date
,final_approval_status)
values ('10-10-2025','11-03-2025','11-03-2025','pending')
--rejected since person of replacement is on his day off
insert into leave (date_of_request,start_date,end_date
,final_approval_status) 
values ('10-27-2025','10-30-2025','10-30-2025','pending')

-- medical leave rejected
insert into leave (date_of_request,start_date,end_date
,final_approval_status)
values ('09-13-2025','11-13-2025','03-13-2026','rejected')


select * from Leave
----------------------------------------
insert into Annual_Leave (request_ID,emp_ID,replacement_emp)
values (1,8,2)
insert into Annual_Leave (request_ID,emp_ID,replacement_emp)
values (2,12,11)
insert into Annual_Leave (request_ID,emp_ID,replacement_emp)
values (3,3,10)
insert into Annual_Leave (request_ID,emp_ID,replacement_emp)
values (4,11,12)
insert into Annual_Leave (request_ID,emp_ID,replacement_emp)
values (5,5,4)

select * from Annual_Leave
---------------
insert into Accidental_Leave (request_ID,emp_ID) 
values (6,1)
insert into Accidental_Leave (request_ID,emp_ID) 
values (7,18)
insert into Accidental_Leave (request_ID,emp_ID) 
values (8,3)

select * from Accidental_Leave
------------------
insert into Medical_Leave (request_ID,insurance_status,disability_details,type,Emp_ID)
values (9,1,null,'sick',19)
insert into Medical_Leave (request_ID,insurance_status,disability_details,type,Emp_ID)
values (10,1,null,'maternity',3)
insert into Medical_Leave (request_ID,insurance_status,disability_details,type,Emp_ID)
values (11,1,null,'maternity',3)
insert into Medical_Leave (request_ID,insurance_status,disability_details,type,Emp_ID)
values (12,1,null,'maternity',3)

insert into Medical_Leave (request_ID,insurance_status,disability_details,type,Emp_ID)
values (21,1,null,'sick',8)

select * from Medical_Leave
-----------------
insert into Unpaid_Leave (request_id,Emp_ID)
values (13,2)
insert into Unpaid_Leave (request_id,Emp_ID)
values (14,1)
insert into Unpaid_Leave (request_id,Emp_ID)
values (15,2)
insert into Unpaid_Leave (request_id,Emp_ID)
values (16,8)

select * from Unpaid_Leave
-------------------
insert into Compensation_Leave (request_ID,reason, date_of_original_workday,emp_ID,
replacement_emp)
values (17, 'proctoring','10-02-2025',8,18)
insert into Compensation_Leave (request_ID,reason, date_of_original_workday,emp_ID,
replacement_emp)
values (18, 'proctoring','10-04-2025',1,9)
insert into Compensation_Leave (request_ID,reason, date_of_original_workday,emp_ID,
replacement_emp)
values (19, 'Grading','09-04-2025',3,1)
insert into Compensation_Leave (request_ID,reason, date_of_original_workday,emp_ID,
replacement_emp)
values (20, 'Grading','10-04-2025',18,8)

select * from Compensation_Leave
-----------------------------------------------
--EmpID=1
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('contract','Contract of employee','Contract1','09-01-2025','08-31-2026','valid',1,null,null)
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Memo','memo for unpaid','memo1','08-13-2025','11-01-2025','valid',1,null,14)
--EmpID=2
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Contract','Contract of employee','Contract2','09-01-2025','08-31-2026','valid',2,null,null)
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Memo','memo for unpaid','memo_21','07-13-2025','08-12-2025','expired',2,null,13)
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Memo','memo for unpaid','memo_22','11-15-2025','11-26-2025','valid',2,null,15)
--EmpID=3
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Contract','Contract of employee','Contract3','09-01-2025','08-31-2026','valid',3,null,null)
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Medical','Medical Document','Medical_31','09-13-2022','11-20-2022','expired',3,10,null)
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Medical','Medical Document','Medical_32','01-12-2024','02-12-2024','expired',3,11,null)
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Medical','Medical Document','Medical_33','09-13-2025','11-12-2025','valid',3,12,null)
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Contract','Contract of employee','Contract4','09-01-2025','08-31-2026','valid',4,null,null)
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Contract','Contract of employee','Contract5','09-01-2025','08-31-2026','valid',5,null,null)
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Contract','Contract of employee','Contract6','09-01-2025','08-31-2026','valid',6,null,null)
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Contract','Contract of employee','Contract7','09-01-2025','08-31-2026','valid',7,null,null)
--empid=8
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Contract','Contract of employee','Contract8','01-01-2025','12-31-2026','valid',8,null,null)
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Memo','Memo for Unpaid','Memo 8','10-15-2025','11-20-2025','valid',8,null,15)
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Contract','Contract of employee','Contract9','09-01-2025','08-31-2026','valid',9,null,null)
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Contract','Contract of employee','Contract10','09-01-2025','08-31-2026','valid',10,null,null)
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Contract','Contract of employee','Contract11','09-01-2025','08-31-2026','valid',11,null,null)
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Contract','Contract of employee','Contract12','09-01-2025','08-31-2026','valid',12,null,null)
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Contract','Contract of employee','Contract13','01-01-2025','12-31-2026','valid',13,null,null)
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Contract','Contract of employee','Contract14','09-01-2025','08-31-2026','valid',14,null,null)
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Contract','Contract of employee','Contract15','09-01-2025','08-31-2026','valid',15,null,null)
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Contract','Contract of employee','Contract16','09-01-2025','08-31-2026','valid',16,null,null)
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Contract','Contract of employee','Contract17','09-01-2025','08-31-2026','valid',17,null,null)
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Contract','Contract of employee','Contract18','01-01-2025','12-31-2025','valid',18,null,null)
--empID=19
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Contract','Contract of employee','Contract19','09-01-2025','08-31-2026','valid',19,null,null)
insert into document  (type,description,file_name,creation_date,expiry_date,status,emp_ID,medical_ID,unpaid_ID)
values ('Medical','medical doc','medical 19','10-28-2025','10-30-2025','valid',19,9,null)

select * from Document
----------------------------
insert into Attendance (date,check_in_time,check_out_time,status,emp_ID)
values ('09-04-2025','08:30','17:30','attended',3) --requestID =19
insert into Attendance (date,check_in_time,check_out_time,status,emp_ID)
values ('10-02-2025','08:30','16:30','attended',8)--requestID =17
insert into Attendance (date,check_in_time,check_out_time,status,emp_ID)
values ('10-04-2025','08:30','14:30','attended',1) --requestID =18
insert into Attendance (date,check_in_time,check_out_time,status,emp_ID)
values ('10-04-2025','08:30','17:13','attended',18) --requestID =20
insert into Attendance (date,check_in_time,check_out_time,status,emp_ID)
values ('10-27-2025',null,null,'absent',1) --absent
insert into Attendance (date,check_in_time,check_out_time,status,emp_ID)
values ('09-8-2025',null,null,'absent',1) --absent
insert into Attendance (date,check_in_time,check_out_time,status,emp_ID)
values ('10-15-2025','08:30','16:00','attended',1)

select * from Attendance
-----------------------------------------
--Annual Leaves 
insert into Employee_Replace_Employee (Emp1_ID,Emp2_ID,from_date, to_date)
values (8,2,'10-26-2025','11-01-2025')
insert into Employee_Replace_Employee (Emp1_ID,Emp2_ID,from_date, to_date)
values (12,11,'10-19-2025','10-30-2025')
--Compensation leaves 
insert into Employee_Replace_Employee (Emp1_ID,Emp2_ID,from_date, to_date)
values (8,18,'10-06-2025','10-06-2025')

select * from Employee_Replace_Employee
-------------------------------------------
INSERT INTO Performance (rating,comments,semester,emp_ID)
values (4,'Very Good','W24',2)
INSERT INTO Performance (rating,comments,semester,emp_ID)
values (3,'Good','S25',2)
INSERT INTO Performance (rating,comments,semester,emp_ID)
values (4,'Very Good','W24',10)
INSERT INTO Performance (rating,comments,semester,emp_ID)
values (5,'Excellent','S25',10)

select * from Performance
------------------------------------------------
--case 1 due to absent day -- empid =1
insert into Deduction (emp_ID,date,amount,type,
status,unpaid_ID,attendance_ID)
values (1,'10-01-2025',1333.33,'missing_days','finalized',null,7)

insert into Deduction (emp_ID,date,amount,type,
status,unpaid_ID,attendance_ID)
values (1,'10-28-2025',1333.33,'missing_days','pending',null,5)

--case 2 due to Unpaid Leave  affect 2 month
--salary =48K, DAY 1600
insert into Deduction (emp_ID,date,amount,type,
status,unpaid_ID,attendance_ID)
values (2,'09-01-2025',30400,'unpaid','finalized',13,null)

insert into Deduction (emp_ID,date,amount,type,
status,unpaid_ID,attendance_ID)
values (2,'10-01-2025',14400,'unpaid','finalized',13,null)

--case 3 due to Missing Hours (14 hours missing)
-- his salary =56K, hour =233.33
insert into Deduction (emp_ID,date,amount,type,
status,unpaid_ID,attendance_ID)
values (10,'10-01-2025',3266.66,'missing_hours','finalized',null,null)

select * from Deduction



------------------
-- Deductions
insert into Payroll (payment_date,final_salary_amount,from_date,to_date,comments,bonus_amount,deductions_amount,emp_ID)
values ('10-01-2025',38666.67,'09-01-2025','09-30-2025','Has deduction',0,1333.33,1)
insert into Payroll (payment_date,final_salary_amount,from_date,to_date,comments,bonus_amount,deductions_amount,emp_ID)
values ('09-01-2025',17600 ,'08-01-2025','08-31-2025','unpaid Leave',0,30400,2)
insert into Payroll (payment_date,final_salary_amount,from_date,to_date,comments,bonus_amount,deductions_amount,emp_ID)
values ('10-01-2025',33600 ,'09-01-2025','09-30-2025','unpaid Leave',0,14400,2)
insert into Payroll (payment_date,final_salary_amount,from_date,to_date,comments,bonus_amount,deductions_amount,emp_ID)
values ('10-01-2025',52733.34,'09-01-2025','09-30-2025','Missing Hours',0,3266.66,9)
---- Bonuses due to overtime --empId=11 dean and lecturer extra hours 12 hours 
insert into Payroll (payment_date,final_salary_amount,from_date,to_date,comments,bonus_amount,deductions_amount,emp_ID)
values ('04-01-2025',276540,'03-01-2025','03-31-2025','Overtime Factor',540,0,11)


select * from Payroll

--------------------------------
-- Annual Leaves 
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (11,1,'approved')  --approved by BI Dean
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (4,1,'approved') --approved by HR Reprentative for BI
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (15,2,'approved')  --approved by PRESIDENT
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (4,2,'approved') --approved by HR Reprentative for BI
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (13,3,'PENDING')  -- dean of MET 
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (5,3,'PENDING') -- HR Reprentative for MET
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (15,4,'PENDING')  --PRESIDENT
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (4,4,'PENDING') -- HR Reprentative for BI
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (9,5,'PENDING') -- HR Manager

--Accidental Leaves
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (5,6,'PENDING') -- MET_Representative
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (4,7,'PENDING') -- BI_Representative
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (5,8,'PENDING') -- MET_Representative

-- Medical Leaves
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (4,9,'PENDING') -- MET_Representative is onleave , replaced by empid=4  
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (7,9,'PENDING') --doctor approval

insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (5,10,'approved') --  MET_Representative
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (7,10,'approved') --Doctor approval

insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (5,11,'approved') --  MET_Representative
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (7,11,'approved') --Doctor approval

insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (5,12,'PENDING') --  MET_Representative
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (7,12,'PENDING') --Doctor approval

--unpaid Leave 
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (15,13,'approved') --president
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (11,13,'approved') --Dean_BI 
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (4,13,'approved') --HR_BI 

insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (15,14,'PENDING') --president
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (13,14,'PENDING') --Dean_MET
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (5,14,'PENDING') --HR_MET 


insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (15,15,'PENDING') --president
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (11,15,'PENDING') --Dean_BI
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (4,15,'PENDING') --HR_BI

insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (15,16,'PENDING') --president
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (11,16,'PENDING') --Dean_BI
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (4,16,'PENDING') --HR_BI

--Compensation Leave
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (4,17,'approved') --HR_BI
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (5,18,'pending') --HR_MET
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (5,19,'pending') --HR_MET
insert into Employee_Approve_Leave (Emp1_ID,leave_ID,status)
values (5,20,'pending') --HR_MET
------------------------------------------------------




















