-- 1- Write a query that generates a virtual auxiliary table of 10 numbers in the range 1 through 10 without
--    using a looping construct. You do not need to guarantee any order of the rows in the output of your solution.
SELECT 1 AS n
UNION ALL SELECT 2
UNION ALL SELECT 3
UNION ALL SELECT 4
UNION ALL SELECT 5
UNION ALL SELECT 6
UNION ALL SELECT 7
UNION ALL SELECT 8
UNION ALL SELECT 9
UNION ALL SELECT 10

-- 2- Write a query that returns customer and employee pairs that had order activity in January 2008 but
--    not in February 2008.
SELECT CustomerId, EmployeeId
FROM Orders
WHERE OrderDate >= '19980101' AND OrderDate < '19980201'
EXCEPT
SELECT CustomerId, EmployeeId
FROM Orders
WHERE OrderDate >= '19980201' AND OrderDate < '19980301'

-- 3- Write a query that returns customer and employee pairs that had order activity in both January 2008
--    and February 2008.
SELECT CustomerId, EmployeeId
FROM Orders
WHERE OrderDate >= '19980101' AND OrderDate < '19980201'
INTERSECT
SELECT CustomerId, EmployeeId
FROM Orders
WHERE OrderDate >= '19980201' AND OrderDate < '19980301'

-- 4- Write a query that returns customer and employee pairs that had order activity in both January 2008
--    and February 2008 but not in 2007.
SELECT CustomerId, EmployeeId
FROM Orders
WHERE OrderDate >= '19980101' AND OrderDate < '19980201'
INTERSECT
SELECT CustomerId, EmployeeId
FROM Orders
WHERE OrderDate >= '19980201' AND OrderDate < '19980301'
EXCEPT
SELECT CustomerId, EmployeeId
FROM Orders
WHERE OrderDate >= '19970101' AND OrderDate < '19980101'

-- 5- 
/*
You are given the following query.

SELECT country, region, city
FROM HR.Employees

UNION ALL

SELECT country, region, city
FROM Production.Suppliers;

You are asked to add logic to the query so that it guarantees that the rows from Employees are
returned in the output before the rows from Suppliers. Also, within each segment, the rows should be
sorted by country, region, and city.
*/
SELECT Country, Region, City
FROM (SELECT 0 AS SortCol, Country, Region, City
	  FROM Employees
	  UNION ALL
	  SELECT 1, Country, Region, City
	  FROM Suppliers) AS D
ORDER BY SortCol, Country, Region, City;