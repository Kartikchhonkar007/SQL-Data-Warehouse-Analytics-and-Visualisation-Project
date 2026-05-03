 /*  1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
*/
DROP VIEW IF EXISTS gold.report_customers;
CREATE VIEW gold.report_customers AS

with cte_customers_details as(
		select fs.customer_key,customer_id ,timestampdiff(month,MIN(order_date),MAX(order_date)) as lifespan ,
		sum(sales) as total_sales,
		sum(quantity) as total_quantity,
		count(distinct order_number) as total_orders,
		count(distinct product_key) as total_products,
		max(order_date) as latest_order
		from gold.fact_sales fs join gold.dim_customers dc
		on fs.customer_key=dc.customer_key
		where order_date is not null 
		 group by customer_id,customer_key
)
select 
		dc.customer_key,
		dc.customer_id,
		customer_number,
		CONCAT(first_name,' ',last_name) as name,
		gender,
		timestampdiff(year,birth_date,now()) as age,
		CASE
			 WHEN timestampdiff(year,birth_date,now()) < 20 THEN 'Under 20'
			 WHEN timestampdiff(year,birth_date,now()) between 20 and 29 THEN '20-29'
			 WHEN timestampdiff(year,birth_date,now()) between 30 and 39 THEN '30-39'
			 WHEN timestampdiff(year,birth_date,now()) between 40 and 50 THEN '40-50'
			 ELSE 'above 50'
		END AS age_group,
		country,
		total_orders,
		total_sales,
		total_quantity,
		total_products,
		lifespan,
		CASE WHEN lifespan >= 12 AND total_sales >5000 THEN 'VIP'
			 WHEN lifespan >=12 AND total_sales <=5000 THEN 'Regular'
			 ELSE 'New'
		END  as customer_category,
		CASE WHEN lifespan=0 THEN total_sales
			ELSE ROUND(total_sales/lifespan,2)
		END as avg_monthly_spend,
		CASE WHEN total_sales=0 THEN 0
			ELSE ROUND(total_sales/total_orders,2)
		END as avg_order_value,
		timestampdiff(month,latest_order,now()) as recency
		from
gold.dim_customers dc 
left join cte_customers_details cls
on dc.customer_key=cls.customer_key 
