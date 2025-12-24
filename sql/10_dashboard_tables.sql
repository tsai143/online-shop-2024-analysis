/* =====================================================
   File: 10_dashboard_tables.sql
   Purpose:
   - Validate dashboard tables
   - Ensure no heavy joins needed in BI
   ===================================================== */

-- Sales trend validation
SELECT * FROM dash_sales_trend LIMIT 10;

-- Product performance validation
SELECT * FROM dash_product_performance
ORDER BY total_revenue DESC
LIMIT 10;

-- Region-wise sales validation
SELECT * FROM dash_region_sales ORDER BY total_revenue DESC;

-- Segment-wise sales validation
SELECT * FROM dash_segment_sales ORDER BY total_revenue DESC;
