# Data Quality Checks – Raw to Transformed Layer (Bronze → Silver)

This checklist ensures that all raw data undergoes quality validation before transformation.

---

## 1. Completeness Checks
- [x] Row count matches between source and staging tables.
- [x] Primary key columns are unique.
- [ ] Mandatory fields (`customer_id`, `order_date`, etc.) are not null.
- [ ] All expected files/data partitions are present.
- [ ] Timestamp coverage is complete for the required period.

---

## 2. Validity Checks
- [ ] Data types match the schema definition (e.g., dates, integers, decimals).
- [ ] Values follow the required format (e.g., email, phone numbers).
- [ ] Domain validation – only allowed values are present (e.g., status codes).
- [ ] Business rules are satisfied (e.g., `order_amount >= 0`, `age >= 18`).

---

## 3. Accuracy Checks
- [ ] Values cross-checked against reference datasets.
- [ ] Derived/calculated values match expected formulas.
- [ ] Geographical values are valid (e.g., postal codes, lat/long).

---

## 4. Consistency Checks
- [ ] Referential integrity is maintained (FKs match PKs).
- [ ] Units are consistent across all records (e.g., kg, USD).
- [x] Duplicate records checked and handled.
- [ ] Mapped codes match mapping tables.

---

## 5. Timeliness & Freshness Checks
- [ ] Data latency is within the acceptable limit.
- [ ] Last update timestamp is recent.
- [ ] Event sequence/order is logical (e.g., `order_date <= ship_date`).

---

## 6. Anomaly & Outlier Checks
- [ ] Unusual spikes or drops in record counts detected.
- [ ] Outliers in numerical fields identified and flagged.
- [ ] Data distribution matches historical trends.

---

## 7. Metadata & Schema Checks
- [ ] Column names and order match the expected schema.
- [ ] Column count is as expected.
- [ ] File encoding matches processing requirements.

---

## Notes
- Any failed checks should be logged in an **audit table**.
- Critical failures → data moved to **quarantine/reject table**.
- Minor issues → flagged but transformation continues.

---
The following changes are made during the checklist.

## 1. Transformation: Standardizing cst_id column
- Source Table: bronze_crm_cust_info (from Bronze layer)
- Action: Casted cst_id to INTEGER to ensure consistent data type across all records.
- Reason: cst_id had mixed data types and NULL values; standardization supports accurate joins and aggregations.

## 2. Dulicate primmary keys
- Source Table : In the table bronze_crm_cust_info we found some duplicate & primary key is being null cases.
- Action :I filtered the records with latest entry based on their create date. Basically used the row_number() to assign flag (1,2,_,_) for the multiple records
- Expected : All the unique records should be having their flag marked as '1'.
  
## 3. Check for unwanted spaces
- Source Table : bronze_crm_cust_info
- Action : Finding the records with spaces using the trim(). Selecting the records where value of column is not equal to value of its trimmed version.
- Expected : Records with trailing or following spaces. 

## 4. Data standardization & Consistency (Columns with low cardinality)
- Source Table : bronze_crm_cust_info (cst_gndr , cst_marital_status) , bronze_crm_prd_info (prd_line)
- Problem : Possible values of the column . Ex. In column cst_gndr we need only 2 values,'F','M'. Other than these two values should be treated.
- Action : Selecting the distinct values of the columns. And assigning values to the abrivations using 'case'.
- Expected : Values based on the cardinality of the column.
- **Note** : Make sure to handle the null cases , spaces and also the uppercase/lowercase standarization while filtering . 

## 5. Fixing format mismatch.
- Source Table : bronze_crm_prd_info & bronze_erp_px_cat_g1v2 (cat_id) , bronze_erp_cust_az12 & bronze_crm_cut_info
- Problem : Mismatch of format of the records . 
- Action : Used replace function to repllace '-' with '_' in earlier case. While we used substring() to get the `CID` matching with `CST_KEY`. 

## 6. Null & Negative Value Check in Numeric Columns
- Source Table :bronze_crm_prd_info<prd_cost> , 
- Problem : Numeric columns contained null values and/or negative values, which are invalid for business logic and can affect aggregations or calculations.
- Action : Applied filters to identify rows with null values (IS NULL) and negative values (< 0) in numeric columns. Decided on corrective action such as replacing with default values, excluding from calculations, or flagging for review. Used (ISNULL) to assign '0' to null values .

## 7. Transformation: Checking for Invalid Dates
- Source Table : bronze_crm_prd_info<prd_start_dt,prd_end_dt>.
- Validated `prd_start_dt` and `prd_end_dt` columns to ensure all values conform to the valid date range and are correctly formatted as `YYYY-MM-DD HH:MM:SS`. Flagged rows with null, malformed, or logically incorrect dates (e.g., month > 12, day > 31).
- All date values should be valid and parsable into DATETIME format without errors.  
- No invalid or out-of-range dates should exist in these columns.  
- All stored dates should follow the `YYYY-MM-DD HH:MM:SS` standard.
- Action : Used lead() to alot the continous date to avoid the overlapping. Concentrated only 1 product .
  
---
