/*

=> Cross Join: A cross join implements only one logical query processing phase-a Cartesian Product. 
	- Each row from one input is matched with all rows from the other
	- ANSI SQL-92 Syntax
		SELECT C.custid, E.empid
		FROM Sales.Customers AS C
		CROSS JOIN HR.Employees AS E;

	- Because there are 91 rows in the Customers table and 9 rows in the Employees table, this query
	  produces a result set with 819 rows, as shown here in abbreviated form.

=> Producing Table of Numbers:
	USE TSQL2012;

	IF OBJECT_ID('dbo.Digits', 'U') IS NOT NULL DROP TABLE dbo.Digits;

	CREATE TABLE dbo.Digits(digit INT NOT NULL PRIMARY KEY);

	INSERT INTO dbo.Digits(digit)
	VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

	SELECT digit FROM dbo.Digits;

=> Producing a sequence of integers in the range 1 through 1,000:
	SELECT (D3.digit * 100 + D2.digit * 10 + D1.digit + 1) AS n
	FROM Digits AS D1
	CROSS JOIN Digits AS D2
	CROSS JOIN Digits AS D3
	ORDER BY n;

=> Inner Join: An inner join applies two logical query processing phases—it applies a Cartesian product between
			   the two input tables as in a cross join, and then it filters rows based on a predicate that you specify.

	- ANSI SQL-92 Syntax
		SELECT E.empid, E.firstname, E.lastname, O.orderid
		FROM HR.Employees AS E
		JOIN Sales.Orders AS O
		ON E.empid = O.empid;

=> Composite Joins: A composite join is simply a join based on a predicate that involves more than one attribute from
				    each side. A composite join is commonly required when you need to join two tables based on a
				    primary key–foreign key relationship and the relationship is composite; that is, based on more than
				    one attribute.
	- Example
		FROM dbo.Table1 AS T1
		JOIN dbo.Table2 AS T2
		ON T1.col1 = T2.col1
		AND T1.col2 = T2.col2

=> Non-Equi Joins: When a join condition involves only an equality operator, the join is said to be an equi join. When a
				   join condition involves any operator besides equality, the join is said to be a non-equi join.
	- Example:
		SELECT
			E1.empid, E1.firstname, E1.lastname,
			E2.empid, E2.firstname, E2.lastname
		FROM HR.Employees AS E1
		JOIN HR.Employees AS E2
		ON E1.empid < E2.empid;

=> Multi-Join Queries: A join table operator operates only on two tables, but a single query can have multiple joins.
					   when more than one table operator appears in the FROM clause, the table operators are logically
					   processed from left to right.

	- Examplple:
	SELECT
		C.custid, C.companyname, O.orderid,
		OD.productid, OD.qty
	FROM Sales.Customers AS C
		JOIN Sales.Orders AS O
			ON C.custid = O.custid
		JOIN Sales.OrderDetails AS OD
			ON O.orderid = OD.orderid;

=> Outer Join: 
	- In an outer join, you mark a table as a “preserved” table by using the keywords LEFT OUTER JOIN,
	  RIGHT OUTER JOIN, or FULL OUTER JOIN between the table names.
	- The LEFT keyword means that the rows of the left table are preserved.
	- The RIGHT keyword means that the rows in the right table are preserved.
	- The FULL keyword means that the rows in both the left and right tables are preserved.
	- The third logical query processing phase of an outer join identifies the rows from
	  the preserved table that did not find matches in the other table based on the ON predicate.
	  This phase adds those rows to the result table produced by the first two phases of the join, and
	  uses NULL marks as placeholders for the attributes from the nonpreserved side of the join in those
	  outer rows.
*/