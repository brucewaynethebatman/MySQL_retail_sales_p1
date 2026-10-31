Retail Sales Analysis Using MySQL
Author: Lokesh Kumawat
Project type: SQL Data Cleaning, Exploratory Data Analysis, and
Business Analysis
Database: MySQL
1. Project Overview
This project analyses retail transaction data using MySQL. It
demonstrates a practical SQL workflow, starting with database and table
creation, followed by raw-data validation, cleaning, exploratory
queries, and business-focused analysis.

The analysis focuses on transaction activity, customer spending, product
categories, sales dates, monthly performance, and order volume by time
of day.

The repository contains the SQL script:

SQL - Retail Sales Analysis_utf.sql
2. Project Objectives
- Create a MySQL database and tables for retail transaction data.
- Inspect the structure and quality of incoming data.
- Identify NULL values and empty strings.
- Convert columns to suitable data types.
- Remove records with selected missing values.
- Explore transaction, customer, and category information.
- Answer business questions using filtering, aggregation, grouping,
  date functions, CTEs, and window functions.
3. Tools and SQL Concepts
Tool: MySQL / MySQL Workbench
Language: SQL

SQL concepts used in the script:
- Database and table creation: CREATE DATABASE, CREATE TABLE
- Schema changes: ALTER TABLE, MODIFY, ADD PRIMARY KEY
- Data cleaning: TRIM(), NULLIF(), UPDATE, DELETE
- Data inspection: SELECT, DESCRIBE, SHOW COLUMNS
- Filtering: WHERE, IS NULL, comparison operators
- Aggregation: COUNT(), SUM(), AVG(), ROUND()
- Grouping and sorting: GROUP BY, ORDER BY, LIMIT
- Distinct counting: COUNT(DISTINCT ...)
- Date and time: DATE_FORMAT(), YEAR(), MONTH(), HOUR()
- Conditional logic: CASE
- Common Table Expressions: WITH
- Window functions: RANK() OVER()
4. Dataset Structure
The SQL script expects a retail transaction dataset with these fields:

  Column              Meaning
  transactions_id   Transaction identifier
sale_date         Date of the transaction
sale_time         Time of the transaction
customer_id       Customer identifier
gender            Customer gender recorded in the data
age               Customer age
category          Product category
quantity          Quantity purchased
price_per_unit    Price per unit
cogs              Cost of goods sold
total_sale        Total sale value for the transaction

Dataset note: The supplied SQL file defines the table structure and
analysis queries, but it does not include the source data rows or a
data-import command. You must import the dataset into retail_sales_raw
before running the cleaning and analysis sections. The file does not
state the dataset's source, currency, or exact row count, so these are
not specified here.
5. Step-by-Step Project Workflow
Step 1: Create the database
CREATE DATABASE Data_project1;
USE Data_project1;
Explanation:
- CREATE DATABASE creates a database named Data_project1.
- USE selects that database so subsequent SQL statements run inside
  it.
Step 2: Create the initial table
The script first creates a retail_sales table containing transaction,
customer, product, quantity, cost, and sales fields. It then inspects
the table using:
SELECT * FROM retail_sales;
DESCRIBE retail_sales;
SELECT COUNT(*) FROM retail_sales;
SHOW COLUMNS FROM retail_sales;
Explanation:
- SELECT * displays the table records.
- DESCRIBE and SHOW COLUMNS show the table schema and column
  types.
- COUNT(*) returns the number of rows.
Step 3: Create a raw staging table
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
The script subsequently changes the raw columns to VARCHAR(255) so
incoming values can be inspected as text before assigning final data
types.

Why use a staging table?

A staging table provides a place to inspect incoming data before
applying cleaning and type conversion. In this project, the table used
for the later cleaning and analysis steps is retail_sales_raw.
Step 4: Check record counts and missing values
The script counts the raw records:
SELECT COUNT(*) AS total_records
FROM retail_sales_raw;
It then searches for rows containing SQL NULL values:
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
Explanation:
- COUNT(*) counts all rows.
- IS NULL checks whether a field contains a missing SQL value.
- The OR conditions return a row if at least one listed column is
  NULL.
