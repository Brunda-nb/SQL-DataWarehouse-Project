# 📋 Source System Analysis 

## 🛠 Why Do We Do Source System Analysis?
Before working with any data, it’s critical to understand the **source system** that generates and stores it.  
Source system analysis helps to:
- Ensure we collect **accurate, relevant, and reliable data** for our needs
- Understand the **business processes** behind the data
- Identify **limitations and risks** before integrating or transforming the data
- Optimize **ETL/ELT pipelines** by knowing refresh rates, storage, and formats
- Align the **data’s purpose** with project KPIs and analytics goals
- Avoid **costly rework** caused by missing or misunderstood information

This checklist can be used as a reference during **data discovery**, **ETL design**, or **system onboarding**.

# 📋 Source System Analysis Checklist

## 1. Business Context & Ownership
- [ ] What business process does this source system support?
- [ ] Which department or business unit owns and manages it?
- [ ] What is the primary purpose of the data in this system?
- [ ] Who are the key stakeholders and decision-makers for this data?
- [ ] How frequently do business processes update or change in this system?

## 2. Data Structure & Content
- [ ] What data entities/tables does it contain?
- [ ] How are these entities related to each other (relationships, keys)?
- [ ] What are the key identifiers (e.g., customer ID, order ID)?
- [ ] What is the level of granularity (transaction-level, aggregated, etc.)?
- [ ] Which fields are critical for analysis, and which are auxiliary?

## 3. Data Quality & Completeness
- [ ] How accurate and reliable is the data?
- [ ] Are there known data quality issues (duplicates, missing values, outdated info)?
- [ ] How often is the data validated or cleaned?
- [ ] Are there any standardization or formatting rules?

## 4. Data Volume & Growth
- [ ] How big is the dataset (rows, storage size)?
- [ ] What is the data growth rate (daily, monthly)?
- [ ] Is there historical data, and how far back does it go?
- [ ] Are there data archival or purging policies?

## 5. Data Refresh & Update Cycles
- [ ] How frequently is data updated (real-time, hourly, daily, weekly)?
- [ ] Are there batch processing windows or downtime periods?
- [ ] How does data latency affect reporting or analysis?

## 6. Integration & Access
- [ ] How is the data stored (RDBMS, flat files, API, cloud storage, etc.)?
- [ ] What methods are available to extract the data (SQL, API, file export)?
- [ ] Are there any existing ETL/ELT pipelines?
- [ ] What authentication or access control is in place?

## 7. Metadata & Documentation
- [ ] Is there a data dictionary or schema documentation available?
- [ ] Are column definitions and units of measure clear?
- [ ] Are there any business rules or transformations applied before storing data?

## 8. Security & Compliance
- [ ] Are there regulatory requirements (GDPR, HIPAA, etc.)?
- [ ] What PII or sensitive data is present?
- [ ] Are there encryption or masking standards in place?
- [ ] Who can view, edit, or delete data?

## 9. Historical Changes & System Limitations
- [ ] Has the source system gone through migrations or upgrades?
- [ ] Were there any schema changes in the past that affect data continuity?
- [ ] Are there limitations on query performance or data export size?

## 10. Alignment with Analytics Goals
- [ ] Does the data match the KPIs and metrics we want to track?
- [ ] Are there gaps that will require combining with other data sources?
- [ ] Is there any derived or calculated data we can reuse instead of recalculating?
# 📋 Source System Analysis Checklist

## 1. Business Context & Ownership
- [ ] What business process does this source system support?
- [ ] Which department or business unit owns and manages it?
- [ ] What is the primary purpose of the data in this system?
- [ ] Who are the key stakeholders and decision-makers for this data?
- [ ] How frequently do business processes update or change in this system?

## 2. Data Structure & Content
- [ ] What data entities/tables does it contain?
- [ ] How are these entities related to each other (relationships, keys)?
- [ ] What are the key identifiers (e.g., customer ID, order ID)?
- [ ] What is the level of granularity (transaction-level, aggregated, etc.)?
- [ ] Which fields are critical for analysis, and which are auxiliary?

## 3. Data Quality & Completeness
- [ ] How accurate and reliable is the data?
- [ ] Are there known data quality issues (duplicates, missing values, outdated info)?
- [ ] How often is the data validated or cleaned?
- [ ] Are there any standardization or formatting rules?

## 4. Data Volume & Growth
- [ ] How big is the dataset (rows, storage size)?
- [ ] What is the data growth rate (daily, monthly)?
- [ ] Is there historical data, and how far back does it go?
- [ ] Are there data archival or purging policies?

## 5. Data Refresh & Update Cycles
- [ ] How frequently is data updated (real-time, hourly, daily, weekly)?
- [ ] Are there batch processing windows or downtime periods?
- [ ] How does data latency affect reporting or analysis?

## 6. Integration & Access
- [ ] How is the data stored (RDBMS, flat files, API, cloud storage, etc.)?
- [ ] What methods are available to extract the data (SQL, API, file export)?
- [ ] Are there any existing ETL/ELT pipelines?
- [ ] What authentication or access control is in place?

## 7. Metadata & Documentation
- [ ] Is there a data dictionary or schema documentation available?
- [ ] Are column definitions and units of measure clear?
- [ ] Are there any business rules or transformations applied before storing data?

## 8. Security & Compliance
- [ ] Are there regulatory requirements (GDPR, HIPAA, etc.)?
- [ ] What PII or sensitive data is present?
- [ ] Are there encryption or masking standards in place?
- [ ] Who can view, edit, or delete data?

## 9. Historical Changes & System Limitations
- [ ] Has the source system gone through migrations or upgrades?
- [ ] Were there any schema changes in the past that affect data continuity?
- [ ] Are there limitations on query performance or data export size?

## 10. Alignment with Analytics Goals
- [ ] Does the data match the KPIs and metrics we want to track?
- [ ] Are there gaps that will require combining with other data sources?
- [ ] Is there any derived or calculated data we can reuse instead of recalculating?
