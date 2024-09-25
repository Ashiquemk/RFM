Create database sql_project;
use sql_project;
select * from rfm;
ALTER TABLE rfm MODIFY PurchaseDate DATE;

SELECT CustomerID, MAX(PurchaseDate) AS LastPurchaseDate, DATEDIFF(current_date(),MAX(PurchaseDate)) AS Recency FROM rfm GROUP BY CustomerID;

SELECT CustomerID,COUNT(*) AS Frequency FROM rfm GROUP BY CustomerID ORDER BY Frequency DESC;

SELECT CustomerID,SUM(TransactionAmount) AS Monetary FROM rfm GROUP BY CustomerID;

WITH TEMP AS (SELECT R.CustomerID, R.Recency, F.Frequency, M.Monetary 
FROM (SELECT CustomerID, MAX(PurchaseDate) AS LastPurchaseDate, DATEDIFF(current_date(),MAX(PurchaseDate)) AS Recency FROM rfm GROUP BY CustomerID) R 
JOIN
(SELECT CustomerID,COUNT(*) AS Frequency FROM rfm GROUP BY CustomerID ORDER BY Frequency DESC) F ON R.CustomerID=F.CustomerID
JOIN
(SELECT CustomerID,SUM(TransactionAmount) AS Monetary FROM rfm GROUP BY CustomerID) M 
ON R.CustomerID=M.CustomerID)

SELECT CustomerID, 
CASE WHEN Frequency>=10 THEN 'HIGH'
WHEN Frequency>5 AND Frequency<10 THEN 'Medium'
ELSE 'LOW'
END AS FREQUENCY_SCORE,
CASE WHEN Monetary>=500 THEN 'HIGH'
WHEN Monetary BETWEEN 200 AND 499 THEN 'MEDIUM'
ELSE 'LOW' 
END AS MONETARY_SCORE
FROM TEMP;