The script also counts empty strings:
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
Explanation:

Each comparison checks whether a column contains an empty string.
SUM() adds the resulting true/false values to provide a count for each
column. This is different from checking SQL NULL: an empty string and
NULL are not the same thing.
Step 5: Convert columns to their intended data types
The script changes the raw columns to types such as INT, DATE,
TIME, VARCHAR, and DECIMAL(10,2).

For example:
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
Explanation:
- IDs, age, and quantity are represented as integers.
- Sale date and time use DATE and TIME.
- Monetary/decimal values use DECIMAL(10,2) to store values to two
  decimal places.
- The transaction ID is intended to uniquely identify each transaction
  and act as the primary key.
Step 6: Handle blank values and check missing data again
The script uses TRIM() and NULLIF() in an update:
UPDATE retail_sales_raw
SET
    age = NULLIF(TRIM(age), ''),
    quantity = NULLIF(TRIM(quantity), ''),
    price_per_unit = NULLIF(TRIM(price_per_unit), ''),
    cogs = NULLIF(TRIM(cogs), ''),
    total_sale = NULLIF(TRIM(total_sale), '');
Explanation:
- TRIM() removes leading and trailing spaces.
- NULLIF(value, '') returns NULL when the value is an empty
  string; otherwise it returns the value.
- The update is intended to standardise blank values in the selected
  fields.
The script then counts missing values in those fields:
SELECT
    SUM(age IS NULL) AS missing_age,
    SUM(quantity IS NULL) AS missing_quantity,
    SUM(price_per_unit IS NULL) AS missing_price,
    SUM(cogs IS NULL) AS missing_cogs,
    SUM(total_sale IS NULL) AS missing_total_sale
FROM retail_sales_raw;
Step 7: Remove records with selected missing values
The script first checks for missing customer IDs and then checks the
other required fields. It deletes rows where one or more of the
following fields is missing: gender, age, category, quantity,
price_per_unit, cogs, or total_sale.
DELETE FROM retail_sales_raw
WHERE gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
Explanation:

The OR conditions mean a row is deleted if any one of the listed
fields is NULL. The script then counts the remaining records.

Important implementation note: In the supplied script, type
conversion occurs before the TRIM()/`NULLIF()` update. MySQL may
coerce blank or invalid text during conversion or issue warnings. For a
more robust fresh-data workflow, convert blank text to NULL while the
staging columns are still text, validate the values, and then convert
the columns to their final types. Also, the script checks
customer_id IS NULL but does not include customer_id in the shown
DELETE condition.
6. Exploratory Data Analysis Queries
After cleaning, the script performs basic exploration.
6.1 Count transactions
SELECT COUNT(*) AS TOTAL_SALES
FROM retail_sales_raw;
What it does: Counts the number of transaction rows in the cleaned
table. The alias TOTAL_SALES is the query's label; technically, this
is a transaction-row count, not the sum of revenue.
6.2 Count unique customers
SELECT COUNT(DISTINCT customer_id) AS TOTAL_CUSTOMERS
FROM retail_sales_raw;
What it does: Counts each customer ID once, even if that customer
appears in multiple transactions.
6.3 List product categories
SELECT DISTINCT category AS TOTAL_CATEGORY
FROM retail_sales_raw;
What it does: Returns the unique category values. DISTINCT removes
duplicate category names. The alias is a label; the result is a list,
not a numeric total.
7. Business Analysis: Query-by-Query Explanation
The following sections explain the business questions and the SQL logic
used in the supplied script.
Query 1: Retrieve transactions on a specific date
SELECT *
FROM retail_sales_raw
WHERE sale_date = "2022-11-05";
A second query counts the matching transactions:
SELECT COUNT(*) AS TOTAL_SALES
FROM retail_sales_raw
WHERE sale_date = "2022-11-05";
Business question: Which transactions took place on 5 November 2022,
and how many transaction records match that date?

