USE Northwind;
GO
IF OBJECT_ID('dbo.Nums', 'U') IS NOT NULL DROP TABLE dbo.Nums;
CREATE TABLE dbo.Nums(n INT NOT NULL PRIMARY KEY);
GO
DECLARE @counter INT = 1;

WHILE @counter <= 10000
BEGIN
	INSERT INTO dbo.Nums(n) VALUES (@counter);
	SET @counter = @counter + 1;
END
SELECT n From dbo.Nums

-- 1.1 Write a query that generates five copies of each employee row.
SELECT EmployeeId, FirstName, LastName, Nums.n
FROM Employees
CROSS JOIN dbo.Nums
WHERE Nums.n <= 5
ORDER BY Nums.n;

-- 1.2 Write a query that returns a row for each employee and day in the range June 12, 2009 through
--     June 16, 2009.
SELECT EmployeeId, dts.dt
FROM Employees CROSS JOIN
	(SELECT DATEADD(day, n-1, '20090612') AS dt
	FROM Nums
	WHERE n <= DATEDIFF(day, '20090612', '20090616') + 1) AS dts
ORDER BY EmployeeId, dts.dt;

-- Another solution
SELECT E.EmployeeId, DATEADD(day, D.n - 1, '20090612') AS dt
FROM Employees AS E
CROSS JOIN dbo.Nums AS D
WHERE D.n <= DATEDIFF(day, '20090612', '20090616') + 1
ORDER BY E.EmployeeId, dt;


-- 2.Return United States customers, and for each customer return the total number of orders and total quantities.
SELECT C.CustomerId,
	COUNT(DISTINCT O.OrderId) AS NumOrders,
	SUM(OD.Quantity) AS TotalQty
FROM Customers AS C
	INNER JOIN Orders AS O
		ON C.CustomerId = O.CustomerId
	INNER JOIN [Order Details] AS OD
		ON O.OrderId = OD.OrderId
WHERE C.Country = 'USA'
GROUP BY C.CustomerId;


-- 3.Return customers and their orders, including customers who placed no orders.
SELECT C.CustomerId, C.CompanyName, O.OrderId, O.OrderDate
FROM Customers AS C
LEFT JOIN Orders AS O
ON C.CustomerId = O.CustomerId


-- 4.Return customers who placed no orders.
SELECT C.CustomerId, C.CompanyName, O.OrderId, O.OrderDate
FROM Customers AS C
LEFT JOIN Orders AS O
ON C.CustomerId = O.CustomerId
WHERE O.OrderId IS NULL;


-- 5.Return customers with orders placed on February 12, 2007, along with their orders.
-- NOTE: I'll query on year 1997 instead 2007 to suit with my northwind database
SELECT C.CustomerId, C.CompanyName, O.OrderId, O.OrderDate
FROM Customers AS C
	INNER JOIN Orders AS O
	ON C.CustomerId = O.CustomerId
WHERE O.OrderDate = '19970212';


-- 6.Return customers with orders placed on February 12, 2007, along with their orders. Also return customers
--   who didn’t place orders on February 12, 2007.
SELECT C.CustomerId, C.CompanyName, O.OrderId, O.OrderDate
FROM Customers AS C
	LEFT OUTER JOIN Orders AS O
	ON C.CustomerId = O.CustomerId
	AND O.OrderDate = '19970212';


-- 7.Return all customers, and for each return a Yes/No value depending on whether the customer placed
--   an order on February 12, 2007.
SELECT C.CustomerId,
	   C.CompanyName,
	   CASE
		WHEN O.OrderId IS NOT NULL THEN 'YES'
		ELSE 'NO'
	   END AS HasOrderOn20070212
FROM Customers AS C
	LEFT OUTER JOIN Orders AS O
	ON C.CustomerId = O.CustomerId
	AND O.OrderDate = '19970212';

