-- =========================================
-- BRONZE LAYER
-- =========================================

CREATE DATABASE IF NOT EXISTS bronze;

-- =========================================
-- CRM - CUSTOMER INFO
-- =========================================
TRUNCATE TABLE bronze.crm_cust_info;

LOAD DATA LOCAL INFILE 'C:/Users/dmanc/Desktop/WORK/SQL_PROJECT/datawarehouse/sql-data-warehouse-project-main/datasets/source_crm/cust_info.csv'
INTO TABLE bronze.crm_cust_info
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@cst_id,@cst_key,@cst_firstname,@cst_lastname,@cst_marital_status,@cst_gndr,@cst_create_date)
SET
cst_id = CASE WHEN TRIM(LOWER(@cst_id)) IN ('','null') THEN NULL ELSE @cst_id END,
cst_key = CASE WHEN TRIM(LOWER(@cst_key)) IN ('','null') THEN NULL ELSE @cst_key END,
cst_firstname = CASE WHEN TRIM(LOWER(@cst_firstname)) IN ('','null') THEN NULL ELSE @cst_firstname END,
cst_lastname = CASE WHEN TRIM(LOWER(@cst_lastname)) IN ('','null') THEN NULL ELSE @cst_lastname END,
cst_marital_status = CASE WHEN TRIM(LOWER(@cst_marital_status)) IN ('','null') THEN NULL ELSE @cst_marital_status END,
cst_gndr = CASE WHEN TRIM(LOWER(@cst_gndr)) IN ('','null') THEN NULL ELSE @cst_gndr END,
cst_create_date = CASE WHEN TRIM(LOWER(@cst_create_date)) IN ('','null') THEN NULL ELSE @cst_create_date END;

-- =========================================
-- CRM - PRODUCT INFO
-- =========================================
TRUNCATE TABLE bronze.crm_prd_info;

LOAD DATA LOCAL INFILE 'C:/Users/dmanc/Desktop/WORK/SQL_PROJECT/datawarehouse/sql-data-warehouse-project-main/datasets/source_crm/prd_info.csv'
INTO TABLE bronze.crm_prd_info
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@prd_id,@prd_key,@prd_nm,@prd_cost,@prd_line,@prd_start_dt,@prd_end_dt)
SET
prd_id = CASE WHEN TRIM(LOWER(@prd_id)) IN ('','null') THEN NULL ELSE @prd_id END,
prd_key = CASE WHEN TRIM(LOWER(@prd_key)) IN ('','null') THEN NULL ELSE @prd_key END,
prd_nm = CASE WHEN TRIM(LOWER(@prd_nm)) IN ('','null') THEN NULL ELSE @prd_nm END,
prd_cost = CASE WHEN TRIM(LOWER(@prd_cost)) IN ('','null') THEN NULL ELSE @prd_cost END,
prd_line = CASE WHEN TRIM(LOWER(@prd_line)) IN ('','null') THEN NULL ELSE @prd_line END,
prd_start_dt = CASE WHEN TRIM(LOWER(@prd_start_dt)) IN ('','null') THEN NULL ELSE @prd_start_dt END,
prd_end_dt = CASE WHEN TRIM(LOWER(@prd_end_dt)) IN ('','null') THEN NULL ELSE @prd_end_dt END;

-- =========================================
-- CRM - SALES DETAILS
-- =========================================
TRUNCATE TABLE bronze.crm_sales_details;

