/* ============================================================
   CLEAN VIEW: Order Items
   - Aggregates split-line items
   - Flags zero-price (free/promotional) items
   - Preserves raw data
   ============================================================ */

CREATE OR REPLACE VIEW vw_clean_order_items AS
SELECT
    order_id,
    product_id,
    SUM(quantity) AS total_quantity,

    /* Revenue excludes zero-price items */
    SUM(
        CASE
            WHEN price_at_purchase > 0 THEN quantity * price_at_purchase
            ELSE 0
        END
    ) AS total_revenue,

    /* Flag free/promotional items */
    MAX(
        CASE
            WHEN price_at_purchase = 0 THEN 1
            ELSE 0
        END
    ) AS is_free_item
FROM order_items
GROUP BY order_id, product_id;

/* ============================================================
   CLEAN VIEW: Payments
   - Filters successful payments only
   - Protects revenue calculations
   ============================================================ */

CREATE OR REPLACE VIEW vw_clean_payments AS
SELECT
    payment_id,
    order_id,
    amount,
    payment_method,
    transaction_status
FROM payments
WHERE transaction_status IN ('Success', 'Completed');

/* ============================================================
   CLEAN VIEW: Reviews
   - Excludes invalid ratings
   ============================================================ */

CREATE OR REPLACE VIEW vw_clean_reviews AS
SELECT
    review_id,
    product_id,
    customer_id,
    rating,
    review_text,
    review_date
FROM reviews
WHERE rating BETWEEN 1 AND 5;

/* ============================================================
   CLEAN VIEW: Shipments
   - Flags shipped records without tracking numbers
   ============================================================ */

CREATE OR REPLACE VIEW vw_clean_shipments AS
SELECT
    shipment_id,
    order_id,
    shipment_date,
    delivery_date,
    carrier,
    tracking_number,
    shipment_status,

    CASE
        WHEN shipment_status = 'Shipped'
         AND tracking_number IS NULL THEN 1
        ELSE 0
    END AS missing_tracking_flag
FROM shipments;

SHOW FULL TABLES WHERE table_type = 'VIEW';

SELECT * FROM vw_clean_order_items LIMIT 5;
SELECT * FROM vw_clean_payments LIMIT 5;
SELECT * FROM vw_clean_reviews LIMIT 5;

use online_shop_2024;
/* ------------------------------------------------------------
   STEP 6.1: Confirm that all clean analytical views exist
   Expected: List of views starting with vw_clean_
   ------------------------------------------------------------ */
SHOW FULL TABLES
WHERE table_type = 'VIEW';

/* ------------------------------------------------------------
   STEP 6.2.1
   Purpose: Compare raw vs clean order_items row counts
   Expectation:
   - Clean rows <= raw rows
   - Reduction is expected due to aggregation
   ------------------------------------------------------------ */

SELECT COUNT(*) AS raw_order_item_rows
FROM order_items;

SELECT COUNT(*) AS clean_order_item_rows
FROM vw_clean_order_items;

/* ------------------------------------------------------------
   STEP 6.2.2
   Purpose: Validate payment filtering logic
   Expectation:
   - Clean rows < raw rows
   - Pending/Failed payments excluded
   ------------------------------------------------------------ */

SELECT COUNT(*) AS raw_payment_rows
FROM payments;

SELECT COUNT(*) AS clean_payment_rows
FROM vw_clean_payments;

/* ------------------------------------------------------------
   STEP 6.2.3
   Purpose: Ensure invalid ratings are excluded
   Expectation:
   - Clean rows <= raw rows
   ------------------------------------------------------------ */

SELECT COUNT(*) AS raw_review_rows
FROM reviews;

SELECT COUNT(*) AS clean_review_rows
FROM vw_clean_reviews;

/* ------------------------------------------------------------
   STEP 6.3.1
   Purpose: Calculate raw revenue (NOT trustworthy)
   Includes zero-price items and split lines
   ------------------------------------------------------------ */

SELECT
    SUM(quantity * price_at_purchase) AS raw_revenue
FROM order_items;

/* ------------------------------------------------------------
   STEP 6.3.2
   Purpose: Calculate clean revenue (TRUSTED)
   - Aggregated quantities
   - Zero-price items excluded
   ------------------------------------------------------------ */

SELECT
    SUM(total_revenue) AS clean_revenue
FROM vw_clean_order_items;

/* ------------------------------------------------------------
   STEP 6.4
   Purpose: Check how many orders have successful payments
   Expectation:
   - Paid orders <= total orders
   - Unpaid orders are expected
   ------------------------------------------------------------ */

SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT p.order_id) AS paid_orders
FROM orders o
LEFT JOIN vw_clean_payments p
    ON o.order_id = p.order_id;
    
    /* ------------------------------------------------------------
   STEP 6.5
   Purpose: Validate shipment tracking completeness
   Expectation:
   - Some shipped orders may lack tracking numbers
   - These are flagged, not removed
   ------------------------------------------------------------ */

SELECT
    missing_tracking_flag,
    COUNT(*) AS shipment_count
FROM vw_clean_shipments
GROUP BY missing_tracking_flag;

/* ------------------------------------------------------------
   STEP 6.5.1: Spot check clean order items
   ------------------------------------------------------------ */
SELECT * FROM vw_clean_order_items LIMIT 10;

/* ------------------------------------------------------------
   STEP 6.5.2: Spot check clean payments
   ------------------------------------------------------------ */
SELECT * FROM vw_clean_payments LIMIT 10;

/* ------------------------------------------------------------
   STEP 6.5.3: Spot check clean reviews
   ------------------------------------------------------------ */
SELECT * FROM vw_clean_reviews LIMIT 10;

SELECT * FROM vw_clean_shipments LIMIT 10;














