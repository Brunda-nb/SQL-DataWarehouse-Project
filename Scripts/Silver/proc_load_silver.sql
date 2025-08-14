/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

%%sql
DROP TABLE IF EXISTS silver_crm_cust_info;
Insert into silver_crm_cust_info (
  cst_id,
  cst_key,
  cst_firstname,
  cst_lastname,
  cst_marital_status,
  cst_gndr,
  cst_create_date
  )
select
  cst_id,
  cst_key,
  TRIM(cst_firstname),  --Removing the spaces
  TRIM(cst_lastname),   --Removing the spaces
  case when UPPER(TRIM(cst_marital_status)) = 'M' then 'Married'
       when UPPER(TRIM(cst_marital_status)) = 'S' then 'Single'
       else 'n/a'
  end cst_marital_status  , --Data Normalization
  case when UPPER(trim(cst_gndr)) = 'F' then 'Female'
       when UPPER(trim(cst_gndr)) = 'M' then 'Male'
       else 'n/a'
  end cst_gndr ,            --Data Normalization
  cst_create_date
from (
    select *,
    row_number() over(partition by cst_id order by cst_create_date desc) flag_last
    from bronze_crm_cust_info
    where cst_id is not null
)t where flag_last = 1 --Select the most recent record per customer
;

DROP TABLE IF EXISTS silver_crm_prd_info;
INSERT INTO silver_crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
    )

select
prd_id ,
replace(substring(prd_key , 1 , 5) , '-' , '_' ) cat_id ,
SUBSTRING(prd_key,7,LENGTH(prd_key)) prd_key ,
prd_nm ,
COALESCE(prd_cost ,0) prd_cost,
case UPPER(trim(prd_line))
     when  'R' then 'Road'
     when  'S' then 'Other Sales'
     when  'M' then 'Mountain'
     when  'T' then 'Touring'
     else 'n/a'
end prd_line ,
prd_start_dt ,
date (lead(prd_start_dt) over(partition by prd_key order by prd_start_dt ) ,'-1 day' ) prd_end_dt
from bronze_crm_prd_info ;

DROP TABLE IF EXISTS silver_crm_sales_details;
INSERT INTO silver_crm_sales_details (
  sls_ord_num ,
  sls_prd_key ,
  sls_cust_id ,
  sls_order_dt ,
  sls_ship_dt ,
  sls_due_dt ,
  sls_sales ,
  sls_quantity ,
  sls_price
)

SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CASE
        WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt) != 8 THEN NULL
        ELSE DATE(
            substr(sls_order_dt, 1, 4) || '-' ||
            substr(sls_order_dt, 5, 2) || '-' ||
            substr(sls_order_dt, 7, 2)
        )
    END AS sls_order_dt,
    CASE
        WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt) != 8 THEN NULL
        ELSE DATE(
            substr(sls_ship_dt, 1, 4) || '-' ||
            substr(sls_ship_dt, 5, 2) || '-' ||
            substr(sls_ship_dt, 7, 2)
        )
    END AS sls_ship_dt,
    CASE
        WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt) != 8 THEN NULL
        ELSE DATE(
            substr(sls_due_dt, 1, 4) || '-' ||
            substr(sls_due_dt, 5, 2) || '-' ||
            substr(sls_due_dt, 7, 2)
        )
    END AS sls_due_dt,
    case when sls_sales <= 0 or sls_sales is null or sls_sales != sls_quantity * abs(sls_price)  then
          sls_quantity * abs(sls_price)
         else sls_sales
    end sls_sales,
    sls_quantity,
    case when sls_price is null or sls_price <= 0 then
          sls_sales / nullif(sls_quantity,0)
         else sls_price
    end sls_price
FROM bronze_crm_sales_details;

DROP TABLE IF EXISTS silver_erp_cust_az12;
INSERT INTO silver_erp_cust_az12 (
  CID,
  BDATE,
  GEN
)
select
case  when CID like 'NAS%' then SUBSTRING(CID,4,LENGTH(CID))
      else CID
end CID,
case when BDATE > date(CURRENT_DATE) then null
     else BDATE
end BDATE,
case when trim(UPPER(GEN)) in ('MALE', 'M') then 'Male'
     when trim(UPPER(GEN)) in ('FEMALE' , 'F') then 'Female'
     else 'n/a'
end GEN
from bronze_erp_cust_az12;

DROP TABLE IF EXISTS silver_erp_loc_a101;
INSERT INTO silver_erp_loc_a101(
  CID,
  CNTRY
)
select
replace(CID,'-','') CID ,
case when TRIM(UPPER(CNTRY)) IN ('US','USA') THEN 'United States'
     when TRIM(UPPER(CNTRY)) IN ('DE','GERMANY') THEN 'Germany'
     WHEN CNTRY is null or TRIM(CNTRY) IS '' THEN 'n/a'
     else CNTRY
END CNTRY
from bronze_erp_loc_a101;

DROP TABLE IF EXISTS silver_erp_px_cat_g1v2;
INSERT INTO silver_erp_px_cat_g1v2 (
 ID,
 CAT,
 SUBCAT,
 MAINTENANCE
)
select
ID,
CAT,
SUBCAT,
MAINTENANCE
from bronze_erp_px_cat_g1v2;
