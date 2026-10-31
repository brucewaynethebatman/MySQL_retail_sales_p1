/* SQL Retail Sales Analysis */
CREATE Database Data_project1;
USE Data_project1;

-- Data Cleaning.
-- CREATE TABLE
CREATE TABLE retail_sales (
transactions_id INT PRIMARY KEY, 
sale_date DATE, 
sale_time TIME,
customer_id INT,
gender VARCHAR(15),
age INT,
category VARCHAR(15),
quantity INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT);


SELECT * FROM retail_sales;

DESCRIBE retail_sales;

SELECT COUNT(*) FROM retail_sales;

SELECT *
FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
   
SHOW COLUMNS FROM retail_sales;

USE data_project1;

CREATE TABLE retail_sales_raw (
    transactions_id INT,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

DESCRIBE retail_sales_raw;



ALTER TABLE retail_sales_raw
MODIFY transactions_id VARCHAR(255) NULL,
MODIFY sale_date VARCHAR(255) NULL,
MODIFY sale_time VARCHAR(255) NULL,
MODIFY customer_id VARCHAR(255) NULL,
MODIFY gender VARCHAR(255) NULL,
MODIFY age VARCHAR(255) NULL,
MODIFY category VARCHAR(255) NULL,
MODIFY quantity VARCHAR(255) NULL,
MODIFY price_per_unit VARCHAR(255) NULL,
MODIFY cogs VARCHAR(255) NULL,
MODIFY total_sale VARCHAR(255) NULL;


SELECT COUNT(*) AS total_records
FROM retail_sales_raw;

SELECT *
FROM retail_sales_raw
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
   
   SELECT
    SUM(transactions_id = '') AS empty_transaction_id,
    SUM(sale_date = '') AS empty_sale_date,
    SUM(sale_time = '') AS empty_sale_time,
    SUM(customer_id = '') AS empty_customer_id,
    SUM(gender = '') AS empty_gender,
    SUM(age = '') AS empty_age,
    SUM(category = '') AS empty_category,
    SUM(quantity = '') AS empty_quantity,
    SUM(price_per_unit = '') AS empty_price,
    SUM(cogs = '') AS empty_cogs,
    SUM(total_sale = '') AS empty_total_sale
FROM retail_sales_raw;

drop table retail_sales;

ALTER TABLE retail_sales_raw
MODIFY transactions_id INT PRIMARY KEY,
MODIFY sale_date DATE,
MODIFY sale_time TIME,
MODIFY customer_id INT,
MODIFY gender VARCHAR(15),
MODIFY age INT,
MODIFY category VARCHAR(20),
MODIFY quantity INT,
MODIFY price_per_unit DECIMAL(10,2),
MODIFY cogs DECIMAL(10,2),
MODIFY total_sale DECIMAL(10,2);

SELECT * FROM retail_sales_raw;
UPDATE retail_sales_raw
SET
    age = NULLIF(TRIM(age), ''),
    quantity = NULLIF(TRIM(quantity), ''),
    price_per_unit = NULLIF(TRIM(price_per_unit), ''),
    cogs = NULLIF(TRIM(cogs), ''),
    total_sale = NULLIF(TRIM(total_sale), '');
    
SELECT
    SUM(age IS NULL) AS missing_age,
    SUM(quantity IS NULL) AS missing_quantity,
    SUM(price_per_unit IS NULL) AS missing_price,
    SUM(cogs IS NULL) AS missing_cogs,
    SUM(total_sale IS NULL) AS missing_total_sale
FROM retail_sales_raw;

ALTER TABLE retail_sales_raw
MODIFY transactions_id INT NOT NULL,
MODIFY sale_date DATE,
MODIFY sale_time TIME,
MODIFY customer_id INT,
MODIFY gender VARCHAR(15),
MODIFY age INT,
MODIFY category VARCHAR(20),
MODIFY quantity INT,
MODIFY price_per_unit DECIMAL(10,2),
MODIFY cogs DECIMAL(10,2),
MODIFY total_sale DECIMAL(10,2),
ADD PRIMARY KEY (transactions_id);

SELECT * FROM retail_sales_raw
where customer_id IS NULL;

SELECT * FROM retail_sales_raw
WHERE gender IS NULL 
OR age IS NULL 
OR category IS NULL
OR quantity IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

DELETE FROM retail_sales_raw
WHERE gender IS NULL 
OR age IS NULL 
OR category IS NULL
OR quantity IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

SELECT COUNT(*) AS total_records
FROM retail_sales_raw;
-- Data Cleaning done

-- Data Exploration.
-- How many salse we have?
SELECT COUNT(*) AS TOTAL_SALES FROM retail_sales_raw;

-- How many costomers we have?
SELECT COUNT(DISTINCT customer_id) AS TOTAL_CUSTOMERS FROM retail_sales_raw;

-- How many category we have?
SELECT distinct category AS TOTAL_CATEGORY FROM retail_sales_raw;

-- DATA ANALYSIS AND BUSINESS KEY PROBLEMS & ANSWERS.

-- Q1. SALES DONE ON SPECIFIC DATES (FOR e.g."2022-11-05").
SELECT *
FROM retail_sales_raw
WHERE sale_date = "2022-11-05";

-- TO COUNT.
SELECT COUNT(*) AS TOTAL_SALES
FROM retail_sales_raw
WHERE sale_date = "2022-11-05";

-- Q2. TRANSACTION WHERE THE CATEGORY IS 'CLOTHING' AND THE QUANTITY SOLD IS MORE THAN 4 IN THE MONTH OF NOV-2022.
SELECT category, SUM(quantity)
FROM retail_sales_raw
WHERE category = "Clothing"
AND DATE_FORMAT(sale_date, "YYYY-MM") = "2022-11"
GROUP BY 1;

SELECT *
FROM retail_sales_raw
WHERE category = 'Clothing'
AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
AND quantity >= 4;

-- COSTOMER WHO SPENT THE MOST.
SELECT customer_id ,
SUM(total_sale) AS TOTAL_SPENT
FROM retail_sales_raw
GROUP BY customer_id
ORDER BY TOTAL_SPENT DESC
LIMIT 3;

-- DATES WITH THE MOST SALES.
SELECT sale_date, SUM(total_sale) AS TOTAL_SALES
FROM retail_sales_raw
GROUP BY 1
ORDER BY TOTAL_SALES DESC
LIMIT 5;

-- AVG PRICE IN EVERY CATEGORY.
SELECT category, AVG(price_per_unit) AS AVG_PRICE_OF_CATEGORIES FROM retail_sales_raw
GROUP BY 1 
ORDER BY AVG_PRICE_OF_CATEGORIES DESC;

-- Q3 CALCULATING THE TOTAL SALES FOR EACH CATEGORY.
SELECT category, SUM(total_sale) AS NET_SALES,
COUNT(*) AS TOTAL_ORDERS
FROM retail_sales_raw
GROUP BY 1;

-- Q4 FINDING THE AVG OF CUSTOMERS WHO PURCHASED FROM 'BEAUTY' CATEGORY.
SELECT ROUND(AVG(age), 2) AS AVG_AGE
FROM retail_sales_raw
WHERE category = "Beauty";

-- Q5 FINDING ALL TRANSACTIONS WHERE THE TOTAL SALES IS GREATER THAN 1000.
SELECT transactions_id, total_sale, category
FROM retail_sales_raw
WHERE total_sale >1000 ;

-- Q6 FINDING THE TOTAL NUMBER OF TRANSACTIONS MADE BY EACH GENDER IN EACH CATEGORY.
SELECT category, gender , COUNT(*) AS TOTAL_TRANSACTIONS
FROM retail_sales_raw
GROUP BY 1,2
ORDER BY 1;

-- Q7 CALCULATING THE AVG SALES FOR EACH MONTH. FINDIG OUT BEST SELLING MONTH IN EACH YEAR.
SELECT 
	YEAR, 
	MONTH, 
	AVG_SALE 
FROM (
		SELECT YEAR(sale_date) AS YEAR,
		MONTH(sale_date) AS MONTH,
		ROUND(AVG(total_sale),2) AS AVG_SALE,
		RANK() OVER(
		PARTITION BY YEAR(sale_date)
		ORDER BY AVG(total_sale) DESC) AS SALES_RANK
		FROM retail_sales_raw
		GROUP BY 1,2
) AS T2
WHERE SALES_RANK = 1;

-- Q8 FINDING THE TOP 5 CUSTOMERS BASED ON THE HIGHEST TOTAL SALES.
SELECT customer_id, SUM(total_sale) AS TOTAL_SPEND
FROM retail_sales_raw
GROUP BY 1
ORDER BY TOTAL_SPEND DESC
LIMIT 5;

-- Q9 FINDING THE NUMBER OF UNIQUE CUSTOMERS WHO PURCHASED ITEMS FROM EACH CATEGORY.
SELECT category, 
		COUNT(DISTINCT(customer_id)) AS DISTINCT_CUSTOMERS
FROM retail_sales_raw
GROUP BY category;

-- Q10 WRITING A QUERY TO CREATE EACH SHIFT AND NUMBER OF ORDERS (EXAMPLE MORNING <= 12, AFTERNOON BETWEEN 12 & 17, EVENING >=17).
WITH hourly_sales
AS
(
	SELECT *,
			CASE 
				WHEN HOUR(sale_time) < 12  THEN 'MORNING'
				WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
				ELSE 'EVENING'
			END AS SHIFT 
	FROM retail_sales_raw
)
SELECT 
	SHIFT ,
	COUNT(transactions_id) AS TOTAL_ORDERS 
FROM hourly_sales
GROUP BY SHIFT ;

-- END