# Challenges & Learnings: Migrating a SQL Server Data Warehouse Project to Google Colab with SQLite

## Background
This project implements a layered data warehouse architecture (bronze, silver, gold) designed to handle data ingestion, transformation, and business-ready reporting.

Originally developed using SQL Server, the project leveraged various SQL Server-specific features and commands to efficiently manage and process large datasets.

For practical learning and portfolio showcasing, I adapted the entire project to run on **SQLite within Google Colab** — a lightweight, cloud-based environment with limited native SQL features but powerful integration with Python. This migration required rethinking data ingestion, transformation, and automation techniques to fit within SQLite’s capabilities and Colab’s environment.

---
## Python with SQLITE3 over %%SQL
###  Managing SQL Workflows with Python
- I use Python’s built-in sqlite3 library to connect to the SQLite database.
- I execute raw SQL statements using cursor.execute().
- To manage multiple related SQL commands (like dropping tables and recreating them), I write Python loops that iterate over table names and run SQL dynamically.
- Since SQLite lacks procedural features like stored procedures and try-catch blocks, I leveraged Python’s `sqlite3` library to execute SQL commands.
- Used Python loops to dynamically run SQL statements for multiple tables.
- Wrapped SQL executions in `try-except` blocks to handle errors gracefully and ensure the ETL process continues without interruptions.
- Integrated Python’s `time` module to measure execution duration and monitor ETL performance.
- This approach enabled flexible, robust, and automated data workflows combining Python’s control structures with SQL data operations.
- It also facilitated better logging and debugging during development and presentation.
- For robustness, I wrap SQL execution in Python try-except blocks to catch and log errors without crashing the process.
- I also measure performance using Python’s time module to track how long each step takes.
This approach combines the flexibility of Python programming with the power of SQL for data manipulation.

In notebook environments like Google Colab, this lets me blend SQL and Python seamlessly for data engineering workflows.
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

### 6. Lack of Stored Procedures in SQLite
- **Issue:** Unlike SQL Server, SQLite does not support stored procedures.
- **Impact:** Could not encapsulate complex SQL logic directly inside the database.
- **Solution:** Encapsulated the data transformation and table creation logic inside reusable Python functions, which are executed externally in Google Colab or other Python environments.
- **Example:** Created a Python function to copy data from raw tables to bronze layer tables, making the process modular and repeatable.

### 7. Python Exception Handling vs. Other Languages
- **Issue:** Coming from SQL Server or other programming languages, I initially expected `catch` blocks for error handling.
- **Impact:** Using `catch` in Python causes syntax errors since Python uses `try`...`except`.
- **Solution:** Learned that Python uses `except` blocks for catching exceptions, and adapted error handling accordingly in all scripts.
- This reinforced the importance of language-specific syntax knowledge when migrating projects.
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
