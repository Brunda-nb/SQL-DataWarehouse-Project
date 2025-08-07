# 🧾 **Naming Conventions for Data Warehouse Objects**

This document outlines the naming conventions used for schemas, tables, views, columns, and other data warehouse objects to ensure consistency, clarity, and maintainability.

---

## 📚 **Table of Contents**

1. [General Principles](#general-principles)
2. [Table Naming Conventions](#table-naming-conventions)
   - [🟫 Bronze Layer Rules](#bronze-layer-rules)
   - [⬜ Silver Layer Rules](#silver-layer-rules)
   - [🥇 Gold Layer Rules](#gold-layer-rules)
3. [Column Naming Conventions](#column-naming-conventions)
   - [🔑 Surrogate Keys](#surrogate-keys)
   - [⚙️ Technical Columns](#technical-columns)
4. [🧩 Stored Procedure Naming](#stored-procedure-naming)

---

## 🧠 **General Principles**

- Use `snake_case` for all object names (lowercase + underscores).
- Use **English** consistently across all naming.
- Avoid using **SQL reserved keywords**.
- Be **consistent** in naming across layers and teams.

---

## 🗃️ **Table Naming Conventions**

### 🟫 **Bronze Layer Rules**
- Format: **`<sourcesystem>_<entity>`**
  - No renaming: Tables should retain source names.
  - Example: `crm_customer_info` → Data directly from CRM.

### ⬜ **Silver Layer Rules**
- Format: **`<sourcesystem>_<entity>`**
  - Cleaned and transformed data with same naming format as bronze.
  - Example: `erp_order_header` → Transformed ERP order header data.

### 🥇 **Gold Layer Rules**
- Format: **`<category>_<entity>`**
  - Business-aligned and meaningful.
  - Examples:
    - `dim_customers` → Dimension table for customer info.
    - `fact_sales` → Fact table for sales transactions.

#### 🧾 **Glossary of Gold Layer Prefixes**

| Prefix       | Meaning           | Examples                            |
|--------------|-------------------|-------------------------------------|
| `dim_`       | Dimension Table    | `dim_product`, `dim_region`         |
| `fact_`      | Fact Table         | `fact_orders`, `fact_revenue`       |
| `report_`    | Reporting Table    | `report_kpis`, `report_monthly_sales` |

---

## 📑 **Column Naming Conventions**

### 🔑 **Surrogate Keys**
- Format: **`<entity>_key`**
  - Always use `_key` suffix for surrogate keys.
  - Example: `customer_key` in `dim_customers`.

### ⚙️ **Technical Columns**
- Format: **`dwh_<column_name>`**
  - Used for system-generated metadata.
  - Example: `dwh_load_date` → Date of load into warehouse.

---

## 🧩 **Stored Procedure Naming**

- Format: **`load_<layer>`**
  - Used for orchestration scripts or stored procedures.
  - Examples:
    - `load_bronze`
    - `load_silver`
    - `load_gold`

---

🛠️ **Maintained by:** Brunda N 
🌐 **Portfolio:** _coming soon_  
🔗 **LinkedIn:** www.linkedin.com/in/brundanb  
🧠 *"Naming conventions are the first layer of communication between humans and data systems."*


