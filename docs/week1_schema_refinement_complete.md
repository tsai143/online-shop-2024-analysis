**Week 1 – Schema Refinement Completed**



**Summary**

&nbsp;	All tables were initially imported using TEXT data types to avoid import errors.

&nbsp;	After successful imports, schema refinement was performed using ALTER TABLE.



**Changes Applied**

&nbsp;	- customer\_id, order\_id, product\_id converted to INT

&nbsp;	- Names and text fields converted to VARCHAR

&nbsp;	- Monetary values converted to DECIMAL

&nbsp;	- Date fields converted to DATE



**Tables Updated**

&nbsp;	- customers

&nbsp;	- orders

&nbsp;	- order\_items

&nbsp;	- products

&nbsp;	- payments

&nbsp;	- reviews

&nbsp;	- shipments

&nbsp;	- suppliers



**Validation**

&nbsp;	- ALTER TABLE executed without errors

&nbsp;	- No data loss observed

&nbsp;	- Row counts verified before and after changes

