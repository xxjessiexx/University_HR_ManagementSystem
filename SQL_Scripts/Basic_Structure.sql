
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
 


 
 

