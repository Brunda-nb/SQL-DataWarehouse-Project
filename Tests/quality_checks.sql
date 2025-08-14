/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'silver.crm_cust_info'
-- ====================================================================

-- #1.check for null of duplicates in primary key
%%sql
select count(*),cst_id
from bronze_crm_cust_info
group by cst_id
having count(*) > 1 or cst_id is null;

-- #2. Check for unwanted spaces in columns  (text mainly).
 %%sql
 select count(1)
 from bronze_crm_cust_info
 where cst_firstname != trim(cst_firstname);
 
 %%sql
 select count(1)
 from bronze_crm_cust_info
 where cst_lastname != trim(cst_lastname);

 %%sql
 select count(1)
 from bronze_crm_cust_info
 where cst_gndr != trim(cst_gndr);

-- ====================================================================
-- Checking 'silver.crm_prd_info'
-- ====================================================================

-- #1. Checking for primary key duplicates & nulls.
%%sql
select count(*) , prd_id
from bronze_crm_prd_info
group by prd_id
having count(*) > 1 or prd_id is null;

-- #2. Check for unwanted spaces in columns  (text mainly).
%%sql
 select count(1)
 from bronze_crm_prd_info
 where prd_nm != trim(prd_nm);

-- #3. Check for null or negative numbers . Used Coalesce() to replace null values to 0.
%%sql
select prd_cost,prd_id
from bronze_crm_prd_info
where prd_cost < 0 or prd_cost is null;

-- #4. Check the cardinality for data normalization.
%%sql
select distinct prd_line
from bronze_crm_prd_info;

-- #5 .Chcek for invalid dates
%%sql
select *
from bronze_crm_prd_info
where prd_start_dt > prd_end_dt or prd_end_dt is null  or prd_start_dt is null ;

-- ====================================================================
-- Checking 'silver.crm_sales_details'
-- ====================================================================

-- #1. Dates with 0 or null --Chcek with all date columns
%%sql
select
    nullif(sls_order_dt,0) sls_order_dt
 from bronze_crm_sales_details
 where sls_order_dt <= 0
 or LENGTH(sls_order_dt) != 8
 or sls_order_dt > 20500101 --checking the boundry conditions,, ex. if company is established in 2000 & till present,, let the boundry condition be 1999-2050.
 or sls_order_dt < 19900101;

%%sql
select
    nullif(sls_ship_dt,0) sls_ship_dt
 from bronze_crm_sales_details
 where sls_ship_dt <= 0
 or LENGTH(sls_ship_dt) != 8
 or sls_ship_dt > 20500101 --checking the boundry conditions,, ex. if company is established in 2000 & till present,, let the boundry condition be 1999-2050.
 or sls_ship_dt < 19900101;

%%sql
select
    nullif(sls_due_dt,0) sls_due_dt
 from bronze_crm_sales_details
 where sls_due_dt <= 0
 or LENGTH(sls_due_dt) != 8
 or sls_due_dt > 20500101 --checking the boundry conditions,, ex. if company is established in 2000 & till present,, let the boundry condition be 1999-2050.
 or sls_due_dt < 19900101;

-- #2. Order date should be always smaller than shipping date and so is due date,,
%%sql
select *
from  bronze_crm_sales_details
where sls_ship_dt < sls_order_dt or sls_order_dt > sls_due_dt;

-- #3. Check for the business rule.
%%sql
select distinct *
from bronze_crm_sales_details
where sls_sales != sls_quantity * sls_price
or sls_sales is null or sls_quantity is null or sls_price is null
or sls_sales <= 0 or sls_quantity <= 0 or sls_price <= 0 ;

-- ====================================================================
-- Checking 'silver.erp_cust_az12'
-- ====================================================================

-- #1. Check if we can join the table silver_crm_cust_info
%%sql
select
CID,
case  when CID like 'NAS%' then SUBSTRING(CID,4,LENGTH(CID))
      else CID
end CID,
BDATE,
GEN
from bronze_erp_cust_az12
where case  when CID like 'NAS%' then SUBSTRING(CID,4,LENGTH(CID))
      else CID
end not in (select distinct cst_key from silver_crm_cust_info);

-- #2. Check the bdate columns with extreme boundry conditions (bdate from 19's & greater than current date).
%%sql
select BDATE
from bronze_erp_cust_az12
where BDATE < '1924-01-01' or BDATE > date(CURRENT_DATE);

-- #3. Check cardinality
%%sql
select distinct GEN
from bronze_erp_cust_az12;

-- ====================================================================
-- Checking 'silver.erp_loc_a101'
-- ====================================================================

-- #1.Check if all the primary are present in crm table to join.
%%sql
select
replace(CID,'-','') CID
from bronze_erp_loc_a101 where replace(CID,'-','')  not in (
  select cst_key from silver_crm_cust_info
);

  
-- #2. Chceck data cardinality for data standardization
%%sql
select distinct CNTRY
from bronze_erp_loc_a101;

-- ====================================================================
-- Checking 'silver.erp_px_cat_g1v2'
-- ====================================================================
  
-- #1.Check unwanted spaces
%%sql
select *
from bronze_erp_px_cat_g1v2
where SUBCAT != trim(SUBCAT) or CAT != TRIM(CAT) or MAINTENANCE != TRIM(MAINTENANCE);

-- #2.Check cardinality.
%%sql
select distinct CAT
from bronze_erp_px_cat_g1v2;

%%sql
select distinct SUBCAT
from bronze_erp_px_cat_g1v2;

%%sql
select distinct MAINTENANCE
from bronze_erp_px_cat_g1v2;
