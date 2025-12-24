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



\## Step 5.1: Fact Table Enrichment (Python)



\- Loaded customer, product, and date dimensions from MySQL

\- Enriched fact\_sales with descriptive attributes using left joins

\- Created analytics-ready fact\_enriched dataset



\## Step 5.2: RFM Metric Calculation



\- Computed Recency as days since last purchase

\- Computed Frequency as number of unique orders

\- Computed Monetary as total customer spend

\- Metrics aggregated at customer level for segmentation





\## Step 5.3: RFM Scoring



\- Applied quantile-based scoring (1–5 scale) to Recency, Frequency, and Monetary metrics

\- Recency scored inversely to reflect recent customer activity

\- Combined R, F, and M scores into a unified RFM\_Score

\- Scoring approach ensures balanced customer segmentation





\## Step 6: Market Basket Analysis (Association Rule Mining)



\### Objective

To identify frequently co-purchased products and uncover hidden purchase patterns that can be used for:

\- Cross-selling strategies

\- Product bundling

\- Recommendation engines

\- Promotional planning



---



\### Data Preparation

\- Transaction-level data was extracted from the fact table (`fact\_sales`) and enriched with product names from `dim\_product`

\- Only valid purchase records (quantity > 0) were considered

\- Data was reshaped into a transaction–product matrix suitable for association rule mining



---



\### Methodology

\- Implemented \*\*Apriori algorithm\*\* using the `mlxtend` library

\- Generated frequent itemsets based on minimum support threshold (2%)

\- Derived association rules using:

&nbsp; - \*\*Confidence\*\* to measure likelihood of cross-purchase

&nbsp; - \*\*Lift\*\* to validate statistical significance beyond random chance



---



\### Key Metrics Used

\- \*\*Support\*\*: Frequency of product combinations across all orders

\- \*\*Confidence\*\*: Probability of purchasing product B given product A

\- \*\*Lift\*\*: Strength of association (>1 indicates meaningful relationship)



---



\### Business Validation

\- Filtered rules using:

&nbsp; - Confidence ≥ 60%

&nbsp; - Lift ≥ 1.5

\- Ensured resulting rules are actionable and business-relevant

\- Strong associations identified between commonly co-purchased products



---



\### Outcome

\- Produced a set of validated association rules suitable for:

&nbsp; - Cross-sell recommendations

&nbsp; - Dashboard insights

&nbsp; - Strategic decision-making

\- Results are ready for visualization and stakeholder consumption



