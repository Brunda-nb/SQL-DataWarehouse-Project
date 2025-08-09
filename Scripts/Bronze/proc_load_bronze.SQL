### Bulk Data Load Process

This project includes scripts to efficiently load large volumes of data into SQLite tables. 
The bulk load commands automate inserting data into the staging and core tables, ensuring smooth data ingestion and preparation for analysis.

#### Purpose of the Scripts

- **Automate data ingestion:** Quickly import raw data files into staging tables.  
- **Ensure data integrity:** Handle data in manageable batches to avoid performance bottlenecks.  
- **Prepare for transformation:** Load raw data before processing it into fact and dimension tables.

> **Note:**  
> The Python script automates copying data from raw tables into the Bronze layer tables within the SQLite database.  
> This approach ensures data consistency by refreshing the Bronze layer with the latest raw data each time it runs.  
> Using Python and `sqlite3` commands allows for efficient execution, error handling, and performance monitoring of this data copy process.

#### Commands
import sqlite3
import time

def copy_raw_to_bronze(db_path):
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    table_map = {
        "cust_info": "bronze_crm_cust_info",
        "prd_info": "bronze_crm_prd_info",
        "sales_details": "bronze_crm_sales_details",
        "LOC_A101": "bronze_erp_loc_a101",
        "CUST_AZ12": "bronze_erp_cust_az12",
        "PX_CAT_G1V2": "bronze_erp_px_cat_g1v2"
    }
    
    print(f">>>>Loading Bronze Layer <<<<")
    #Monitoring the batch insert time 
    Batch_start_time = time.time()


    for raw_table, bronze_table in table_map.items():
      try: 
        
        # Start timer before inserting the data
        start_time = time.time()
        cursor.execute(f"DROP TABLE IF EXISTS {bronze_table};")  # clean slate
        cursor.execute(f"CREATE TABLE {bronze_table} AS SELECT * FROM {raw_table};")
        end_time = time.time()
        elapsed = end_time - start_time

         # Get row count for the bronze table
        cursor.execute(f"SELECT COUNT(*) FROM {bronze_table};")
        count = cursor.fetchone()[0]
        
        print("="*50)
        print(f"Copied data from {raw_table} to {bronze_table} ({count} rows)")
        print(f"Total time taken to insert the data : {elapsed:.2f} seconds")
        print("="*50)
      except Exception as e :
        print(f"❌ Error processing {raw_table} -> {bronze_table}: {e}\n")

    print(f">>>>Bronze Layer Loaded<<<<")
    Batch_end_time = time.time()
    Batchelapsed = Batch_end_time - Batch_start_time
    print(f"Total time taken to load the batch : {Batchelapsed:.2f} seconds")

    conn.commit()
    conn.close()


# Call the function
copy_raw_to_bronze("Datawarehouse.db")

