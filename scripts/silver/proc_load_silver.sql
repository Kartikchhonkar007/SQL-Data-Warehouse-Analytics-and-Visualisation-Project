-- =========================================
-- SILVER LAYER
-- =========================================
DROP PROCEDURE IF EXISTS silver.load_silver;
DELIMITER //
CREATE PROCEDURE silver.load_silver()
BEGIN
-- =========================================
-- CRM - CUSTOMER INFO
-- =========================================
TRUNCATE TABLE silver.crm_cust_info;

INSERT INTO silver.crm_cust_info(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date)
SELECT
	cst_id,
	cst_key,
	TRIM(REPLACE(REPLACE(REPLACE(cst_firstname, '\r',''), '\n',''), '\t','')) AS cst_firstname,
	TRIM(REPLACE(REPLACE(REPLACE(cst_lastname, '\r',''), '\n',''), '\t','')) AS cst_lastname,
	CASE 
		WHEN UPPER(TRIM(REPLACE(REPLACE(REPLACE(cst_marital_status, '\r',''), '\n',''), '\t',''))) = 'M' THEN 'Married'
		WHEN UPPER(TRIM(REPLACE(REPLACE(REPLACE(cst_marital_status, '\r',''), '\n',''), '\t',''))) = 'S' THEN 'Single'
		ELSE 'n/a'
	END AS cst_marital_status,
	CASE 
		WHEN UPPER(TRIM(REPLACE(REPLACE(REPLACE(cst_gndr, '\r',''), '\n',''), '\t',''))) = 'M' THEN 'Male'
		WHEN UPPER(TRIM(REPLACE(REPLACE(REPLACE(cst_gndr, '\r',''), '\n',''), '\t',''))) = 'F' THEN 'Female'
		ELSE 'n/a'
	END AS cst_gndr,
	cst_create_date
FROM (
	SELECT *,
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS rn
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
	) t
WHERE rn = 1;

-- =========================================
-- CRM - PRODUCT INFO
-- =========================================

TRUNCATE TABLE silver.crm_prd_info;

INSERT INTO silver.crm_prd_info(
	prd_id,
	prd_cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt)
SELECT
	prd_id,
	REPLACE(SUBSTR(prd_key,1,5),'-','_') AS prd_cat_id,
	TRIM(REPLACE(REPLACE(REPLACE(SUBSTR(prd_key,7,LENGTH(prd_key)), '\r',''),'\n',''),'\t','')) AS prd_key,
	TRIM(REPLACE(REPLACE(REPLACE(prd_nm, '\r',''), '\n',''), '\t','')) AS prd_nm,
	CASE 
		WHEN prd_cost < 0 OR prd_cost IS NULL THEN 0
		ELSE prd_cost
	END AS prd_cost,
	CASE 
		WHEN UPPER(TRIM(REPLACE(REPLACE(REPLACE(prd_line, '\r',''), '\n',''), '\t',''))) = 'R' THEN 'Road'
		WHEN UPPER(TRIM(REPLACE(REPLACE(REPLACE(prd_line, '\r',''), '\n',''), '\t',''))) = 'S' THEN 'Other Sales'
		WHEN UPPER(TRIM(REPLACE(REPLACE(REPLACE(prd_line, '\r',''), '\n',''), '\t',''))) = 'M' THEN 'Mountain'
		WHEN UPPER(TRIM(REPLACE(REPLACE(REPLACE(prd_line, '\r',''), '\n',''), '\t',''))) = 'T' THEN 'Touring'
		ELSE 'n/a'
	END AS prd_line,
	CAST(prd_start_dt AS DATE),
	CAST(
		LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) 
		- INTERVAL 1 DAY
		AS DATE
	) AS prd_end_dt
FROM bronze.crm_prd_info;

-- =========================================
-- CRM - SALES DETAILS
-- =========================================

TRUNCATE TABLE silver.crm_sales_details;

