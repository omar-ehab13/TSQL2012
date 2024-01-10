/*
=> Derived Table: are defined in the FROM clause of an outer query. Their scope of existence is the outer query.
	- Example for defining derived table called USACusts
		SELECT *
		FROM (SELECT custid, companyname
			  FROM Sales.Customers
		      WHERE country = N'USA') AS USACusts;
	- A query must meet three requirements to be valid to define a table expression of any kind.
		1- Order is not guaranteed
		2- All columns must have names
		3- All column names must be unique

	- Assiging Column Aliases
	-- the following is invalid query because orderyear not known in group by.
		SELECT
			YEAR(orderdate) AS orderyear,
			COUNT(DISTINCT custid) AS numcusts
		FROM Sales.Orders
		GROUP BY orderyear;
	
	-- What if the expression were much longer? Maintaining two copies of the same expression might
	-- hurt code readability and maintainability and is more prone to errors.
	---- The solution of this problem with one copy of the expression
		SELECT orderyear, COUNT(DISTINCT custid) AS numcusts
		FROM (SELECT YEAR(orderdate) AS orderyear, custid
			  FROM Sales.Orders) AS D
		GROUP BY orderyear;

	- Multiple Reference Problem: if you need to refer to multiple instances of the derived table,
								  you can’t. Instead, you have to define multiple derived tables
								  based on the same query.

		SELECT 
			Cur.orderyear,
			Cur.numcusts AS curnumcusts,
			Prv.numcusts AS prvnumcusts,
			Cur.numcusts - Prv.numcusts AS growth
		FROM (SELECT
			      YEAR(orderdate) AS orderyear,
				  COUNT(DISTINCT custid) AS numcusts
			  FROM Sales.Orders
			  GROUP BY YEAR(orderdate)) AS Cur
		LEFT OUTER JOIN
			 (SELECT
				  YEAR(orderdate) AS orderyear,
				  COUNT(DISTINCT custid) AS numcusts
			  FROM Sales.Orders
			  GROUP BY YEAR(orderdate)) AS Prv
		ON Cur.orderyear = Prv.orderyear + 1;



=> Common Table Expressions CTE: CTEs are defined by using a WITH statement and have the following general form.
	-- example of define CTE called USACusts
		WITH USACusts AS
		(
			SELECT custid, companyname
			FROM Sales.Customers
			WHERE country = N'USA'
		)
		SELECT * FROM USACusts;

	- Assigning Column Aliases in CTEs: CTEs also support two forms of column aliasing—inline and external.
	- Defining Multiple CTEs: if you need to refer to one CTE from another, you don’t end up nesting them as
							  you do with derived tables. Instead, you simply define multiple CTEs
							  separated by commas under the same WITH statement.

	-- example of refering one CTE to another
		WITH C1 AS
		(
			SELECT YEAR(orderdate) AS orderyear, custid
			FROM Sales.Orders
		),
		C2 AS
		(
			SELECT orderyear, COUNT(DISTINCT custid) AS numcusts
			FROM C1
			GROUP BY orderyear
		)
		SELECT orderyear, numcusts
		FROM C2
		WHERE numcusts > 70;

	- Multiple References in CTEs
		WITH YearlyCount AS
		(
			SELECT YEAR(orderdate) AS orderyear,
			COUNT(DISTINCT custid) AS numcusts
			FROM Sales.Orders
			GROUP BY YEAR(orderdate)
		)
		SELECT Cur.orderyear,
			Cur.numcusts AS curnumcusts, Prv.numcusts AS prvnumcusts,
			Cur.numcusts - Prv.numcusts AS growth
		FROM YearlyCount AS Cur
		LEFT OUTER JOIN YearlyCount AS Prv
		ON Cur.orderyear = Prv.orderyear + 1;


=> View: is a reusable table expression whose definition is stored in the database.
	-- Create a View called Sales.USACusts
		IF OBJECT_ID('Sales.USACusts') IS NOT NULL
		DROP VIEW Sales.USACusts;
		GO

		CREATE VIEW Sales.USACusts
		AS
		SELECT
			custid, companyname, contactname, contacttitle, address,
			city, region, postalcode, country, phone, fax
		FROM Sales.Customers
		WHERE country = N'USA';
		GO


=> Inline Table-Valued Functions TVFs: Inline TVFs are reusable table expressions that support input parameters.
	-- Create TVF called GetCustOrders
		USE TSQL2012;
		IF OBJECT_ID('dbo.GetCustOrders') IS NOT NULL
		DROP FUNCTION dbo.GetCustOrders;
		GO

		CREATE FUNCTION dbo.GetCustOrders (@cid AS INT) RETURNS TABLE
		AS
		RETURN
			SELECT orderid, custid, empid, orderdate, requireddate,
				shippeddate, shipperid, freight, shipname, shipaddress, shipcity,
				shipregion, shippostalcode, shipcountry
			FROM Sales.Orders
			WHERE custid = @cid;
		GO


=> Apply Operator: 
	- it might sound like the CROSS APPLY operator is very similar to a cross join, and in a sense that’s true.
	- However, with the CROSS APPLY operator, the right table expression can represent a different set
	  of rows per each row from the left table, unlike in a join.
	-- the following code uses the CROSS APPLY operator to return the three most recent orders for each customer.
		SELECT C.custid, A.orderid, A.orderdate
		FROM Sales.Customers AS C
		CROSS APPLY
			(SELECT TOP (3) orderid, empid, orderdate, requireddate
			 FROM Sales.Orders AS O
			 WHERE O.custid = C.custid
			 ORDER BY orderdate DESC, orderid DESC) AS A;

	- For encapsulation purposes, you might find it more convenient to work with inline TVFs instead of derived tables
		IF OBJECT_ID('dbo.TopOrders') IS NOT NULL
		DROP FUNCTION dbo.TopOrders;
		GO
		CREATE FUNCTION dbo.TopOrders
			(@custid AS INT, @n AS INT)
			RETURNS TABLE
		AS
		RETURN
			SELECT TOP (@n) orderid, empid, orderdate, requireddate
			FROM Sales.Orders
			WHERE custid = @custid
			ORDER BY orderdate DESC, orderid DESC;
		GO

		SELECT
			C.custid, C.companyname,
			A.orderid, A.empid, A.orderdate, A.requireddate
		FROM Sales.Customers AS C
		CROSS APPLY dbo.TopOrders(C.custid, 3) AS A;

*/