
--- project 


--- creating a data base with name learnbay 
use learnbay

--- retrive data from data 
select * from Data_retail

-- data cleaning 

-- check for missing values 

SELECT 
    'Price' AS Column_Name, COUNT(*) AS Missing_Values 
FROM Data_retail WHERE Price IS NULL
UNION ALL
SELECT 
    'Category', COUNT(*) 
FROM Data_retail WHERE Category IS NULL
UNION ALL
SELECT 
    'Rating', COUNT(*) 
FROM Data_retail WHERE Rating IS NULL
UNION ALL
SELECT 
    'Stock Quantity', COUNT(*) 
FROM Data_retail WHERE "Stock Quantity" IS NULL;  ---- not getting any missing values 

--- check for duplicate product id 
SELECT "Product_ID", COUNT(*) AS Duplicate_Count
FROM Data_retail
GROUP BY "Product_ID"
HAVING COUNT(*) > 1;  ---- not a duplicate value found  

-- check for negative or zero prices 
SELECT "Product_ID", "Product_Name", Price
FROM Data_retail
WHERE Price <= 0;  --- no negative or zero values found 

--check for invalid rating ( not in range 0-5 )
SELECT "Product_ID", "Product_Name", Rating
FROM Data_retail
WHERE Rating < 0 OR Rating > 5;  --- not an invalid rating 

-- changing the name of column for convineance 
EXEC sp_rename 'Data_retail.Product ID', 'Product_ID';
EXEC sp_rename 'Data_retail.Product Name', 'Product_Name';

--- hence data is uptodate for work 


-- task 1 :  Identifies products with prices higher than the average price within their category.

SELECT Product_ID, Product_Name, Category, Price 
FROM Data_retail r
WHERE Price > (
    SELECT AVG(Price) 
    FROM Data_retail 
    WHERE Category = r.Category
);

----task 2: Finding Categories with Highest Average Rating Across Products. 

SELECT TOP 1 Category, AVG(Rating) AS Avg_Rating 
FROM Data_retail 
GROUP BY Category
ORDER BY Avg_Rating DESC;

---- task 3 : Find the most reviewed product in each warehouseWITH RankedProducts AS (
    SELECT Warehouse, Product_ID, Product_Name, Reviews,
    RANK() OVER (PARTITION BY Warehouse ORDER BY Reviews DESC) AS Rank
    FROM Data_retail 
)
SELECT Warehouse, Product_ID, Product_Name, Reviews
FROM RankedProducts
WHERE Rank = 1;
-- task 4 : find products that have higher-than-average prices within their category, along with their discount and supplier.SELECT Product_ID, Product_Name, Category, Price, Discount, Supplier 
FROM  Data_retail r 
WHERE Price > (
    SELECT AVG(Price) 
    FROM  Data_retail 
    WHERE Category = r.Category
);

--- task 5 : Query to find the top 2 products with the highest average rating in each categoryWITH RankedProducts AS (
    SELECT Category, Product_ID,Product_Name,Rating,
    RANK() OVER (PARTITION BY Category ORDER BY Rating DESC) AS Rank
    FROM Data_retail
)
SELECT Category, Product_ID, Product_Name, Rating
FROM RankedProducts
WHERE Rank <= 2;


--- task 6 : analysis Across All Return Policy Categories(Count, Avgstock, total stock, weighted_avg_rating, etc)

SELECT 
    "Return Policy", 
    COUNT(Product_ID) AS Product_Count, 
    AVG("Stock Quantity") AS Avg_Stock, 
    SUM("Stock Quantity") AS Total_Stock,
    SUM(Rating * "Stock Quantity") / NULLIF(SUM("Stock Quantity"), 0) AS Weighted_Avg_Rating
FROM Data_retail
GROUP BY "Return Policy";

