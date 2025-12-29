**Week 3: Data Modeling \& Analytics Foundation**



**Objective**

&nbsp;	Design and implement a production-grade Star Schema to support analytical queries,

&nbsp;	advanced customer analytics, and dashboarding.



---



**Step 1: Dimension Table Creation**



**Overview**

&nbsp;	Dimension tables were created to support descriptive analysis and slicing of fact data.

&nbsp;	Only stable, non-transactional attributes were included in dimensions.



---



**Dim\_Customer**

\- Source table: customers

\- Grain: One row per customer



**- Attributes included:**

  - customer\_id (Primary Key)

  - first\_name

  - last\_name

  - email

  - phone\_number

  - address



**- Purpose:**

  - Customer-level analysis

  - Regional segmentation (future dashboards)



---



**Dim\_Product**

\- Source tables: products, suppliers

\- Grain: One row per product



**- Attributes included:**

  - product\_id (Primary Key)

  - product\_name

  - category

  - catalog\_price

  - supplier\_name



**- Notes:**

  - Catalog price is included as a descriptive attribute

  - Transactional price remains in fact table



---



**Dim\_Date**

\- Source: orders.order\_date

\- Grain: One row per calendar date



**- Attributes included:**

  - date\_id (Primary Key)

  - year

  - month

  - quarter

  - day\_of\_week



**- Purpose:**

  - Time-series analysis

  - Trend reporting



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

\- Transaction-level data was extracted from the fact table (`fact\\\_sales`) and enriched with product names from `dim\\\_product`

\- Only valid purchase records (quantity > 0) were considered

\- Data was reshaped into a transaction–product matrix suitable for association rule mining



---



\### Methodology

\- Implemented \*\*Apriori algorithm\*\* using the `mlxtend` library

\- Generated frequent itemsets based on minimum support threshold (2%)

\- Derived association rules using:

  - \*\*Confidence\*\* to measure likelihood of cross-purchase

  - \*\*Lift\*\* to validate statistical significance beyond random chance



---



\### Key Metrics Used

\- \*\*Support\*\*: Frequency of product combinations across all orders

\- \*\*Confidence\*\*: Probability of purchasing product B given product A

\- \*\*Lift\*\*: Strength of association (>1 indicates meaningful relationship)



---



\### Business Validation

\- Filtered rules using:

  - Confidence ≥ 60%

  - Lift ≥ 1.5

\- Ensured resulting rules are actionable and business-relevant

\- Strong associations identified between commonly co-purchased products



---



\### Outcome

\- Produced a set of validated association rules suitable for:

  - Cross-sell recommendations

  - Dashboard insights

  - Strategic decision-making

\- Results are ready for visualization and stakeholder consumption



\## Step 6.5: Region \& Manager Derivation



\- Source system did not provide explicit region or manager mappings

\- Regions were derived from customer address data using predefined state-level business rules

\- Created region master and customer–region mapping tables

\- Implemented manager–region ownership model to support regional analytics and row-level security

\- All assumptions documented and logic validated



step-7 :Dashboard-Ready Data Preparation (Python + SQL)

\## Step 7: Dashboard Data Preparation



\- Created pre-aggregated, dashboard-ready tables in MySQL

\- Prepared sales trend, product performance, region-wise, and segment-wise datasets

\- Ensured dashboards perform no joins or calculations

\- Decoupled analytics logic from visualization layer

