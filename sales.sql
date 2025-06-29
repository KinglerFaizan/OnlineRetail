CREATE DATABASE SALES;

USE SALES;
CREATE TABLE OnlineRetail (

    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description TEXT,
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice DECIMAL(10, 2),
    CustomerID VARCHAR(20),
    Country VARCHAR(50)
);

SELECT a.CustomerID, a.InvoiceNo, b.Quantity, c.UnitPrice
FROM sales.onlineretail a
JOIN sales.onlineretail_1501_to_2000 b ON a.CustomerID = b.CustomerID
JOIN sales.onlineretail_2001_to_3000 c ON a.CustomerID = c.CustomerID;

CREATE TABLE sales.combined_onlineretail AS
SELECT * FROM sales.onlineretail
UNION ALL
SELECT * FROM sales.onlineretail_1501_to_2000
UNION ALL
SELECT * FROM sales.onlineretail_2001_to_3000;


SELECT 
    ROUND(SUM(Quantity * UnitPrice), 2) AS TotalRevenue
FROM sales.combined_onlineretail;

SELECT 
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month,
    ROUND(SUM(Quantity * UnitPrice), 2) AS MonthlyRevenue
FROM sales.combined_onlineretail
GROUP BY Month
ORDER BY Month;

SELECT 
    CustomerID,
    ROUND(SUM(Quantity * UnitPrice), 2) AS CustomerRevenue
FROM sales.combined_onlineretail
GROUP BY CustomerID
ORDER BY CustomerRevenue DESC
LIMIT 10;

SELECT 
    Description,
    ROUND(SUM(Quantity * UnitPrice), 2) AS Revenue
FROM sales.combined_onlineretail
GROUP BY Description
ORDER BY Revenue DESC
LIMIT 5;

SELECT 
    Country,
    ROUND(SUM(Quantity * UnitPrice), 2) AS RevenueByCountry
FROM sales.combined_onlineretail
GROUP BY Country
ORDER BY RevenueByCountry DESC;

SELECT 
    ROUND(SUM(Quantity * UnitPrice) / COUNT(DISTINCT InvoiceNo), 2) AS AvgBasketValue
FROM sales.combined_onlineretail;

SELECT 
    CustomerID,
    MAX(InvoiceDate) AS LastPurchase,
    COUNT(DISTINCT InvoiceNo) AS Frequency,
    ROUND(SUM(Quantity * UnitPrice), 2) AS Monetary
FROM sales.combined_onlineretail
GROUP BY CustomerID;