LOAD DATA LOCAL INFILE 'C:/Users/dmanc/Desktop/WORK/SQL_PROJECT/datawarehouse/sql-data-warehouse-project-main/datasets/source_crm/sales_details.csv'
INTO TABLE bronze.crm_sales_details
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@sls_ord_num,@sls_prd_key,@sls_cust_id,@sls_order_dt,@sls_ship_dt,@sls_due_dt,@sls_sales,@sls_quantity,@sls_price)
SET
sls_ord_num = CASE WHEN TRIM(LOWER(@sls_ord_num)) IN ('','null') THEN NULL ELSE @sls_ord_num END,
sls_prd_key = CASE WHEN TRIM(LOWER(@sls_prd_key)) IN ('','null') THEN NULL ELSE @sls_prd_key END,
sls_cust_id = CASE WHEN TRIM(LOWER(@sls_cust_id)) IN ('','null') THEN NULL ELSE @sls_cust_id END,
sls_order_dt = CASE WHEN TRIM(LOWER(@sls_order_dt)) IN ('','null') THEN NULL ELSE @sls_order_dt END,
sls_ship_dt = CASE WHEN TRIM(LOWER(@sls_ship_dt)) IN ('','null') THEN NULL ELSE @sls_ship_dt END,
sls_due_dt = CASE WHEN TRIM(LOWER(@sls_due_dt)) IN ('','null') THEN NULL ELSE @sls_due_dt END,
sls_sales = CASE WHEN TRIM(LOWER(@sls_sales)) IN ('','null') THEN NULL ELSE @sls_sales END,
sls_quantity = CASE WHEN TRIM(LOWER(@sls_quantity)) IN ('','null') THEN NULL ELSE @sls_quantity END,
sls_price = CASE WHEN TRIM(LOWER(@sls_price)) IN ('','null') THEN NULL ELSE @sls_price END;

-- =========================================
-- ERP - CUSTOMER
-- =========================================
TRUNCATE TABLE bronze.erp_cust_az12;

LOAD DATA LOCAL INFILE 'C:/Users/dmanc/Desktop/WORK/SQL_PROJECT/datawarehouse/sql-data-warehouse-project-main/datasets/source_erp/CUST_AZ12.csv'
INTO TABLE bronze.erp_cust_az12
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@cid,@bdate,@gen)
SET
cid = CASE WHEN TRIM(LOWER(@cid)) IN ('','null') THEN NULL ELSE @cid END,
bdate = CASE WHEN TRIM(LOWER(@bdate)) IN ('','null') THEN NULL ELSE @bdate END,
gen = CASE WHEN TRIM(LOWER(@gen)) IN ('','null') THEN NULL ELSE @gen END;

-- =========================================
-- ERP - LOCATION
-- =========================================
TRUNCATE TABLE bronze.erp_loc_a101;

LOAD DATA LOCAL INFILE 'C:/Users/dmanc/Desktop/WORK/SQL_PROJECT/datawarehouse/sql-data-warehouse-project-main/datasets/source_erp/LOC_A101.csv'
INTO TABLE bronze.erp_loc_a101
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@cid,@cntry)
SET
cid = CASE WHEN TRIM(LOWER(@cid)) IN ('','null') THEN NULL ELSE @cid END,
cntry = CASE WHEN TRIM(LOWER(@cntry)) IN ('','null') THEN NULL ELSE @cntry END;

-- =========================================
-- ERP - PRODUCT CATEGORY
-- =========================================
TRUNCATE TABLE bronze.erp_px_cat_g1v2;

LOAD DATA LOCAL INFILE 'C:/Users/dmanc/Desktop/WORK/SQL_PROJECT/datawarehouse/sql-data-warehouse-project-main/datasets/source_erp/PX_CAT_G1V2.csv'
INTO TABLE bronze.erp_px_cat_g1v2
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@id,@cat,@subcat,@maintenance)
SET
id = CASE WHEN TRIM(LOWER(@id)) IN ('','null') THEN NULL ELSE @id END,
cat = CASE WHEN TRIM(LOWER(@cat)) IN ('','null') THEN NULL ELSE @cat END,
subcat = CASE WHEN TRIM(LOWER(@subcat)) IN ('','null') THEN NULL ELSE @subcat END,
maintenance = CASE WHEN TRIM(LOWER(@maintenance)) IN ('','null') THEN NULL ELSE @maintenance END;

