-- =====================================================
-- DATABASE SELECTION
-- =====================================================
-- Select the working database for analysis
USE online_shop_2024;


-- =====================================================
-- BASIC ROW COUNT CHECK (DATA VOLUME VALIDATION)
-- =====================================================
-- These queries help verify that data is loaded correctly
-- and give an overview of record counts per table

SELECT 'customers' AS table_name, COUNT(*) AS total_records FROM customers;
SELECT 'orders' AS table_name, COUNT(*) AS total_records FROM orders;
SELECT 'order_items' AS table_name, COUNT(*) AS total_records FROM order_items;
SELECT 'products' AS table_name, COUNT(*) AS total_records FROM products;
SELECT 'payments' AS table_name, COUNT(*) AS total_records FROM payments;
SELECT 'reviews' AS table_name, COUNT(*) AS total_records FROM reviews;
SELECT 'shipments' AS table_name, COUNT(*) AS total_records FROM shipments;
SELECT 'suppliers' AS table_name, COUNT(*) AS total_records FROM suppliers;


-- =====================================================
-- DATA QUALITY CHECK: CUSTOMERS TABLE
-- =====================================================
-- Identify missing (NULL) values in key customer attributes
-- Useful for understanding data completeness and cleanup needs

SELECT
  SUM(customer_id IS NULL) AS customer_id_nulls,
  SUM(first_name IS NULL) AS first_name_nulls,
  SUM(last_name IS NULL) AS last_name_nulls,
  SUM(email IS NULL) AS email_nulls,
  SUM(phone_number IS NULL) AS phone_number_nulls
FROM customers;


-- =====================================================
-- DATA QUALITY CHECK: ORDERS TABLE
-- =====================================================
-- Validate order-level fields including customer linkage
-- and financial completeness

SELECT
  SUM(order_id IS NULL) AS order_id_nulls,
  SUM(customer_id IS NULL) AS customer_id_nulls,
  SUM(order_date IS NULL) AS order_date_nulls,
  SUM(total_price IS NULL) AS total_price_nulls
FROM orders;


-- =====================================================
-- DATA QUALITY CHECK: ORDER_ITEMS TABLE
-- =====================================================
-- Ensure integrity of transactional line items
-- Important for revenue and quantity-based analysis

SELECT
  SUM(order_item_id IS NULL) AS order_item_id_nulls,
  SUM(order_id IS NULL) AS order_id_nulls,
  SUM(product_id IS NULL) AS product_id_nulls,
  SUM(quantity IS NULL) AS quantity_nulls,
  SUM(price_at_purchase IS NULL) AS price_at_purchase_nulls
FROM order_items;


-- =====================================================
-- DATA QUALITY CHECK: PRODUCTS TABLE
-- =====================================================
-- Validate product catalog attributes
-- Used for pricing, category analysis, and supplier mapping

SELECT
  SUM(product_id IS NULL) AS product_id_nulls,
  SUM(product_name IS NULL) AS product_name_nulls,
  SUM(category IS NULL) AS category_nulls,
  SUM(price IS NULL) AS price_nulls,
  SUM(supplier_id IS NULL) AS supplier_id_nulls
FROM products;


-- =====================================================
-- DATA QUALITY CHECK: PAYMENTS TABLE
-- =====================================================
-- Check completeness of payment transactions
-- Critical for revenue reconciliation and payment method analysis

SELECT
  SUM(payment_id IS NULL) AS payment_id_nulls,
  SUM(order_id IS NULL) AS order_id_nulls,
  SUM(amount IS NULL) AS payment_amount_nulls,
  SUM(payment_method IS NULL) AS payment_method_nulls,
  SUM(transaction_status IS NULL) AS transaction_status_nulls
FROM payments;


-- =====================================================
-- DATA QUALITY CHECK: REVIEWS TABLE
-- =====================================================
-- Assess customer feedback completeness
-- Useful for sentiment and product performance analysis

SELECT
  SUM(review_id IS NULL) AS review_id_nulls,
  SUM(product_id IS NULL) AS product_id_nulls,
  SUM(customer_id IS NULL) AS customer_id_nulls,
  SUM(rating IS NULL) AS rating_nulls,
  SUM(review_text IS NULL) AS review_text_nulls,
  SUM(review_date IS NULL) AS review_date_nulls
FROM reviews;


-- =====================================================
-- DATA QUALITY CHECK: SHIPMENTS TABLE
-- =====================================================
-- Validate logistics and delivery-related fields
-- Important for fulfillment and delivery performance KPIs

SELECT
  SUM(shipment_id IS NULL) AS shipment_id_nulls,
  SUM(order_id IS NULL) AS order_id_nulls,
  SUM(shipment_date IS NULL) AS shipment_date_nulls,
  SUM(carrier IS NULL) AS carrier_nulls,
  SUM(tracking_number IS NULL) AS tracking_number_nulls,
  SUM(delivery_date IS NULL) AS delivery_date_nulls,
  SUM(shipment_status IS NULL) AS shipment_status_nulls
