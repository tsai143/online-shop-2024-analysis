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





