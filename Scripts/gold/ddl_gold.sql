/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
# Customer View
# Final join
# Along with nameing conventions.
# Order of coulmns has been changed.
# Since the table gives info about who,where ,, - `Dimension Table`.
# Creating a surogate key for this view .

%%sql

CREATE VIEW gold_dim_customers AS

      select
          row_number() over (order by cst_id ) as customer_key ,
          ci.cst_id as customer_id ,
          ci.cst_key as customer_number ,
          ci.cst_firstname as first_name ,
          ci.cst_lastname as last_name ,
          la.CNTRY as country ,
          ci.cst_marital_status as marital_status ,
          case when ci.cst_gndr != 'n/a' then ci.cst_gndr
              else COALESCE(ca.gen, 'n/a')
          end  as gender ,
          ca.bdate as birthdate ,
          ci.cst_create_date as create_date
      from silver_crm_cust_info ci
      left join silver_erp_cust_az12 ca
            on ci.cst_key = ca.cid
      left join silver_erp_loc_a101 la
            on ci.cst_key = la.cid ;

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
#1. Sorting the columns to increase the readibility
#2. Renaming the coulmns .
#3. it tells more about what & when - Dimension table.
#4. Creating a surrogate key for this view .


%%sql

CREATE VIEW gold_dim_product AS

    select
          row_number() over(order by pn.prd_start_dt , pn.prd_id ) as product_key,
          pn.prd_id as product_id,
          pn.prd_key as product_number ,
          pn.prd_nm as product_name,
          pn.cat_id as category_id,
          pc.cat as category,
          pc.subcat as subcategory,
          pc.maintenance ,
          pn.prd_cost as cost,
          pn.prd_line as product_line,
          pn.prd_start_dt as start_date
      from silver_crm_prd_info pn
      left join silver_erp_px_cat_g1v2 pc
            on pn.cat_id = pc.id
      where pn.prd_end_dt is null;

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
#Renaming the columns.
#Sorting the columns (( dimensions,dates , meaasures)).
#Creating view

%%sql
CREATE VIEW gold_fact_sales AS
      select
          sd.sls_ord_num as order_number,
          pr.product_key ,
          cu.customer_key ,
          sd.sls_order_dt as order_date,
          sd.sls_ship_dt as shipping_date,
          sd.sls_due_dt as due_date,
          sd.sls_sales as sales_amount,
          sd.sls_quantity as quantity,
          sd.sls_price as price
      from silver_crm_sales_details sd
      left join gold_dim_product pr
          on sd.sls_prd_key = pr.product_number
      left join gold_dim_customers cu
          on sd.sls_cust_id = cu.customer_id ;
