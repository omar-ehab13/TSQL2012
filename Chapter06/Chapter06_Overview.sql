/*

=> SET OPERATORES:
	- A set operator compares complete rows between the result sets of the two input queries involved.
	- The two queries involved in a set operator must produce results with the same number of columns,
	  and corresponding columns must have compatible data types.

=> UNION Operator:In set theory, the union of two sets (call them A and B) is the set containing all elements of both A and B.
=> 1- UNION ALL Operator
	- The following code uses the UNION ALL operator to unify employee locations and customer locations.
		USE TSQL2012;

		SELECT country, region, city FROM HR.Employees
		UNION ALL
		SELECT country, region, city FROM Sales.Customers;

	- Because UNION ALL doesn’t eliminate duplicates, the result is a multiset and not a set. The same row can appear
	  multiple times in the result, as is the case with (UK, NULL, London) in the result of this query.

=> 2- UINION DISTINCT
	SELECT country, region, city FROM HR.Employees
	UNION
	SELECT country, region, city FROM Sales.Customers;

=> INTERSECT OPERATOR: In set theory, the intersection of two sets (call them A and B) is the set of all elements that belong to A
					   and also belong to B.

	- The INTERSECT set operator logically first eliminates duplicate rows from the two input multisets—turning them to sets
	- For example, the following code returns distinct locations that are both employee locations and customer locations.
		SELECT country, region, city FROM HR.Employees
		INTERSECT
		SELECT country, region, city FROM Sales.Customers;


=> EXCEPT Operator: In set theory, the difference of sets A and B (A – B) is the set of elements that belong to A and do not belong to B.
	- For example, the following code returns distinct locations that are employee locations but not customer locations.
		SELECT country, region, city FROM HR.Employees
		EXCEPT
		SELECT country, region, city FROM Sales.Customers;


=> Precedence: SQL defines precedence among set operators. The INTERSECT operator precedes UNION and EXCEPT, 
			   and UNION and EXCEPT are considered equal.

*/
