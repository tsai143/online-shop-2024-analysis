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

/* VALIDATION QUERIES*/
SELECT COUNT(*) FROM dim_customer;
SELECT COUNT(*) FROM customers;

SELECT COUNT(*) FROM dim_product;
SELECT COUNT(*) FROM products;

SELECT COUNT(*) FROM dim_date;

/* ============================================================
   FACT TABLE: fact_sales
   Grain: One row per product per order
   Source: Clean views + dimension tables
   ============================================================ */

CREATE TABLE IF NOT EXISTS fact_sales AS
SELECT
    o.order_id,                         -- Degenerate dimension
    o.customer_id,                      -- FK to dim_customer
    ci.product_id,                      -- FK to dim_product
    d.date_id,                          -- FK to dim_date

    ci.total_quantity AS quantity,      -- Measure
    ci.total_revenue AS revenue         -- Measure

FROM vw_clean_order_items ci
JOIN orders o
    ON ci.order_id = o.order_id
JOIN vw_clean_payments p
    ON o.order_id = p.order_id
JOIN dim_date d
    ON o.order_date = d.date_id;
    
    /* ============================================================
   PRIMARY KEY & INDEXES
   ============================================================ */

ALTER TABLE fact_sales
ADD PRIMARY KEY (order_id, product_id);

CREATE INDEX idx_fact_customer ON fact_sales(customer_id);
CREATE INDEX idx_fact_product ON fact_sales(product_id);
CREATE INDEX idx_fact_date ON fact_sales(date_id);

-- Row count sanity
SELECT COUNT(*) FROM fact_sales;

-- Revenue sanity
SELECT SUM(revenue) FROM fact_sales;

-- Join integrity check
SELECT COUNT(*) 
FROM fact_sales fs
LEFT JOIN dim_customer dc ON fs.customer_id = dc.customer_id
WHERE dc.customer_id IS NULL;

-- Product integrity check
SELECT COUNT(*)
FROM fact_sales fs
LEFT JOIN dim_product dp
  ON fs.product_id = dp.product_id
WHERE dp.product_id IS NULL;

-- Date integrity check
SELECT COUNT(*)
FROM fact_sales fs
LEFT JOIN dim_date dd
  ON fs.date_id = dd.date_id
WHERE dd.date_id IS NULL;








