
-- Show table schema for the "retail" table
\d + retail;


-- Q1: Show first 10 rows from the table
SELECT 
  * 
FROM 
  retail 
LIMIT 
  10;
  
-- Q2: Count the total number of records in the retail table
SELECT 
  COUNT(*) 
FROM 
  retail;
  
-- Q3: Count the number of unique customers (client IDs)
SELECT 
  COUNT(DISTINCT customer_id) 
FROM 
  retail;
  
-- Q4: Find the date range for invoices (minimum and maximum invoice_date)
SELECT 
  MIN(invoice_date) AS min_date, 
  MAX(invoice_date) AS max_date 
FROM 
  retail;
  
-- Q5: Count the number of unique stock codes (SKUs)
SELECT 
  COUNT(DISTINCT stock_code) 
FROM 
  retail;
  
-- Q6: Calculate the average invoice amount excluding invoices with negative totals (likely canceled orders)
SELECT 
  AVG(invoice_total) AS avg_invoice_amount 
FROM 
  (
    SELECT 
      invoice_no, 
      SUM(unit_price * quantity) AS invoice_total 
    FROM 
      retail 
    GROUP BY 
      invoice_no 
    HAVING 
      SUM(unit_price * quantity) > 0
  ) sub;
  
-- Q7: Calculate the total revenue (sum of unit_price * quantity across all records)
SELECT 
  SUM(unit_price * quantity) AS total_revenue 
FROM 
  retail;
  
-- Q8: Calculate total revenue aggregated by year and month (YYYYMM format)
SELECT 
  TO_CHAR(invoice_date, 'YYYYMM') AS year_month, 
  SUM(unit_price * quantity) AS revenue 
FROM 
  retail 
GROUP BY 
  year_month 
ORDER BY 
  year_month;
