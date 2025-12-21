USE online_shop_2024;

SELECT 'customers' AS table_name, COUNT(*) FROM customers;
SELECT 'orders', COUNT(*) FROM orders;
SELECT 'order_items', COUNT(*) FROM order_items;
SELECT 'products', COUNT(*) FROM products;
SELECT 'payments', COUNT(*) FROM payments;
SELECT 'reviews', COUNT(*) FROM reviews;
SELECT 'shipments', COUNT(*) FROM shipments;
SELECT 'suppliers', COUNT(*) FROM suppliers;

SELECT
  SUM(customer_id IS NULL) AS customer_id_nulls,
  SUM(first_name IS NULL) AS first_name_nulls,
  SUM(last_name IS NULL) AS last_name_nulls,
  SUM(email IS NULL) AS email_nulls,
  SUM(phone_number IS NULL) AS phone_nulls
FROM customers;

SELECT
  SUM(order_id IS NULL) AS order_id_nulls,
  SUM(customer_id IS NULL) AS customer_id_nulls,
  SUM(order_date IS NULL) AS order_date_nulls,
  SUM(total_price IS NULL) AS total_amount_nulls
FROM orders;

SELECT
  SUM(order_item_id IS NULL) AS order_item_id_nulls,
  SUM(order_id IS NULL) AS order_id_nulls,
  SUM(product_id IS NULL) AS product_id_nulls,
  SUM(quantity IS NULL) AS quantity_nulls,
  SUM(price_at_purchase IS NULL) AS price_nulls
FROM order_items;

SELECT
  SUM(product_id IS NULL) AS product_id_nulls,
  SUM(product_name IS NULL) AS product_name_nulls,
  SUM(category IS NULL) AS category_nulls,
  SUM(price IS NULL) AS price_nulls,
  SUM(supplier_id IS NULL) AS supplier_id_nulls
FROM products;

SELECT
  SUM(payment_id IS NULL) AS payment_id_nulls,
  SUM(order_id IS NULL) AS order_id_nulls,
  SUM(amount IS NULL) AS payment_amount_nulls,
  SUM(payment_method IS NULL) AS payment_method_nulls,
  SUM(transaction_status IS NULL) AS transaction_status_nulls
FROM payments;

SELECT
  SUM(review_id IS NULL) AS review_id_nulls,
  SUM(product_id IS NULL) AS product_id_nulls,
  SUM(customer_id IS NULL) AS customer_id_nulls,
  SUM(rating IS NULL) AS rating_nulls,
  SUM(review_text IS NULL) AS review_text_nulls,
  SUM(review_date IS NULL) AS review_date_nulls
FROM reviews;

SELECT
  SUM(shipment_id IS NULL) AS shipment_id_nulls,
  SUM(order_id IS NULL) AS order_id_nulls,
  SUM(shipment_date IS NULL) AS shipment_date_nulls,
  SUM(carrier IS NULL) AS carrier_nulls,
  SUM(tracking_number IS NULL) AS tracking_number_nulls,
  SUM(delivery_date IS NULL) AS delivery_date_nulls,
  SUM(shipment_status IS NULL) AS shipment_status_nulls
FROM shipments;

SELECT 
	SUM(supplier_id IS NULL) AS supplier_id_nulls,
    SUM(supplier_name IS NULL) AS supplier_name_nulls,
    SUM(contact_name IS NULL) AS contact_name_nulls,
    SUM(address IS NULL) AS address_nulls,
    SUM(phone_number IS NULL) AS phone_number_nulls,
    SUM(email IS NULL) AS email_nulls
FROM suppliers;
    