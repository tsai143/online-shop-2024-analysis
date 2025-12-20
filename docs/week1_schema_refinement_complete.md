\# Week 1 – Schema Refinement Completed



\## Summary

All tables were initially imported using TEXT data types to avoid import errors.

After successful imports, schema refinement was performed using ALTER TABLE.



\## Changes Applied

\- customer\_id, order\_id, product\_id converted to INT

\- Names and text fields converted to VARCHAR

\- Monetary values converted to DECIMAL

\- Date fields converted to DATE



\## Tables Updated

\- customers

\- orders

\- order\_items

\- products

\- payments

\- reviews

\- shipments

\- suppliers



\## Validation

\- ALTER TABLE executed without errors

\- No data loss observed

\- Row counts verified before and after changes



