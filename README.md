# 📊 SQL Data Warehouse , Analytics & Visualization Project

## 🚀 Overview
End-to-end SQL data warehouse project using **Medallion Architecture (Bronze → Silver → Gold)** with **Power BI dashboard** for analytics and visualization.

---

## 🏗️ Architecture

```
Sources → Bronze → Silver → Gold → Analytics → Power BI
```

---

## 🥉 Bronze Layer (Raw)
- Ingests data from CRM & ERP (CSV files)
- No transformations (raw data preserved)
- Ensures traceability

---

## 🥈 Silver Layer (Cleaned)
- Handles NULLs & missing values  
- Removes hidden characters (`\r \n \t`)  
- Standardizes formats (dates, categories)  
- Fixes inconsistencies  
- Deduplicates data (window functions)  
- Creates derived columns  

---

## 🥇 Gold Layer (Business Ready)
- Star schema design  

### Tables
- `dim_customers`
- `dim_products`
- `fact_sales`

### Features
- Data integration  
- Business logic  
- Aggregations & KPIs  
- Surrogate keys  

---

## 📊 Power BI Dashboard
Single dashboard with multiple pages:

- **Executive Overview** → KPIs (Revenue, Orders, Customers, AOV), trends  
- **Sales Analysis** → Country, category, top products, trends  
- **Customer Analysis** → Segmentation, CLV, recency  
- **Product Analysis** → Performance, pricing, lifecycle  

---

## 📈 Analytics

### Customer Report (`gold.report_customers`)
- Segmentation (VIP, Regular, New), age groups  
- Metrics: orders, sales, quantity, products, lifespan  
- KPIs: recency, AOV, avg monthly spend  

### Product Report (`gold.report_products`)
- Segmentation (High / Mid / Low)  
- Metrics: orders, sales, quantity, customers, lifespan  
- KPIs: recency, avg revenue, ASP  

### Sales & Orders
- Sales by country & category  
- Top products  
- Order trends & AOV  
- Orders per country  

---

## 🧠 Concepts Used
- Medallion Architecture  
- Data Cleaning & Transformation  
- Window Functions  
- Star Schema  
- Fact & Dimension Modeling  
- SQL Optimization  

---

## 🛠️ Tech Stack
- SQL (MySQL / SQL Server)  
- Power BI  
- CSV Data  
- Git & GitHub  

---

## 📌 Learnings
- Data warehouse design  
- Handling messy data  
- Writing analytical SQL  
- Building business dashboards  

---

## 📈 Future Improvements
- Materialized tables  
- Incremental loading  
- Query optimization (indexes)  
- Power BI enhancements  

---

## ⭐ Support
If you like this project, give it a ⭐ on GitHub!
