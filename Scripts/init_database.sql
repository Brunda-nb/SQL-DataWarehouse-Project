/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'. Creating schemas is currently not possible in 
    collab, so alternatively i have opted to name the tables with prefix of their respective schema. 

Attention:
   This scrript is acc to google collab sqlite3. If you find other shortcuts or SQL sytax version feel free to change in your syntax . 
	
WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

---
%load_ext sql
%sql sqlite:///Datawarehouse.db

---

