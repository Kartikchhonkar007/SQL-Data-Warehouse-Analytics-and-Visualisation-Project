

DELIMITER //
CREATE PROCEDURE gold.load_gold()
BEGIN
-- =========================================
-- VIEW-DIMENSION_CUSTOMERS
-- =========================================

DROP VIEW IF EXISTS gold.dim_customers;

CREATE VIEW gold.dim_customers AS
SELECT 
		ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,-- SURROGATE KEY
		ci.cst_id AS customer_id,
		ci.cst_key AS customer_number,
		ci.cst_firstname AS first_name,
		ci.cst_lastname AS last_name,
		ca.bdate AS birth_date,
		CASE WHEN ci.cst_gndr !='n/a' THEN ci.cst_gndr
			 ELSE COALESCE(ca.gen,'n/a')
		END AS gender,  -- assuming data from cust_info is correct
		ci.cst_marital_status AS marital_status,
		la.cntry AS country,
		ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
	LEFT JOIN silver.erp_cust_az12 ca
	ON ci.cst_key=ca.cid
	LEFT JOIN silver.erp_loc_a101 la
	ON ci.cst_key=la.cid;
    
    
-- =========================================
-- VIEW-DIMENSION_PRODUCTS
-- =========================================

DROP VIEW IF EXISTS gold.dim_products;

CREATE VIEW gold.dim_products AS
SELECT 
ROW_NUMBER() OVER(ORDER BY prd_start_dt, prd_key) AS product_key,-- SURROGATE KEY
		pi.prd_id AS product_id,
		pi.prd_key AS product_number,
		pi.prd_nm AS product_name,
		pi.prd_cat_id AS category_id,
		pc.cat AS category,
		pc.subcat AS subcategory,
		pc.maintenance AS maintenance,
		pi.prd_cost AS cost,
		pi.prd_line AS product_line,
		pi.prd_start_dt AS start_date,
		pi.prd_end_dt AS end_date
FROM silver.crm_prd_info pi
	LEFT JOIN silver.erp_px_cat_g1v2 pc
	ON pi.prd_cat_id=pc.id
    WHERE pi.prd_end_dt IS NULL;



-- =========================================
-- VIEW-FACT_SALES
-- =========================================
DROP VIEW IF EXISTS gold.fact_sales;

CREATE VIEW gold.fact_sales AS
SELECT
		csd.sls_ord_num AS order_number,
		dp.product_key AS product_key,
		dc.customer_key AS customer_key,
		csd.sls_order_dt AS order_date,
		csd.sls_ship_dt AS shipping_date,
		csd.sls_due_dt AS due_date,
		csd.sls_sales AS sales,
		csd.sls_quantity AS quantity,
		csd.sls_price AS price
FROM silver.crm_sales_details csd
	LEFT JOIN gold.dim_customers dc
	ON csd.sls_cust_id=dc.customer_id
	LEFT JOIN gold.dim_products dp
	ON csd.sls_prd_key=dp.product_number;
-- =========================================
-- =========================================
END //
DELIMITER ;

CALL gold.load_gold();
