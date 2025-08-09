/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/
%%sql

DROP TABLE IF EXISTS bronze_crm_cust_info;

CREATE TABLE bronze_crm_cust_info (
    cst_id              INTEGER,
    cst_key             TEXT,
    cst_firstname       TEXT,
    cst_lastname        TEXT,
    cst_marital_status  TEXT,
    cst_gndr            TEXT,
    cst_create_date     DATE
);

DROP TABLE IF EXISTS bronze_crm_prd_info;

CREATE TABLE bronze_crm_prd_info (
    prd_id       INT,
    prd_key      NVARCHAR(50),
    prd_nm       NVARCHAR(50),
    prd_cost     INT,
    prd_line     NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt   DATETIME
);

DROP TABLE IF EXISTS bronze_crm_sales_details;

CREATE TABLE bronze_crm_sales_details (
    sls_ord_num  NVARCHAR(50),
    sls_prd_key  NVARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT
);

DROP TABLE IF EXISTS bronze_erp_loc_a101;

CREATE TABLE bronze_erp_loc_a101 (
    cid    NVARCHAR(50),
    cntry  NVARCHAR(50)
);

DROP TABLE IF EXISTS bronze_erp_cust_az12;

CREATE TABLE bronze_erp_cust_az12 (
    cid    NVARCHAR(50),
    bdate  DATE,
    gen    NVARCHAR(50)
);

DROP TABLE IF EXISTS bronze_erp_px_cat_g1v2;

CREATE TABLE bronze_erp_px_cat_g1v2 (
    id           NVARCHAR(50),
    cat          NVARCHAR(50),
    subcat       NVARCHAR(50),
    maintenance  NVARCHAR(50)
);

%%sql
SELECT name 
FROM sqlite_master 
WHERE type='table';
