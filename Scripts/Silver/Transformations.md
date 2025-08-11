# Data Quality Checks – Raw to Transformed Layer (Bronze → Silver)

This checklist ensures that all raw data undergoes quality validation before transformation.

---

## 1. Completeness Checks
- [ ] Row count matches between source and staging tables.
- [ ] Primary key columns are unique.
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
- [ ] Duplicate records checked and handled.
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
- Source Table: <table_name> (from Bronze layer)
- [x] Action: Casted cst_id to INTEGER to ensure consistent data type across all records.
- Reason: cst_id had mixed data types and NULL values; standardization supports accurate joins and aggregations.

## 2. Dulicate primmary keys.
- [x] In the table we found some duplicate & primary key is being null cases.
- We selected the records with latest entry based on their create date.   
---