How it works:
- SELECT * returns all columns for matching rows.
- WHERE sale_date = ... filters the table to the specified date.
- COUNT(*) counts the rows that meet the same condition.
Concepts: SELECT, WHERE, date filtering, COUNT().
Query 2: Clothing transactions in November 2022 with quantity of at least four
The script first contains a category/month aggregation:
SELECT category, SUM(quantity)
FROM retail_sales_raw
WHERE category = "Clothing"
  AND DATE_FORMAT(sale_date, "YYYY-MM") = "2022-11"
GROUP BY 1;
It then retrieves the individual qualifying transactions:
SELECT *
FROM retail_sales_raw
WHERE category = 'Clothing'
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
  AND quantity >= 4;
Business question: Which Clothing transactions in November 2022 had
a quantity of at least four?

How it works:
- The category condition selects Clothing records.
- DATE_FORMAT() extracts a year-month representation for comparison.
- quantity >= 4 keeps transactions with four or more units.
- GROUP BY 1 in the first query groups the result by its first
  selected column (category) and sums quantity.
Concepts: WHERE, AND, DATE_FORMAT(), SUM(), GROUP BY.

MySQL format note: The second query uses the MySQL format string
'%Y-%m', where %Y represents the four-digit year and %m the month.
The first query uses "YYYY-MM", which is not the standard MySQL
date-format pattern; use '%Y-%m' for the same comparison.
Query 3: Find the three customers who spent the most
SELECT customer_id,
       SUM(total_sale) AS TOTAL_SPENT
FROM retail_sales_raw
GROUP BY customer_id
ORDER BY TOTAL_SPENT DESC
LIMIT 3;
Business question: Which three customers have the highest cumulative
spending?

How it works:
1. GROUP BY customer_id combines each customer's transaction rows.
2. SUM(total_sale) calculates each customer's total spending.
3. ORDER BY TOTAL_SPENT DESC sorts the largest spending totals first.
4. LIMIT 3 returns the first three customers.
Concepts: SUM(), GROUP BY, ORDER BY, DESC, LIMIT.
Query 4: Find the five dates with the highest total sales
SELECT sale_date,
       SUM(total_sale) AS TOTAL_SALES
FROM retail_sales_raw
GROUP BY 1
ORDER BY TOTAL_SALES DESC
LIMIT 5;
Business question: Which five dates generated the highest total
sales value?

How it works:
- GROUP BY 1 groups by the first selected column, sale_date.
- SUM(total_sale) calculates the total sales value for each date.
- Descending sorting places the highest daily totals first.
- LIMIT 5 returns the top five dates.
Concepts: SUM(), GROUP BY, positional grouping, sorting,
LIMIT.
Query 5: Calculate the average unit price for each category
SELECT category,
       AVG(price_per_unit) AS AVG_PRICE_OF_CATEGORIES
FROM retail_sales_raw
GROUP BY 1
ORDER BY AVG_PRICE_OF_CATEGORIES DESC;
Business question: What is the average unit price in each product
category, and which category has the highest average?

How it works:
- GROUP BY 1 groups records by category.
- AVG(price_per_unit) calculates the mean unit price for each
  category.
- ORDER BY ... DESC sorts categories from highest average price to
  lowest.
Concepts: AVG(), GROUP BY, ORDER BY.
Query 6: Calculate total sales and transaction counts by category
SELECT category,
       SUM(total_sale) AS NET_SALES,
       COUNT(*) AS TOTAL_ORDERS
FROM retail_sales_raw
GROUP BY 1;
Business question: How much sales value and how many transaction
records are associated with each category?

How it works:
- GROUP BY 1 creates one result group per category.
- SUM(total_sale) adds the transaction sales values in each
  category.
- COUNT(*) counts the transaction rows in each category.
Concepts: SUM(), COUNT(), GROUP BY.

Interpretation note: COUNT(*) counts rows/transactions in this
table. It does not count distinct customers or necessarily distinct
order IDs unless the data model defines one row per order.
Query 7: Calculate the average age of Beauty customers
SELECT ROUND(AVG(age), 2) AS AVG_AGE
FROM retail_sales_raw
WHERE category = "Beauty";
Business question: What is the average age recorded for customers'
transactions in the Beauty category?

