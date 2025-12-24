

/* =========================================================
   File: 08_region_manager_model.sql
   Purpose:
   - Derive customer regions from address
   - Create region and manager master tables
   - Enable region-wise analytics & access control
   ========================================================= */

-- =========================================================
-- 1. Create Region Master Table
-- =========================================================
CREATE TABLE IF NOT EXISTS dim_region (
    region_id INT AUTO_INCREMENT PRIMARY KEY,
    region_name VARCHAR(50) UNIQUE
);

-- Insert standard business regions
INSERT IGNORE INTO dim_region (region_name)
VALUES ('North'), ('South'), ('East'), ('West');

-- =========================================================
-- 2. Derive Customer Region from Address
-- NOTE:
-- - Source data does NOT provide region explicitly
-- - Region is derived from state codes embedded in address
-- - Mapping strictly follows the approved region table
-- =========================================================
CREATE TABLE IF NOT EXISTS customer_region AS
SELECT
    dc.customer_id,
    CASE
        -- NORTH
        WHEN dc.address LIKE '%IL%'
          OR dc.address LIKE '%KS%'
          OR dc.address LIKE '%OH%'
          OR dc.address LIKE '%MI%'
          OR dc.address LIKE '%MN%'
          OR dc.address LIKE '%WI%'
          OR dc.address LIKE '%IN%'
          OR dc.address LIKE '%IA%'
          OR dc.address LIKE '%MO%'
          OR dc.address LIKE '%NE%'
          OR dc.address LIKE '%SD%'
          OR dc.address LIKE '%ND%' THEN 'North'

        -- EAST
        WHEN dc.address LIKE '%NY%'
          OR dc.address LIKE '%NJ%'
          OR dc.address LIKE '%DE%'
          OR dc.address LIKE '%PA%'
          OR dc.address LIKE '%MD%'
          OR dc.address LIKE '%VA%'
          OR dc.address LIKE '%CT%'
          OR dc.address LIKE '%RI%'
          OR dc.address LIKE '%NH%'
          OR dc.address LIKE '%ME%'
          OR dc.address LIKE '%MA%'
          OR dc.address LIKE '%VT%'
          OR dc.address LIKE '%WV%'
          OR dc.address LIKE '%DC%'
          OR dc.address LIKE '%PR%'
          OR dc.address LIKE '%VI%' THEN 'East'

        -- SOUTH
        WHEN dc.address LIKE '%FL%'
          OR dc.address LIKE '%TX%'
          OR dc.address LIKE '%SC%'
          OR dc.address LIKE '%GA%'
          OR dc.address LIKE '%AR%'
          OR dc.address LIKE '%TN%'
          OR dc.address LIKE '%AL%'
          OR dc.address LIKE '%MS%'
          OR dc.address LIKE '%LA%'
          OR dc.address LIKE '%OK%'
          OR dc.address LIKE '%KY%'
          OR dc.address LIKE '%NC%' THEN 'South'

        -- WEST
        WHEN dc.address LIKE '%CA%'
          OR dc.address LIKE '%WA%'
          OR dc.address LIKE '%CO%'
          OR dc.address LIKE '%OR%'
          OR dc.address LIKE '%NV%'
          OR dc.address LIKE '%AZ%'
          OR dc.address LIKE '%UT%'
          OR dc.address LIKE '%MT%'
          OR dc.address LIKE '%WY%'
          OR dc.address LIKE '%ID%'
          OR dc.address LIKE '%NM%'
          OR dc.address LIKE '%HI%'
          OR dc.address LIKE '%AK%'
          OR dc.address LIKE '%GU%'
          OR dc.address LIKE '%AS%'
          OR dc.address LIKE '%MP%'
          OR dc.address LIKE '%FM%'
          OR dc.address LIKE '%MH%'
          OR dc.address LIKE '%PW%' THEN 'West'

        ELSE 'Unknown'
    END AS region
FROM dim_customer dc;

-- =========================================================
-- 3. Create Manager Master Table
-- NOTE:
-- - Managers are business entities, not source data
-- - Each manager is responsible for exactly one region
-- =========================================================
CREATE TABLE IF NOT EXISTS dim_manager (
    manager_id INT AUTO_INCREMENT PRIMARY KEY,
    manager_name VARCHAR(100),
    region VARCHAR(50)
);

-- Insert region managers
INSERT INTO dim_manager (manager_name, region)
VALUES
('SAIKUMAR T', 'North'),
('AKSHAYA SHRI', 'South'),
('MANISH KUMAR', 'East'),
('KEERTHANA C', 'West');

-- =========================================================
-- 4. Validation Queries (OPTIONAL – RUN FOR CHECK)
-- =========================================================

-- Check customer distribution by region
SELECT region, COUNT(*) AS customer_count
FROM customer_region
GROUP BY region;

-- Check manager coverage
SELECT * FROM dim_manager;


