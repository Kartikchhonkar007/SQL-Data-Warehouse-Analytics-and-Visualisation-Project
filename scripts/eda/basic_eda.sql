select * from gold.dim_customers;
select * from gold.dim_products;
select * from gold.fact_sales;

-- analysing the gender column
SELECT distinct
gender 
FROM gold.dim_customers;

-- counting customers on the basis of gender
SELECT 
gender,
COUNT(*) AS total_customers
FROM gold.dim_customers
GROUP BY gender;


-- analysing the country column
SELECT distinct
country
FROM gold.dim_customers;

-- counting customers on the basis of country
SELECT 
country,
COUNT(*) AS total_customers
FROM gold.dim_customers
GROUP BY country;

-- counting customers on the basis of country and gender
SELECT 
country,
gender,
COUNT(*) AS total_customers
FROM gold.dim_customers
GROUP BY country,gender;


-- analysing the marital_status column
SELECT distinct
marital_status
FROM gold.dim_customers;

-- counting customers on the basis of marital_status
SELECT 
marital_status,
COUNT(*) AS total_customers
FROM gold.dim_customers
GROUP BY marital_status;


-- deriving max age and min age from customers
SELECT 
MAX(TIMESTAMPDIFF(YEAR,birth_date,now())) AS maximum_age,
MIN(TIMESTAMPDIFF(YEAR,birth_date,now())) AS minimum_age
FROM gold.dim_customers;

-- finding the average age of customers
SELECT
ROUND(AVG(TIMESTAMPDIFF(YEAR,birth_date,now())),2) AS average_age
FROM gold.dim_customers;


-- unique categories of products
SELECT DISTINCT
category 
FROM gold.dim_products;

-- no. of products in each category
SELECT
category ,
COUNT(*) AS total
FROM gold.dim_products
GROUP BY category;

-- unique subcategories of products
SELECT DISTINCT
subcategory 
FROM gold.dim_products;

-- no. of products in each subcategory
SELECT
subcategory ,
COUNT(*) AS total
FROM gold.dim_products
GROUP BY subcategory;

-- no. of products that need maintenance
SELECT
COUNT(*) AS require_maintenance
FROM gold.dim_products
WHERE maintenance='Yes'
GROUP BY maintenance; 

-- no. of products that do not need maintenance
SELECT
COUNT(*) AS require_maintenance
FROM gold.dim_products
WHERE maintenance='No'
GROUP BY maintenance; 


-- filtering out historical data
SELECT
*
FROM gold.dim_products
WHERE end_date IS NOT NULL;

-- unique product line
SELECT DISTINCT
product_line
FROM gold.dim_products;

-- no. of products in product line
SELECT DISTINCT
product_line,
COUNT(*) AS total
FROM gold.dim_products
GROUP BY product_line;

-- counting number of order per customer
SELECT
customer_key,
COUNT(*) as total
FROM gold.fact_sales
GROUP BY customer_key;

-- counting number of order per product
SELECT
product_key,
COUNT(*) as total
FROM gold.fact_sales
GROUP BY product_key;

-- latest and earliest order
SELECT
MAX(order_date) AS latest_order,
MIN(order_date) AS earliest_order
FROM gold.fact_sales;


-- finding number of orders for each country
SELECT
dc.country,
COUNT(o.order_number) AS total_orders
FROM gold.dim_customers dc
LEFT JOIN (
SELECT DISTINCT order_number, customer_key
FROM gold.fact_sales
) o
ON dc.customer_key = o.customer_key
GROUP BY dc.country;

-- calculating total sales of each country
SELECT
dc.country,
SUM(fc.sales) AS total_sales
FROM gold.fact_sales fc
 JOIN gold.dim_customers dc
ON fc.customer_key=dc.customer_key
GROUP BY dc.country;

-- calculating average sales of each country
SELECT
dc.country,
ROUND(AVG(fc.sales),2) AS average_sales
FROM gold.fact_sales fc
 JOIN gold.dim_customers dc
ON fc.customer_key=dc.customer_key
GROUP BY dc.country;

-- counting number of orders for each age
SELECT
TIMESTAMPDIFF(YEAR,dc.birth_date,NOW()) AS age,
COUNT(o.order_number) AS total_orders
FROM gold.dim_customers dc
LEFT JOIN (
SELECT DISTINCT order_number, customer_key
FROM gold.fact_sales
) o
ON dc.customer_key = o.customer_key
GROUP BY age;

-- counting number of orders for each gender
SELECT
dc.gender,
COUNT(o.order_number) AS total_orders
FROM gold.dim_customers dc
LEFT JOIN (
SELECT DISTINCT order_number, customer_key
FROM gold.fact_sales
) o
ON dc.customer_key = o.customer_key
GROUP BY dc.gender;


select * from gold.fact_sales;

-- count number of single customer who bought Touring related products
SELECT
COUNT(DISTINCT dc.customer_key) as total_customers
FROM
gold.fact_sales fc
LEFT JOIN gold.dim_products dp ON fc.product_key=dp.product_key
LEFT JOIN gold.dim_customers dc ON dc.customer_key=fc.customer_key
WHERE dp.product_line='Touring' AND dc.marital_status='Single';

-- ranking countries based on sales
SELECT
dc.country,
SUM(fc.sales) AS total_sales,
RANK() OVER(ORDER BY SUM(fc.sales) desc) AS country_rank
FROM gold.fact_sales fc
 JOIN gold.dim_customers dc
ON fc.customer_key=dc.customer_key
GROUP BY dc.country;

-- top 5 customer based on sales
SELECT * FROM (
SELECT
fs.customer_key,
dc.first_name,
dc.last_name,
SUM(fs.sales) AS total_sales,
RANK() OVER(ORDER BY SUM(fs.sales) desc) AS customer_rank
FROM gold.fact_sales fs
JOIN gold.dim_customers dc
ON fs.customer_key=dc.customer_key
GROUP BY fs.customer_key,dc.first_name,dc.last_name )t
WHERE customer_rank <=5;