How it works:
- WHERE category = "Beauty" filters to Beauty records.
- AVG(age) calculates the average age across those rows.
- ROUND(..., 2) rounds the result to two decimal places.
Concepts: WHERE, AVG(), ROUND().

Interpretation note: This calculates the average age across Beauty
transaction records. If a customer made multiple Beauty purchases, their
age appears multiple times in the calculation.
Query 8: Find transactions with total sales greater than 1,000
SELECT transactions_id,
       total_sale,
       category
FROM retail_sales_raw
WHERE total_sale > 1000;
Business question: Which transactions have a transaction sale value
greater than 1,000?

How it works:
- The query returns only the transaction ID, sale value, and category.
- WHERE total_sale > 1000 filters out transactions with values of
  1,000 or less.
Concepts: Column selection, comparison operator, WHERE.
Query 9: Count transactions by gender within each category
SELECT category,
       gender,
       COUNT(*) AS TOTAL_TRANSACTIONS
FROM retail_sales_raw
GROUP BY 1, 2
ORDER BY 1;
Business question: How many transaction records are associated with
each gender in each product category?

How it works:
- GROUP BY 1, 2 groups records by both category and gender.
- COUNT(*) counts transaction rows in each category-gender
  combination.
- ORDER BY 1 sorts the output by category.
Concepts: Multiple-column grouping, COUNT(), ORDER BY.
Query 10: Find the month with the highest average sale in each year
SELECT YEAR,
       MONTH,
       AVG_SALE
FROM (
    SELECT YEAR(sale_date) AS YEAR,
           MONTH(sale_date) AS MONTH,
           ROUND(AVG(total_sale), 2) AS AVG_SALE,
           RANK() OVER (
               PARTITION BY YEAR(sale_date)
               ORDER BY AVG(total_sale) DESC
           ) AS SALES_RANK
    FROM retail_sales_raw
    GROUP BY 1, 2
) AS T2
WHERE SALES_RANK = 1;
Business question: Which month had the highest average transaction
sale in each year?

How it works:
1. YEAR(sale_date) extracts the year from each transaction date.
2. MONTH(sale_date) extracts the month number.
3. GROUP BY 1, 2 creates one group for each year-month combination.
4. AVG(total_sale) calculates the average transaction sale for that
   month.
5. RANK() OVER (...) ranks months separately within each year.
6. PARTITION BY YEAR(sale_date) restarts the ranking for each year.
7. ORDER BY AVG(total_sale) DESC gives the highest average sale rank
   1.
8. The outer query filters to SALES_RANK = 1.
Concepts: Subquery, YEAR(), MONTH(), AVG(), ROUND(),
RANK(), OVER(), PARTITION BY.

Important distinction: This query finds the month with the highest
average transaction value, not the month with the highest total
revenue. RANK() can return more than one month for a year if there is
a tie for first place.
Query 11: Find the top five customers by total spending
SELECT customer_id,
       SUM(total_sale) AS TOTAL_SPEND
FROM retail_sales_raw
GROUP BY 1
ORDER BY TOTAL_SPEND DESC
LIMIT 5;
Business question: Who are the five highest-spending customers?

How it works:
- Group transaction rows by customer ID.
- Add each customer's total_sale values.
- Sort the totals from highest to lowest.
- Return the first five results.
Concepts: SUM(), GROUP BY, ORDER BY, LIMIT.

This query is similar to the earlier top-three customer query, but
returns five customers instead of three.
Query 12: Count unique customers in each category
SELECT category,
       COUNT(DISTINCT(customer_id)) AS DISTINCT_CUSTOMERS
FROM retail_sales_raw
GROUP BY category;
Business question: How many different customers purchased from each
product category?

How it works:
- GROUP BY category creates one group for each category.
- COUNT(DISTINCT customer_id) counts each customer only once within
  that category.
- A customer who made multiple purchases in the same category is still
  counted once for that category.
