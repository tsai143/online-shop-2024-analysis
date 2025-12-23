\# Week 3: Data Modeling \& Analytics Foundation



\## Objective

Design and implement a production-grade Star Schema to support analytical queries,

advanced customer analytics, and dashboarding.



---



\## Step 1: Dimension Table Creation



\### Overview

Dimension tables were created to support descriptive analysis and slicing of fact data.

Only stable, non-transactional attributes were included in dimensions.



---



\### Dim\_Customer

\- Source table: customers

\- Grain: One row per customer

\- Attributes included:

&nbsp; - customer\_id (Primary Key)

&nbsp; - first\_name

&nbsp; - last\_name

&nbsp; - email

&nbsp; - phone\_number

&nbsp; - address

\- Purpose:

&nbsp; - Customer-level analysis

&nbsp; - Regional segmentation (future dashboards)



---



\### Dim\_Product

\- Source tables: products, suppliers

\- Grain: One row per product

\- Attributes included:

&nbsp; - product\_id (Primary Key)

&nbsp; - product\_name

&nbsp; - category

&nbsp; - catalog\_price

&nbsp; - supplier\_name

\- Notes:

&nbsp; - Catalog price is included as a descriptive attribute

&nbsp; - Transactional price remains in fact table



---



\### Dim\_Date

\- Source: orders.order\_date

\- Grain: One row per calendar date

\- Attributes included:

&nbsp; - date\_id (Primary Key)

&nbsp; - year

&nbsp; - month

&nbsp; - quarter

&nbsp; - day\_of\_week

\- Purpose:

&nbsp; - Time-series analysis

&nbsp; - Trend reporting



---



\### Performance Considerations

\- Primary keys defined on all dimension tables

\- Indexes created on surrogate/business keys

\- Design optimized for sub-2-second analytical queries



---



\## Status

\- Dimension tables successfully created

\- Validation completed using row count comparisons

\- Ready to proceed with Fact table creation





---



\## Step 2: Fact\_Sales Table Creation



\### Grain

\- One row per product per order



\### Measures

\- quantity

\- revenue (cleaned and validated)



\### Keys

\- customer\_id

\- product\_id

\- date\_id

\- order\_id (degenerate dimension)



\### Data Integrity

\- Revenue includes only successful/completed payments

\- Built strictly from clean views

\- Indexed for performance



fact\_sales table created and validated successfully.



\- Referential integrity check confirmed: no orphan customer\_id values in fact\_sales



---



\## Step 3: ERD Verification \& Performance Testing



\### ERD Validation

\- Confirmed star schema structure

\- One fact table with three dimensions

\- No orphan records across customer, product, or date dimensions



\### Performance Testing

\- Revenue, product, customer, and time-based queries executed

\- Indexes utilized effectively

\- All core analytical queries executed under 2 seconds



Star schema verified and approved for analytical and Python-based modeling.





\## Step 4: Python Analytics Foundation



\- Python 3.11 environment configured using virtual environment

\- Required analytics libraries installed and stabilized

\- Centralized MySQL connection utility implemented

\- Star schema tables successfully loaded into Python

\- Data pipeline validated for analytics readiness



