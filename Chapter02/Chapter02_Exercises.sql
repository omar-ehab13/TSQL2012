USE Northwind;

-- [1] Write a query against the Sales.Orders table that returns orders placed in June 2007.

SELECT OrderId, OrderDate, CustomerId,EmployeeId
FROM Orders
WHERE OrderDate BETWEEN '19970801' AND '19970831'
ORDER BY OrderDate;

SELECT OrderId, OrderDate, CustomerId,EmployeeId
FROM Orders
WHERE OrderDate >= '1997-08-01' AND OrderDate < '1997-09-01'
ORDER BY OrderDate;

SELECT OrderId, OrderDate, CustomerId,EmployeeId
FROM Orders
WHERE YEAR(OrderDate) = 1997 AND MONTH(OrderDate) = 8
ORDER BY OrderDate;

-- [2] Write a query against the Sales.Orders table that returns orders placed on the last day of the month.

SELECT OrderId, OrderDate, CustomerId,EmployeeId
FROM Orders
WHERE DAY(DATEADD(day, 1, OrderDate)) = 1
ORDER BY OrderDate;

SELECT OrderId, OrderDate, CustomerId,EmployeeId
FROM Orders
WHERE OrderDate = EOMONTH(OrderDate)
ORDER BY OrderDate;

SELECT OrderId, OrderDate, CustomerId,EmployeeId
FROM Orders
WHERE OrderDate = DATEADD(month, DATEDIFF(month, '19991231', orderdate), '19991231')
ORDER BY OrderDate;

-- [3] Write a query against the HR.Employees table that returns employees with last name containing the
--     letter `a` twice or more.
SELECT EmployeeId, FirstName, LastName
FROM Employees
WHERE LastName like'%a%a%';

-- [4] Write a query against the Sales.OrderDetails table that returns orders with total value (quantity * unitprice)
--     greater than 10,000, sorted by total value.

SELECT OrderId, SUM(UnitPrice * Quantity) AS TotalValue
FROM [Order Details]
GROUP BY OrderId
HAVING SUM(UnitPrice * Quantity) > 10000;

-- [5] Write a query against the Sales.Orders table that returns the three shipped-to countries with the highest
--     average freight in 2007.

SELECT TOP(3) ShipCountry, AVG(Freight) AS AvgFreight
FROM Orders
WHERE ShippedDate >= '19970101' AND ShippedDate < '19980101'   -- I filter on 1997 instead 2007 beacause my data before 1998.
GROUP BY ShipCountry
ORDER BY AvgFreight DESC

-- [6] Write a query against the Sales.Orders table that calculates row numbers for orders based on order
--     date ordering (using the order ID as the tiebreaker) for each customer separately.

SELECT CustomerId, OrderDate, OrderId,
	ROW_NUMBER() OVER (PARTITION BY CustomerId ORDER BY OrderDate, OrderId) AS RowNum
FROM Orders
ORDER BY CustomerId, RowNum

-- [7] Using the HR.Employees table, figure out the SELECT statement that returns for each employee the
--     gender based on the title of courtesy. For ‘Ms. ‘ and ‘Mrs.’ return ‘Female’; for ‘Mr. ‘ return ‘Male’; and
--     in all other cases (for example, ‘Dr. ‘) return ‘Unknown’.

SELECT EmployeeId, FirstName, LastName, TitleOfCourtesy,
	CASE TitleOfCourtesy
		WHEN 'Ms.' THEN 'Female'
		WHEN 'Mrs.' THEN 'Female'
		WHEN 'Mr.' THEN 'Male'
		ELSE 'Unknown'
	END AS Gender
FROM Employees

-- [8] Write a query against the Sales.Customers table that returns for each customer the customer ID and
--     region. Sort the rows in the output by region, having NULL marks sort last (after non-NULL values).
--     Note that the default sort behavior for NULL marks in T-SQL is to sort first (before non-NULL values).


-- SOLUTION EXPLAIN: 
-- Initially, we sort 0 first and then 1
-- 0 for non-NULL values are sorted before 1 for NULL values
-- then we sort 0 values (non-NULL values) by region
SELECT CustomerId, Region
FROM Customers
ORDER BY 
	CASE
		WHEN Region IS NULL THEN 1
		ELSE 0
	END, 
	Region;


