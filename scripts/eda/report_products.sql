/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
-- =============================================================================
DROP VIEW IF EXISTS gold.report_products;

CREATE VIEW gold.report_products AS

with cte_product_details as(
		select 
		fs.product_key,
		product_id,
		count(distinct order_number) as total_orders,
		sum(sales) as total_sales,
		sum(quantity) as total_quantity,
		count(distinct customer_key) as total_customers,
		MAX(order_date) as latest_order,
		MIN(order_date) as first_order,
		CASE 
			WHEN sum(sales) >50000 THEN 'High Performance'
			WHEN sum(sales) >=10000 THEN 'Mid Range Performance'
			ELSE 'Low Performance'
			END as product_segment
		from gold.fact_sales fs
		 join  gold.dim_products dp
		on dp.product_key=fs.product_key
		where fs.order_date IS NOT NULL
		group by product_id,product_key
)
select
		dp.product_key,
		dp.product_id,
		product_number,
		product_name,
		category_id,
		category,
		subcategory,
		maintenance,
		cost,
		product_line,
		total_orders,
		total_sales,
		product_segment,
		total_quantity,
		total_customers,
		timestampdiff(month,first_order,latest_order) as lifespan,
		CASE WHEN timestampdiff(month,first_order,latest_order)=0 THEN total_sales
			 ELSE ROUND(total_sales/timestampdiff(month,first_order,latest_order),2) 
		END as avg_monthly_revenue,
		CASE WHEN total_orders=0 THEN 0
			 ELSE ROUND(total_sales/total_orders,2)
		END as avg_order_revenue,
		CASE WHEN total_quantity=0 THEN 0
			ELSE ROUND(total_sales/total_quantity,2)
		END as avg_selling_price,
		timestampdiff(month,latest_order,now()) as recency
from gold.dim_products dp
left join cte_product_details cps
on cps.product_key=dp.product_key;