Concepts: COUNT(DISTINCT ...), GROUP BY.

Important distinction: This is a unique-customer count, not a
transaction count. The same customer can be counted in more than one
category if they purchased from multiple categories.
Query 13: Count orders by time-of-day shift
WITH hourly_sales AS (
    SELECT *,
           CASE
               WHEN HOUR(sale_time) < 12 THEN 'MORNING'
               WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
               ELSE 'EVENING'
           END AS SHIFT
    FROM retail_sales_raw
)
SELECT SHIFT,
       COUNT(transactions_id) AS TOTAL_ORDERS
FROM hourly_sales
GROUP BY SHIFT;
Business question: How many transaction records occurred during
morning, afternoon, and evening shifts?

How it works:
1. The CTE hourly_sales creates a temporary named result set.
2. HOUR(sale_time) extracts the hour from each transaction time.
3. CASE assigns a shift:
   - Before 12:00 → MORNING
   - 12:00 through 17:59 → AFTERNOON (the condition uses hour
     values 12 through 17)
   - 18:00 onward → EVENING
4. The outer query groups by SHIFT.
5. COUNT(transactions_id) counts transaction IDs in each shift.
Concepts: CTE (WITH), CASE, HOUR(), COUNT(), GROUP BY.

Boundary note: The actual SQL classifies hour 17 as AFTERNOON, so
17:00--17:59 is afternoon. This differs from the original comment's
example of evening beginning at 17:00. Adjust the CASE condition if
the intended boundary is 17:00.
8. Important Script Review Notes
These notes describe issues visible in the supplied SQL file; they are
not claims about the dataset's actual results.
1. Primary key is added twice: One ALTER TABLE statement declares
   transactions_id INT PRIMARY KEY; a later statement also includes
   ADD PRIMARY KEY (transactions_id). A table can have only one
   primary key. Keep one primary-key declaration when preparing a
   clean, repeatable script.
2. Clean before converting types: The script converts text columns
   to numeric/date/time types before the later blank-value
   normalisation. For reliable staging, handle blanks and validate
   formats before conversion.
3. Customer ID check: The script selects rows with
   customer_id IS NULL, but the shown deletion statement does not
   include customer_id IS NULL.
4. Date format: The first Clothing query uses "YYYY-MM" in
   DATE_FORMAT(). MySQL uses format specifiers such as '%Y-%m'; the
   later Clothing query uses that pattern.
5. Monthly metric: The ranking query ranks monthly average
   transaction sale, not monthly total sales.
6. Shift boundary: The CASE statement puts hour 17 in the
   afternoon shift, while the comment suggests evening starts at 17.
7. No result values included: The SQL file contains queries but no
   saved result tables. Run the queries against the imported dataset
   before adding numerical findings or business conclusions to the
   README.
9. How to Run the Project
1. Install MySQL Server and optionally MySQL Workbench.
2. Clone or download this repository.
3. Import the retail sales dataset into the retail_sales_raw table before executing the data-cleaning and analysis queries.
4. Open the SQL script in MySQL Workbench.
5. Execute the database and table-creation statements.
6. Run the validation and cleaning steps in order, checking the
   results.
7. Run the exploratory queries.
8. Run the business-analysis queries and review the outputs.
The supplied SQL script does not include the source dataset or import
instructions. The raw table must be populated before the later queries
can produce meaningful results. Execute the script in stages and resolve
the script-review issues above before treating it as a fully repeatable
setup.
10. Repository Structure
retail-sales-analysis/
├── README.md
└── SQL - Retail Sales Analysis_utf.sql
If you add a dataset file, place it in a clearly named data/ directory
and document its origin and import steps. Do not upload private or
personally identifiable customer information.
11. Skills Demonstrated
- MySQL database and table creation
- Data validation and cleaning
- Handling NULL and blank values
- Data type conversion
- Exploratory data analysis
- Business-focused SQL analysis
- Aggregations and multi-column grouping
- Date and time analysis
- CTEs and window functions
- Customer and category analysis
Author
Lokesh Kumawat
