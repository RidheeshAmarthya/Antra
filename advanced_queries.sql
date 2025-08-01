
-- 1. Total number of products
SELECT COUNT(*) AS TotalProducts
FROM Production.Product;

-- 2. Number of products with a subcategory
SELECT COUNT(*) AS ProductsWithSubcategory
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL;

-- 3. Number of products per subcategory
SELECT ProductSubcategoryID, COUNT(*) AS CountedProducts
FROM Production.Product
GROUP BY ProductSubcategoryID;

-- 4. Number of products without a subcategory
SELECT COUNT(*) AS ProductsWithoutSubcategory
FROM Production.Product
WHERE ProductSubcategoryID IS NULL;

-- 5. Sum of product quantities
SELECT SUM(Quantity) AS TotalQuantity
FROM Production.ProductInventory;

-- 6. Sum of product quantities by ProductID where LocationID = 40 and total < 100
SELECT ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100;

-- 7. Sum of product quantities by ProductID and Shelf where LocationID = 40 and total < 100
SELECT Shelf, ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY Shelf, ProductID
HAVING SUM(Quantity) < 100;

-- 8. Average quantity where LocationID = 10
SELECT AVG(Quantity) AS AverageQuantity
FROM Production.ProductInventory
WHERE LocationID = 10;

-- 9. Average quantity by ProductID and Shelf
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
GROUP BY ProductID, Shelf;

-- 10. Average quantity by ProductID and Shelf excluding 'N/A'
SELECT ProductID, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE Shelf <> 'N/A'
GROUP BY ProductID, Shelf;

-- 11. Group by Color and Class with non-null values
SELECT Color, Class, COUNT(*) AS TheCount, AVG(ListPrice) AS AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class;

-- 12. Country and province names
SELECT cr.Name AS Country, sp.Name AS Province
FROM Person.CountryRegion cr
JOIN Person.StateProvince sp ON cr.CountryRegionCode = sp.CountryRegionCode;

-- 13. Filtered by Germany and Canada
SELECT cr.Name AS Country, sp.Name AS Province
FROM Person.CountryRegion cr
JOIN Person.StateProvince sp ON cr.CountryRegionCode = sp.CountryRegionCode
WHERE cr.Name IN ('Germany', 'Canada');

-- The following use the Northwind database

-- 14. Products sold at least once in last 27 years
SELECT DISTINCT p.ProductName
FROM Products p
JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON o.OrderID = od.OrderID
WHERE o.OrderDate >= DATEADD(YEAR, -27, GETDATE());

-- 15. Top 5 zip codes by total product sales
SELECT TOP 5 c.PostalCode, COUNT(*) AS SalesCount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.PostalCode
ORDER BY SalesCount DESC;

-- 16. Top 5 zip codes by total product sales in last 27 years
SELECT TOP 5 c.PostalCode, COUNT(*) AS SalesCount
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.OrderDate >= DATEADD(YEAR, -27, GETDATE())
GROUP BY c.PostalCode
ORDER BY SalesCount DESC;

-- 17. City names and number of customers
SELECT City, COUNT(*) AS CustomerCount
FROM Customers
GROUP BY City;

-- 18. Cities with more than 2 customers
SELECT City, COUNT(*) AS CustomerCount
FROM Customers
GROUP BY City
HAVING COUNT(*) > 2;

-- 19. Customers who placed orders after 1/1/1998
SELECT DISTINCT c.CompanyName, o.OrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate > '1998-01-01';

-- 20. All customers with their most recent order dates
SELECT c.CompanyName, MAX(o.OrderDate) AS MostRecentOrder
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CompanyName;

-- 21. Customers and count of products they bought
SELECT c.CompanyName, COUNT(od.ProductID) AS ProductCount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CompanyName;

-- 22. Customers who bought more than 100 products
SELECT c.CustomerID, COUNT(od.ProductID) AS ProductCount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID
HAVING COUNT(od.ProductID) > 100;

-- 23. Ways suppliers can ship products
SELECT s.CompanyName AS SupplierCompanyName, sh.CompanyName AS ShippingCompanyName
FROM Suppliers s
CROSS JOIN Shippers sh;

-- 24. Products ordered each day
SELECT o.OrderDate, p.ProductName
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID;

-- 25. Employee pairs with the same job title
SELECT e1.EmployeeID AS Employee1, e2.EmployeeID AS Employee2, e1.Title
FROM Employees e1
JOIN Employees e2 ON e1.Title = e2.Title AND e1.EmployeeID < e2.EmployeeID;

-- 26. Managers with more than 2 direct reports
SELECT ReportsTo AS ManagerID, COUNT(*) AS ReportCount
FROM Employees
WHERE ReportsTo IS NOT NULL
GROUP BY ReportsTo
HAVING COUNT(*) > 2;

-- 27. Customers and suppliers by city
SELECT City, CompanyName AS Name, ContactName, 'Customer' AS Type
FROM Customers
UNION
SELECT City, CompanyName AS Name, ContactName, 'Supplier' AS Type
FROM Suppliers;
