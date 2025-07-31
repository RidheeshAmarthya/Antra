
-- 1. Retrieve ProductID, Name, Color, and ListPrice (no filter)
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product;

-- 2. Exclude rows where ListPrice is 0
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE ListPrice <> 0;

-- 3. Retrieve rows where Color is NULL
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NULL;

-- 4. Retrieve rows where Color is NOT NULL
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NOT NULL;

-- 5. Color is not NULL and ListPrice > 0
SELECT ProductID, Name, Color, ListPrice
FROM Production.Product
WHERE Color IS NOT NULL AND ListPrice > 0;

-- 6. Concatenate Name and Color, excluding rows where Color is NULL
SELECT Name + ' -- ' + Color AS ProductDescription
FROM Production.Product
WHERE Color IS NOT NULL;

-- 7. Specific result set
SELECT 'NAME: ' + Name + '  --  COLOR: ' + Color AS Result
FROM Production.Product
WHERE (Name IN ('LL Crankarm', 'ML Crankarm', 'HL Crankarm',
                'Chainring Bolts', 'Chainring Nut', 'Chainring'))
  AND (Color IN ('Black', 'Silver'));

-- 8. ProductID between 400 and 500
SELECT ProductID, Name
FROM Production.Product
WHERE ProductID BETWEEN 400 AND 500;

-- 9. Color is either Black or Blue
SELECT ProductID, Name, Color
FROM Production.Product
WHERE Color IN ('Black', 'Blue');

-- 10. Names that begin with the letter 'S'
SELECT ProductID, Name
FROM Production.Product
WHERE Name LIKE 'S%';

-- 11. Retrieve Name and ListPrice, order by Name
SELECT Name, ListPrice
FROM Production.Product
ORDER BY Name;

-- 12. Retrieve products where Name starts with 'A' or 'S', order by Name
SELECT Name, ListPrice
FROM Production.Product
WHERE Name LIKE 'A%' OR Name LIKE 'S%'
ORDER BY Name;

-- 13. Name starts with 'SPO', but not followed by 'K'
SELECT Name
FROM Production.Product
WHERE Name LIKE 'SPO%' AND Name NOT LIKE 'SPOK%'
ORDER BY Name;

-- 14. Retrieve unique Colors in descending order
SELECT DISTINCT Color
FROM Production.Product
ORDER BY Color DESC;
