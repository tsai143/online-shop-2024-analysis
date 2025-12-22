/* ============================================================
   DIMENSION TABLE: dim_customer
   Grain: One row per customer
   Source: customers
   ============================================================ */

CREATE TABLE IF NOT EXISTS dim_customer AS
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    phone_number,
    address
FROM customers;

/* Primary Key */
ALTER TABLE dim_customer
ADD PRIMARY KEY (customer_id);

/* ============================================================
   DIMENSION TABLE: dim_product
   Grain: One row per product
   Source: products + suppliers
   ============================================================ */

CREATE TABLE IF NOT EXISTS dim_product AS
SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.price AS catalog_price,
    s.supplier_name
FROM products p
LEFT JOIN suppliers s
    ON p.supplier_id = s.supplier_id;

/* Primary Key */
ALTER TABLE dim_product
ADD PRIMARY KEY (product_id);

/* ============================================================
   DIMENSION TABLE: dim_date
   Grain: One row per date
   Source: orders.order_date
   ============================================================ */

CREATE TABLE IF NOT EXISTS dim_date AS
SELECT DISTINCT
    order_date AS date_id,
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    QUARTER(order_date) AS quarter,
    DAYNAME(order_date) AS day_of_week
FROM orders;

/* Primary Key */
ALTER TABLE dim_date
ADD PRIMARY KEY (date_id);

/* ============================================================
   INDEXES FOR QUERY PERFORMANCE
   ============================================================ */

CREATE INDEX idx_dim_customer_id ON dim_customer(customer_id);
CREATE INDEX idx_dim_product_id ON dim_product(product_id);
CREATE INDEX idx_dim_date_id ON dim_date(date_id);



