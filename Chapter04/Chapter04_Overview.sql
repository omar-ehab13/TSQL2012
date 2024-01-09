/*

=> Outer Query: The outermost query is a query whose result set is returned to the caller.
=> Inner Query: is a query whose result is used by the outer query and is known as a subquery.
	- Self Contained Subquery: has no dependency on the outer query that it belongs to.
	- Correlated subquery: has dependency on the outer query that it belongs to.

=> Self Contained Scalar Subquery Examples:
	-- This quey to get the maximum order id in the table.
		DECLARE @maxid AS INT = (SELECT MAX(orderid)
								 FROM Sales.Orders);

		SELECT orderid, orderdate, empid, custid
		FROM Sales.Orders
		WHERE orderid = @maxid;

	-- We can substitude the technique that uses variables with an embeded subquey.
		SELECT orderid, orderdate, empid, custid
		FROM Sales.Orders
		WHERE orderid = (SELECT MAX(O.orderid)
						 FROM Sales.Orders AS O);
						 
=> Self-Contained Multivalued Subquery Examples:
	-- we use IN opertor to filter in multivalued query
		SELECT orderid
		FROM Sales.Orders
		WHERE empid IN
			(SELECT E.empid
			 FROM HR.Employees AS E
			 WHERE E.lastname LIKE N'D%');
	-- As with any other predicate, you can negate the IN predicate with the NOT logical operator
		SELECT custid, companyname
		FROM Sales.Customers
		WHERE custid NOT IN
					(SELECT O.custid
					 FROM Sales.Orders AS O);

=> Correlated Subqueries:
	-- The following query returns orders with the maximum order Id for each customer.
	SELECT custid, orderid, orderdate, empid
	FROM Sales.Orders AS O1
	WHERE orderid = 
			(SELECT MAX(O2.orderid)
			 FROM Sales.Orders AS O2
			 WEHRE O1.custid = O2.custid);

	-- Query to calculate percentage of the currenct order value to the total orders for the customer.
	SELECT orderid, custid, val,
		CAST(100. * val / (SELECT SUM(O2.val)
						   FROM Sales.OrderValues AS O2
						   WHERE O2.custid = O1.custid) AS NUMBER(5, 2)) AS pct
	FROM Sales.OrderValues AS O1
	ORDER BY custid, orderid;

=> The EXISTS Predicate: accepts a subquery as input and returns TRUE if the 
						 subquery returns any rows and FALSE otherwise.
	-- Query to get customers in spanin and has at least one order
		SELECT custid, companyname
		FROM Sales.Customers AS C
		WHERE country = N'Spain'
			AND EXISTS
				(SELECT * FROM Sales.Orders AS O
				 WHERE O.custid = C.custid);

*/