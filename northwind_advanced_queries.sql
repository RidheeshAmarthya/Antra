
-- 1. List all cities that have both Employees and Customers
SELECT DISTINCT e.City
FROM Employees e
INNER JOIN Customers c ON e.City = c.City;

-- 2a. List all cities that have Customers but no Employee (Using sub-query)
SELECT DISTINCT c.City
FROM Customers c
WHERE c.City NOT IN (SELECT DISTINCT City FROM Employees);

-- 2b. List all cities that have Customers but no Employee (Without sub-query)
SELECT DISTINCT c.City
FROM Customers c
LEFT JOIN Employees e ON c.City = e.City
WHERE e.City IS NULL;

-- 3. List all products and their total order quantities
SELECT p.ProductName, SUM(od.Quantity) AS TotalQuantity
FROM Products p
JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductName;

-- 4. List all Customer Cities and total products ordered by that city
SELECT c.City, SUM(od.Quantity) AS TotalQuantity
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.City;

-- 5. List all Customer Cities that have at least two customers
SELECT City
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) >= 2;

-- 6. List all Customer Cities that have ordered at least two different kinds of products
SELECT c.City
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.City
HAVING COUNT(DISTINCT od.ProductID) >= 2;

-- 7. List Customers who have different ShipCity in their orders than their own City
SELECT DISTINCT c.CompanyName, o.ShipCity AS OrderCity, c.City AS CustomerCity
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.ShipCity <> c.City;

-- 8. List 5 most popular products, their average price, and the top customer city
WITH ProductPopularity AS (
    SELECT TOP 5 od.ProductID, SUM(od.Quantity) AS TotalQty
    FROM [Order Details] od
    GROUP BY od.ProductID
    ORDER BY TotalQty DESC
),
CityQuantity AS (
    SELECT od.ProductID, c.City, SUM(od.Quantity) AS Qty
    FROM [Order Details] od
    JOIN Orders o ON od.OrderID = o.OrderID
    JOIN Customers c ON o.CustomerID = c.CustomerID
    GROUP BY od.ProductID, c.City
),
TopCityPerProduct AS (
    SELECT ProductID, City
    FROM (
        SELECT ProductID, City, Qty,
               RANK() OVER (PARTITION BY ProductID ORDER BY Qty DESC) AS rnk
        FROM CityQuantity
    ) AS Ranked
    WHERE rnk = 1
)
SELECT p.ProductName, AVG(od.UnitPrice) AS AvgPrice, tcpp.City
FROM ProductPopularity pp
JOIN Products p ON pp.ProductID = p.ProductID
JOIN [Order Details] od ON pp.ProductID = od.ProductID
JOIN TopCityPerProduct tcpp ON pp.ProductID = tcpp.ProductID
GROUP BY p.ProductName, tcpp.City;

-- 9a. Cities that never ordered anything but have employees (Using sub-query)
SELECT DISTINCT e.City
FROM Employees e
WHERE e.City NOT IN (
    SELECT DISTINCT c.City
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
);

-- 9b. Cities that never ordered anything but have employees (Without sub-query)
SELECT DISTINCT e.City
FROM Employees e
LEFT JOIN Customers c ON e.City = c.City
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

-- 10. City of employee with most orders AND city with most quantity ordered
WITH EmpOrders AS (
    SELECT e.City, COUNT(o.OrderID) AS OrderCount
    FROM Employees e
    JOIN Orders o ON e.EmployeeID = o.EmployeeID
    GROUP BY e.City
),
TopEmpCity AS (
    SELECT TOP 1 City AS EmpCity
    FROM EmpOrders
    ORDER BY OrderCount DESC
),
CityQuantities AS (
    SELECT c.City, SUM(od.Quantity) AS TotalQty
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY c.City
),
TopQtyCity AS (
    SELECT TOP 1 City AS QtyCity
    FROM CityQuantities
    ORDER BY TotalQty DESC
)
SELECT tec.EmpCity, tqc.QtyCity
FROM TopEmpCity tec
CROSS JOIN TopQtyCity tqc;

-- 11. Remove duplicate rows from a table (general method)
-- Assuming a table named 'YourTable' with columns 'Col1', 'Col2', and a unique identity column 'ID'
WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY Col1, Col2 ORDER BY ID) AS rn
    FROM YourTable
)
DELETE FROM CTE WHERE rn > 1;
