USE Northwind;
GO

-- 1.Write a query that returns all orders placed on the last day of activity that can be found in the Orders table.
SELECT O1.OrderId, OrderDate, CustomerId, EmployeeId 
FROM Orders AS O1
WHERE OrderDate = (SELECT MAX(O2.OrderDate) FROM Orders AS O2);

-- 2.Write a query that returns all orders placed by the customer(s) who placed the highest number of
--   orders. Note that more than one customer might have the same number of orders.
SELECT CustomerId, OrderId, OrderDate, EmployeeId
FROM Orders
WHERE CustomerId IN
	(SELECT TOP(1) WITH TIES O.CustomerId
	 FROM Orders AS O
	 GROUP BY O.CustomerId
	 ORDER BY COUNT(O.CustomerId) DESC);

-- 3.Write a query that returns employees who did not place orders on or after May 1, 2008.
-- NOTE: I make the year 1998 instead 2008 to suit with my Northwind database
SELECT E.EmployeeId, E.FirstName, E.LastName
FROM Employees AS E
WHERE E.EmployeeId NOT IN
		(SELECT O.EmployeeId
		 FROM Orders AS O
		 WHERE O.OrderDate >= '19980501');

-- 4.Write a query that returns countries where there are customers but not employees.
SELECT DISTINCT C.Country
FROM Customers AS C
WHERE C.Country NOT IN
		(SELECT DISTINCT E.Country
		 FROM Employees AS E);

-- 5.Write a query that returns for each customer all orders placed on the customer’s last day of activity.
SELECT O1.CustomerId, O1.OrderId, O1.OrderDate, O1.EmployeeId
FROM Orders AS O1
WHERE O1.OrderDate = 
		(SELECT MAX(O2.OrderDate)
		 FROM Orders AS O2
		 WHERE O2.CustomerId = O1.CustomerId)
ORDER BY O1.CustomerId;

-- 6.Write a query that returns customers who placed orders in 2007 but not in 2008.
SELECT C.CustomerId, C.CompanyName
FROM Customers AS C
WHERE C.CustomerId IN 
	(SELECT DISTINCT O1.CustomerId
	 FROM Orders AS O1
	 WHERE YEAR(O1.OrderDate) = 1997
		AND NOT EXISTS(SELECT O2.CustomerId
					   FROM Orders AS O2
					   WHERE O1.CustomerId = O2.CustomerId -- Correlate with customers in o1
						AND YEAR(O2.OrderDate) = 1998));
						
-- 7.Write a query that returns customers who ordered product 12.
-- SOLUTION1: Using Join
SELECT DISTINCT C.CustomerId, C.CompanyName
FROM Customers AS C
	INNER JOIN Orders AS O
		ON C.CustomerId = O.CustomerId
	INNER JOIN [Order Details] AS OD
		ON O.OrderId = OD.OrderId
WHERE OD.ProductId = 12;

-- SOLUTION2: Using subquery
SELECT DISTINCT C.CustomerId, C.CompanyName
FROM Customers AS C
WHERE C.CustomerId IN
		(SELECT O.CustomerId
		 FROM Orders AS O
		 WHERE O.CustomerId = C.CustomerId
			AND EXISTS
				(SELECT *
				 FROM [Order Details] AS OD
				 WHERE OD.OrderId = O.OrderId
					AND OD.ProductId = 12));




