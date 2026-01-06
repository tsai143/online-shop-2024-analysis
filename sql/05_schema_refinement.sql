/* MODIFYING TABLE DATATYPES */
ALTER TABLE customers
  MODIFY customer_id INT,
  MODIFY first_name VARCHAR(100),
  MODIFY last_name VARCHAR(100),
  MODIFY address VARCHAR(255),
  MODIFY email VARCHAR(150),
  MODIFY phone_number VARCHAR(20);
  
  -- RENAMEING TABLE NAME
  RENAME TABLE payment TO payments;
  
  SHOW TABLES;
  
  ALTER TABLE orders
  MODIFY order_id INT,
  MODIFY order_date DATE,
  MODIFY customer_id INT,
  MODIFY total_price DECIMAL(10,2);
  
  ALTER TABLE order_items
  MODIFY order_item_id INT,
  MODIFY order_id INT,
  MODIFY product_id INT,
  MODIFY quantity INT,
  MODIFY price_at_purchase DECIMAL(10,2);
  
  ALTER TABLE products
  MODIFY product_id INT,
  MODIFY product_name VARCHAR(150),
  MODIFY category VARCHAR(100),
  MODIFY price DECIMAL(10,2),
  MODIFY supplier_id INT;
  
  ALTER TABLE payments
  MODIFY payment_id INT,
  MODIFY order_id INT,
  MODIFY payment_method VARCHAR(50),
  MODIFY amount DECIMAL(10,2),
  MODIFY transaction_status VARCHAR(50);
  
  ALTER TABLE reviews
  MODIFY review_id INT,
  MODIFY product_id INT,
  MODIFY customer_id INT,
  MODIFY rating INT,
  MODIFY review_text VARCHAR(500),
  MODIFY review_date DATE;
  
  ALTER TABLE shipments
  MODIFY shipment_id INT,
  MODIFY order_id INT,
  MODIFY shipment_date DATE,
  MODIFY carrier VARCHAR(100),
  MODIFY tracking_number VARCHAR(100),
  MODIFY delivery_date DATE,
  MODIFY shipment_status VARCHAR(50);

ALTER TABLE suppliers
  MODIFY supplier_id INT,
  MODIFY supplier_name VARCHAR(150),
  MODIFY contact_name VARCHAR(150),
  MODIFY email VARCHAR(150),
  MODIFY phone_number VARCHAR(20),
  MODIFY address VARCHAR(255);
  
  -- VALIDATION OF DATATYPE FOR COLUMNS
  DESCRIBE CUSTOMERS;
  DESCRIBE orders;
DESCRIBE payments;
DESCRIBE products;








