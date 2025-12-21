\# Week 2 – Data Quality Observations



\## Overview

Week 2 focuses on understanding data quality before applying any cleaning logic.

All checks performed so far are read-only and do not modify raw data.



---



\## Step 2.1: Baseline Validation

\- All tables successfully loaded into MySQL

\- Row counts captured to serve as baseline for future comparison

\- No missing tables identified



---



\## Step 2.2: NULL Value Analysis

\- NULL checks performed across all tables using actual schema

\- Primary identifier columns (IDs) contain no NULL values

\- Some nullable fields (e.g., contact details, optional attributes) contain NULLs

\- No critical blocking issues identified at this stage



---



\## Step 3.3: Logical Duplicate Analysis



\### Orders Table

\- Multiple records found for the same `customer\_id` on the same `order\_date`

\- These may represent legitimate multiple orders placed by a customer on the same day

\- No assumptions made at this stage; decision deferred to analysis phase



\### Order\_Items Table

\- Same `product\_id` appears multiple times within the same `order\_id`

\- Initial duplicate check returned ~5000 rows with `COUNT = 2`

\- Diagnostic validation confirmed:

&nbsp; - No exact duplicate rows exist

&nbsp; - Each row represents a split-line item with quantity = 1

\- This indicates an intentional transactional design rather than data duplication

\- Aggregation of quantity and revenue will be handled during cleaning/analysis



---



\## Current Status

\- No raw data has been modified

\- All findings documented for transparency

\- Dataset deemed suitable to proceed with business-rule validation



\### Order\_Items – Zero Price Issue

\- Identified order\_items with price\_at\_purchase = 0.00

\- Quantity is valid but price violates business rules

\- Possible causes include promotional items or missing pricing data

\- These records will be excluded or handled separately in revenue calculations



\### Payments – Transaction Status Issues

\- Approximately 3000 payment records have transaction\_status as Pending or Failed

\- These represent incomplete or unsuccessful transactions

\- Such records should not be included in revenue calculations

\- They will be handled using filtering logic in cleaned views

---

## Step 4: Data Cleaning Strategy

### Approach
- Raw tables will remain unchanged
- Data cleaning will be performed using SQL views
- Views provide safe, reproducible, and reviewable logic

### Key Cleaning Decisions
- Order items with split lines will be aggregated in clean views
- Items with zero price will be flagged as free/promotional
- Only successful or completed payments will be included in revenue analysis
- Invalid review ratings will be excluded from analytical views
- Multiple orders by same customer on same date are treated as valid

### Outcome
Cleaning rules defined and approved.
Execution to be implemented in next step using SQL views.

---

## Step 5: Clean View Implementation

- Implemented non-destructive SQL views for analysis
- Aggregated split-line order items
- Flagged zero-price promotional items
- Filtered revenue-safe payments
- Excluded invalid review ratings
- Preserved all raw data tables

These views will be used for all analytical queries.



