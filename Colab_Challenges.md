# Challenges & Learnings: Migrating a SQL Server Data Warehouse Project to Google Colab with SQLite

## Background
This project was originally designed using SQL Server features like `BULK INSERT` to load CSV files and create layered tables (bronze, silver, gold) in a data warehouse architecture.

For practicing and showcasing on my portfolio, I migrated the project to use **SQLite in Google Colab**, which is lightweight and free but has significant differences compared to SQL Server.

---

## Challenges Faced

### 1. Unsupported Commands in SQLite
- **Issue:** SQL Server’s `BULK INSERT` command is not supported in SQLite.
- **Impact:** Could not use SQL Server’s fast bulk loading commands directly.
- **Solution:** Used Python’s **Pandas** library to read CSV files and bulk insert data into SQLite tables via `.to_sql()`.

### 2. Differences in SQL Syntax and Features
- **Issue:** SQL Server syntax such as `WITH (...)` clauses in bulk insert is unavailable.
- **Impact:** Had to rethink data loading and transformation steps.
- **Solution:** Moved CSV parsing logic (like skipping headers, field delimiters) to Pandas which handles these options natively.

### 3. File System and Path Differences
- **Issue:** SQL Server expects file paths on a server or local machine; Colab runs on a cloud VM.
- **Impact:** Needed to upload files to Colab or mount Google Drive instead of referencing local paths.
- **Solution:** Uploaded CSV files directly to Colab environment and referenced relative paths in code.

### 4. Session Persistence in Google Colab
- **Issue:** Colab storage is temporary and wiped after session ends.
- **Impact:** Losing database files after closing the notebook.
- **Solution:** Download the SQLite `.db` file after working session, then upload again in the next session to continue.

### 5. Column Matching Between Tables
- **Issue:** When copying data from raw to bronze/silver/gold tables, column names and orders had to match.
- **Impact:** Mismatched columns cause errors.
- **Solution:** Ensured consistent column naming or explicitly mapped columns during insertion or transformation.

---

## Learnings & Takeaways

- The migration process deepened my understanding of how different SQL dialects and environments work.
- Using Python and Pandas alongside SQLite allows flexible data ingestion and transformation, even when native SQL commands are limited.
- Documenting real-world challenges enhances transparency and helps others understand the practical nuances behind data projects.
- Cloud-based notebooks like Colab are great for learning but require additional care for file persistence.

---

## Final Notes

This document complements the project code and README in this repo. Feel free to explore the SQL scripts and Python notebooks to see the step-by-step implementation.

If you have questions or want to collaborate, please reach out!

---

*Brunda N*  
*Data Analyst & Aspiring Data Engineer*

