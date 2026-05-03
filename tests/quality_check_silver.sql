
-- ---------------------------------------------------------------------------------------------------------

select * from silver.crm_cust_info;

select count(*) from silver.crm_cust_info;

select distinct cst_gndr from silver.crm_cust_info;

select distinct cst_marital_status from silver.crm_cust_info;

select cst_id from silver.crm_cust_info
where cst_firstname != TRIM(cst_firstname);

select cst_id from silver.crm_cust_info
where cst_lastname != TRIM(cst_lastname);

-- ---------------------------------------------------------------------------------------------------------
select * from silver.crm_prd_info;

select COUNT(*) from silver.crm_prd_info;

select distinct prd_line from silver.crm_prd_info;

select distinct prd_cat_id from silver.crm_prd_info;

select prd_id,prd_key from silver.crm_prd_info
where prd_start_dt>prd_end_dt;

select distinct prd_cat_id from silver.crm_prd_info;

select prd_id from silver.crm_prd_info
where prd_nm != TRIM(prd_nm);

-- ---------------------------------------------------------------------------------------------------------
select * from silver.crm_sales_details;

select COUNT(*) from silver.crm_sales_details;

select sls_ord_num from silver.crm_sales_details where sls_sales != sls_price*sls_quantity;
SELECT * FROM silver.crm_sales_details WHERE sls_sales < 0;


select * from silver.crm_sales_details where sls_cust_id NOT IN (SELECT cst_id from silver.crm_cust_info);
select * from silver.crm_sales_details where sls_prd_key IN (SELECT prd_id from silver.crm_prd_info);

select * from silver.crm_sales_details s inner join silver.crm_prd_info ss ON s.sls_prd_key=ss.prd_key;

-- ---------------------------------------------------------------------------------------------------------
select * from silver.erp_cust_az12;

select * from silver.erp_cust_az12 ec inner join silver.crm_cust_info ci ON ec.cid=ci.cst_key;

select * from silver.erp_cust_az12 where cid NOT IN (select cst_key from silver.crm_cust_info);

select bdate from silver.erp_cust_az12 where bdate>NOW();

select DISTINCT gen from silver.erp_cust_az12;

-- ---------------------------------------------------------------------------------------------------------

SELECT * FROM silver.erp_loc_a101;

select * from silver.erp_loc_a101 where cid NOT IN (select cst_key from silver.crm_cust_info);

select distinct cntry FROM silver.erp_loc_a101;

-- ---------------------------------------------------------------------------------------------------------
SELECT * FROM silver.erp_px_cat_g1v2;

select * from silver.erp_px_cat_g1v2 where id NOT IN (select prd_cat_id from silver.crm_prd_info);

select * from silver.erp_px_cat_g1v2 where id='CO_PD';

select * from silver.crm_prd_info where prd_cat_id='CO_PD';

select distinct subcat from silver.erp_px_cat_g1v2;

select distinct maintenance from silver.erp_px_cat_g1v2;

-- ---------------------------------------------------------------------------------------------------------
 -- FIXING MISSING CATEGORY
 INSERT INTO silver.erp_px_cat_g1v2(id,cat) VALUES('CO_PE','Components')
 WHERE p.product_key IS NULL
