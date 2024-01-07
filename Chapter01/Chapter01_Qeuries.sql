-- sets the current database context to that of TSQL2012
USE TSQL2012;

GO;

-- invokes the OBJECT_ID function to check whether the Employees table already exists in the current database.
IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL
	DROP TABLE dbo.Employees;

-- Create Employees table
CREATE TABLE dbo.Employees
(
	empid INT NOT NULL,
	firstname VARCHAR(30) NOT NULL,
	lastname VARCHAR(30) NOT NULL,
	hiredate DATE NOT NULL,
	mgrid INT NULL,
	ssn VARCHAR(20) NOT NULL,
	salary MONEY NOT NULL
);

-- Add primary key constraint for the Employees table
-- A primary key constraint enforces uniqueness of rows and also disallows NULL marks in the constraint attributes.
ALTER TABLE dbo.Employees
	ADD CONSTRAINT PK_Employees
	PRIMARY KEY(empid);

-- Add unique constraint for the Employees table
-- A unique constraint enforces the uniqueness of rows
-- Unlike with primary keys, you can define multiple unique constraints within the same table.
-- a unique constraint is not restricted to columns defined as NOT NULL (Allow NULL)
ALTER TABLE dbo.Employees
	ADD CONSTRAINT UNQ_Employees_ssn
	UNIQUE(ssn);

-- Check if the Orders table is already exists
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL
	DROP TABLE dbo.Orders;

-- Create table Orders
CREATE TABLE dbo.Orders
(
	orderid INT NOT NULL,
	empid INT NOT NULL,
	custid VARCHAR(10) NOT NULL,
	orderts DATETIME2 NOT NULL,
	qty INT NOT NULL,

	CONSTRAINT PK_Orders PRIMARY KEY(orderid)
);

-- Add Foreign key constriant for Orders table On empid column reference to Employees table
ALTER TABLE dbo.Orders
	ADD CONSTRAINT FK_Orders_Employees
	FOREIGN KEY(empid)
	REFERENCES dbo.Employees(empid);

-- Add foreign key constraint for Employees table on mgrid column reference to itself (Employee table)
ALTER TABLE dbo.Employees
	ADD CONSTRAINT FK_Employees_Employees
	FOREIGN KEY(mgrid)
	REFERENCES dbo.Employees(empid);


/*
	You can define the foreign key with actions that will compensate for such attempts (to delete rows
	from the referenced table or update the referenced candidate key attributes when related rows exist
	in the referencing table).

	You can define the options ON DELETE and ON UPDATE with actions such
	as CASCADE, SET DEFAULT, and SET NULL as part of the foreign key definition.

	1) CASCADE means that the operation (delete or update) will be cascaded to related rows
		For example, ON DELETE CASCADE
		means that when you delete a row from the referenced table, the RDBMS will delete the related rows
		from the referencing table.
	2) SET DEFAULT and SET NULL mean that the compensating action will set the foreign key
		attributes of the related rows to the column’s default value or NULL, respectively.
*/

-- Add check constraint for Employees table on salary coloumn to accept only non-negative values or null
ALTER TABLE dbo.Employees
	ADD CONSTRAINT CHK_Employees_salary
	CHECK(salary > 0.00);

-- Add Default constraint for Orders table on orderts column and set current date as default value
-- the SYSDATETIME function, which returns the current date and time value.
ALTER TABLE dbo.Orders
	ADD CONSTRAINT DFT_Orders_orderts
	DEFAULT(SYSDATETIME()) FOR orderts;

-- DROP TABLE dbo.Orders, dbo.Employees;