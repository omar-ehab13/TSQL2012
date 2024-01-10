USE Northwind;
GO

-- 1-1 Write a query that returns the maximum value in the orderdate column for each employee.
SELECT EmployeeId, Max(OrderDate)
FROM Orders
GROUP BY EmployeeId
ORDER BY EmployeeId;

-- 1-2 Encapsulate the query from Exercise 1-1 in a derived table. Write a join query between the derived
--     table and the Orders table to return the orders with the maximum order date for each employee.
SELECT O.EmployeeId, O.OrderDate, O.OrderId, O.CustomerId
FROM Orders AS O
INNER JOIN (SELECT EmployeeId, MAX(OrderDate) AS MaxOrderDate
			FROM Orders
			GROUP BY EmployeeId) AS EmpWithMaxOrderDate
	ON O.EmployeeId = EmpWithMaxOrderDate.EmployeeId
	AND O.OrderDate = EmpWithMaxOrderDate.MaxOrderDate
ORDER BY O.EmployeeId;

-- 2-1 Write a query that calculates a row number for each order based on orderdate, orderid ordering.
SELECT OrderId, OrderDate, CustomerId, EmployeeId,
	ROW_NUMBER() OVER (ORDER BY OrderDate, OrderId) AS RowNum
FROM Orders;

-- 2-2 Write a query that returns rows with row numbers 11 through 20 based on the row number definition
--     in Exercise 2-1. Use a CTE to encapsulate the code from Exercise 2-1.
WITH IndexedOrders AS
(
	SELECT OrderId, OrderDate, CustomerId, EmployeeId,
		ROW_NUMBER() OVER (ORDER BY OrderDate, OrderId) AS RowNum
	FROM Orders
)
SELECT RowNum, OrderId, OrderDate
FROM IndexedOrders
ORDER BY RowNum
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;

-- 4. Create a view that returns the total quantity for each employee and year.
GO
CREATE SCHEMA test;
GO
IF OBJECT_ID('test.VEmpOrders') IS NOT NULL
	DROP VIEW test.VEmpOrders;
GO
CREATE View test.VEmpOrders
AS
SELECT 
	O.EmployeeId,
	YEAR(O.OrderDate) AS OrderYear,
	SUM(Quantity) AS Quantity
FROM Orders AS O
INNER JOIN [Order Details] AS OD
	ON O.OrderId = OD.OrderId
GROUP BY O.EmployeeId, YEAR(O.OrderDate)
GO

-- 4.2 Write a query against Sales.VEmpOrders that returns the running total quantity for each employee and year.
SELECT EmployeeId, OrderYear, Quantity,
	(SELECT SUM(Quantity)
	 FROM test.VEmpOrders AS V2
	 WHERE V1.EmployeeId = V2.EmployeeId
		AND V2.OrderYear <= V1.OrderYear) AS RunQty
FROM test.VEmpOrders AS V1
ORDER BY EmployeeId, OrderYear

-- 5-1 Create an inline function that accepts as inputs a supplier ID (@supid AS INT) and a requested number
--     of products (@n AS INT). The function should return @n products with the highest unit prices that
--     are supplied by the specified supplier ID.
GO
CREATE FUNCTION test.TopProducts
	(@supid AS INT, @n AS INT)
	RETURNS TABLE
AS
RETURN
	SELECT ProductId, ProductName, UnitPrice
	FROM Products
	WHERE SupplierId = @supid
	ORDER BY UnitPrice DESC
	OFFSET 0 ROWS FETCH FIRST @n ROWS ONLY
GO

-- 5-2 Using the CROSS APPLY operator and the function you created in Exercise 4-1, return, for each supplier,
--     the two most expensive products.
SELECT S.SupplierId, S.CompanyName, P.ProductId, P.ProductName, P.UnitPrice
FROM Suppliers AS S
CROSS APPLY test.TopProducts(S.SupplierId, 2) AS P
ORDER BY S.SupplierId, P.UnitPrice DESC;