INSERT INTO silver.crm_sales_details(
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
    sls_price,
	sls_quantity,
	sls_sales
)
SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE 
		WHEN LENGTH(sls_order_dt) != 8 OR sls_order_dt = 0 THEN NULL
		ELSE STR_TO_DATE(sls_order_dt,'%Y%m%d')
	END AS sls_order_dt,
	CASE 
		WHEN LENGTH(sls_ship_dt) != 8 OR sls_ship_dt = 0 THEN NULL
		ELSE STR_TO_DATE(sls_ship_dt,'%Y%m%d')
	END AS sls_ship_dt,

	CASE 
		WHEN LENGTH(sls_due_dt) != 8 OR sls_due_dt = 0 THEN NULL
		ELSE STR_TO_DATE(sls_due_dt,'%Y%m%d')
	END AS sls_due_dt,
	fixed_price,
	sls_quantity,
	CASE 
		WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales != ABS(sls_quantity *fixed_price)
		THEN ABS(sls_quantity * fixed_price)
		ELSE ABS(sls_sales)
	END AS sls_sales
FROM (
	SELECT
		TRIM(REPLACE(REPLACE(REPLACE(sls_ord_num, '\r',''), '\n',''), '\t','')) AS sls_ord_num,
		TRIM(REPLACE(REPLACE(REPLACE(sls_prd_key, '\r',''), '\n',''), '\t','')) AS sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		CASE 
			WHEN sls_price <= 0 OR sls_price IS NULL
			THEN abs(sls_sales) / NULLIF(sls_quantity,0)
			ELSE abs(sls_price)
		END AS fixed_price
	FROM bronze.crm_sales_details
) t;

-- =========================================
-- ERP - CUSTOMER
-- =========================================

TRUNCATE TABLE silver.erp_cust_az12;

INSERT INTO silver.erp_cust_az12(
	cid,
	bdate,
	gen)
SELECT
	CASE
	WHEN cid LIKE 'NAS%' THEN SUBSTR(cid,4,LENGTH(cid))
	ELSE cid
	END,
	CASE 
		WHEN bdate > NOW() THEN NULL
		ELSE bdate
	END,
	CASE 
		WHEN UPPER(TRIM(REPLACE(REPLACE(REPLACE(gen, '\r',''), '\n',''), '\t',''))) IN ('F','FEMALE') THEN 'Female'
		WHEN UPPER(TRIM(REPLACE(REPLACE(REPLACE(gen, '\r',''), '\n',''), '\t',''))) IN ('M','MALE') THEN 'Male'
		ELSE 'n/a'
	END
FROM bronze.erp_cust_az12;


-- =========================================
-- ERP - LOCATION
-- =========================================

TRUNCATE TABLE silver.erp_loc_a101;

INSERT INTO silver.erp_loc_a101(
	cid,
	cntry)
SELECT
	REPLACE(cid,'-',''),
	CASE 
		WHEN cleaned_cntry IN ('US','USA','UNITED STATES') THEN 'United States'
		WHEN cleaned_cntry IN ('DE','GERMANY') THEN 'Germany'
		WHEN cleaned_cntry = 'AUSTRALIA' THEN 'Australia'
		WHEN cleaned_cntry = 'CANADA' THEN 'Canada'
		WHEN cleaned_cntry = 'UNITED KINGDOM' THEN 'United Kingdom'
		WHEN cleaned_cntry = 'FRANCE' THEN 'France'
		WHEN cleaned_cntry = '' OR cleaned_cntry IS NULL THEN 'n/a'
		ELSE 'n/a'
	END
FROM (
	SELECT
	cid,
	UPPER(TRIM(REPLACE(REPLACE(REPLACE(cntry, '\r',''), '\n',''), '\t',''))) AS cleaned_cntry
	FROM bronze.erp_loc_a101
	) t;


-- =========================================
-- ERP - PRODUCT CATEGORY
-- =========================================

TRUNCATE TABLE silver.erp_px_cat_g1v2;

INSERT INTO silver.erp_px_cat_g1v2(
	id,
	cat,
	subcat,
	maintenance)

SELECT
	id,
	TRIM(REPLACE(REPLACE(REPLACE(cat, '\r',''), '\n',''), '\t','')),
	TRIM(REPLACE(REPLACE(REPLACE(subcat, '\r',''), '\n',''), '\t','')),
	TRIM(REPLACE(REPLACE(REPLACE(maintenance, '\r',''), '\n',''), '\t',''))

FROM bronze.erp_px_cat_g1v2;

-- =========================================
-- =========================================
END //
DELIMITER ;

CALL silver.load_silver()
