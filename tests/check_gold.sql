select * from gold.dim_customers;
select * from gold.dim_products;
select * from gold.fact_sales;

select * from 
  gold.fact_sales fc
 LEFT JOIN gold.dim_customers dc
  ON fc.customer_key=dc.customer_key
LEFT JOIN gold.dim_products dp
  ON fc.product_key=dp.product_key;