FROM shipments;


-- =====================================================
-- DATA QUALITY CHECK: SUPPLIERS TABLE
-- =====================================================
-- Ensure supplier master data completeness
-- Useful for vendor analysis and supply chain reporting

SELECT 
  SUM(supplier_id IS NULL) AS supplier_id_nulls,
  SUM(supplier_name IS NULL) AS supplier_name_nulls,
  SUM(contact_name IS NULL) AS contact_name_nulls,
  SUM(address IS NULL) AS address_nulls,
  SUM(phone_number IS NULL) AS phone_number_nulls,
  SUM(email IS NULL) AS email_nulls
FROM suppliers;

    
    /* ============================================================
   WEEK 2 – DATA QUALITY CHECKS
   STEP 3: DUPLICATE ANALYSIS & BUSINESS RULE VALIDATION

   Purpose:
   - Identify duplicate records
   - Validate business logic constraints
   - Flag issues for controlled cleaning
   - NO UPDATE / DELETE operations here

   Database: online_shop_2024
   ============================================================ */
   
   /* ============================================================
   SECTION 1: DUPLICATE ANALYSIS (PRIMARY IDENTIFIERS)
   ============================================================ */

/* Check for duplicate customer IDs
   Expectation: customer_id should be unique */
    SELECT customer_id, COUNT(*) AS cnt
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

/* Check for duplicate order IDs
   Each order_id should represent one order */
SELECT order_id, COUNT(*) AS cnt
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

/* Check for duplicate order_item IDs
   Each order_item_id should be unique */
SELECT order_item_id, COUNT(*) AS cnt
FROM order_items
GROUP BY order_item_id
HAVING COUNT(*) > 1;

/* Check for duplicate product IDs */
SELECT product_id, COUNT(*) AS cnt
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

/* Check for duplicate payment IDs */
SELECT payment_id, COUNT(*) AS cnt
FROM payments
GROUP BY payment_id
HAVING COUNT(*) > 1;

/* Check for duplicate review IDs */
SELECT review_id, COUNT(*) AS cnt
FROM reviews
GROUP BY review_id
HAVING COUNT(*) > 1;

/* Check for duplicate shipment IDs */
SELECT shipment_id, COUNT(*) AS cnt
FROM shipments
GROUP BY shipment_id
HAVING COUNT(*) > 1;

/* Check for duplicate supplier IDs */
SELECT supplier_id, COUNT(*) AS cnt
FROM suppliers
GROUP BY supplier_id
HAVING COUNT(*) > 1;

/* ============================================================
   SECTION 2: LOGICAL / COMPOSITE DUPLICATE CHECKS
   (Duplicates that may not violate PK but affect analysis)
   ============================================================ */

/* Same customer placing multiple orders on the same date
   Could be valid or accidental duplicates */
SELECT customer_id, order_date, COUNT(*) AS order_count
FROM orders
GROUP BY customer_id, order_date
HAVING COUNT(*) > 1;

/* Same product appearing multiple times in the same order
   Usually should be aggregated into one row */
SELECT order_id, product_id, COUNT(*) AS item_count
FROM order_items
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;

SELECT order_id,
       product_id,
       quantity,
       price_at_purchase,
       COUNT(*) AS cnt
FROM order_items
GROUP BY order_id, product_id, quantity, price_at_purchase
HAVING COUNT(*) > 1;


/* ============================================================
   SECTION 3: BUSINESS RULE VALIDATION
   ============================================================ */

/* Quantity and price sanity check
   Quantity and price_at_purchase should always be positive */
SELECT *
FROM order_items
WHERE quantity <= 0
   OR price_at_purchase <= 0;

/* Orders with zero or negative total price
   Indicates calculation or data entry issue */
SELECT *
FROM orders
WHERE total_price <= 0;

/* Payments with invalid or missing transaction status
   Only successful/completed payments should be counted as revenue */
SELECT *
FROM payments
WHERE transaction_status IS NULL
   OR transaction_status NOT IN ('Success', 'Completed');

/* Reviews with invalid ratings
   Rating should be between 1 and 5 */
SELECT *
FROM reviews
WHERE rating NOT BETWEEN 1 AND 5;

/* Shipments marked as shipped but missing tracking information
   Logistics data quality issue */
SELECT *
FROM shipments
WHERE shipment_status = 'Shipped'
  AND tracking_number IS NULL;
  
  /* Orders without corresponding customers (soft validation) */
SELECT *
FROM orders
WHERE customer_id IS NULL;



/* ============================================================
   END OF WEEK 2 – STEP 3 CHECKS

   Output of these queries is used to:
   - Decide cleaning rules
   - Design clean views / tables
   - Build reliable analytics in Week 3

   No data is modified in this step.
   ============================================================ */






