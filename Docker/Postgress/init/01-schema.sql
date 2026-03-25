-- =====================================================
-- SAMPLE POSTGRESQL DATABASE
-- Demonstrates core SQL features
-- =====================================================

-- ---------------------------
-- CREATE DATABASE
-- ---------------------------
DROP DATABASE IF EXISTS ecommerce_db;
CREATE DATABASE ecommerce_db;

\c ecommerce_db

-- ---------------------------
-- TABLES
-- ---------------------------

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    profile JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    price NUMERIC(10,2) CHECK (price > 0),
    category_id INT REFERENCES categories(category_id),
    metadata JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'pending'
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INT REFERENCES products(product_id),
    quantity INT CHECK (quantity > 0),
    price NUMERIC(10,2)
);

-- ---------------------------
-- INDEXES
-- ---------------------------

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_products_name ON products(name);
CREATE INDEX idx_orders_user ON orders(user_id);

-- ---------------------------
-- SAMPLE DATA
-- ---------------------------

INSERT INTO categories (name) VALUES
('Electronics'),
('Books'),
('Clothing');

INSERT INTO users (name,email,profile) VALUES
('Alice','alice@email.com','{"age":25,"city":"Delhi"}'),
('Bob','bob@email.com','{"age":30,"city":"Mumbai"}'),
('Charlie','charlie@email.com','{"age":28,"city":"Bangalore"}');

INSERT INTO products (name,price,category_id,metadata) VALUES
('Laptop',75000,1,'{"brand":"Dell","ram":"16GB"}'),
('SQL Book',900,2,'{"author":"John","pages":450}'),
('T-Shirt',500,3,'{"size":"M","color":"black"}');

INSERT INTO orders (user_id,status) VALUES
(1,'completed'),
(2,'pending'),
(1,'pending');

INSERT INTO order_items (order_id,product_id,quantity,price) VALUES
(1,1,1,75000),
(1,2,1,900),
(2,3,2,500),
(3,2,1,900);

-- ---------------------------
-- VIEW
-- ---------------------------

CREATE OR REPLACE VIEW order_summary AS
SELECT
    o.order_id,
    u.name AS customer,
    SUM(oi.quantity * oi.price) AS total_amount
FROM orders o
JOIN users u ON o.user_id = u.user_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, u.name;

-- ---------------------------
-- STORED FUNCTION
-- ---------------------------

CREATE OR REPLACE FUNCTION get_user_orders(uid INT)
RETURNS TABLE(order_id INT,total NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        o.order_id,
        SUM(oi.quantity * oi.price)
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.user_id = uid
    GROUP BY o.order_id;
END;
$$;

-- ---------------------------
-- TRIGGER AUDIT TABLE
-- ---------------------------

CREATE TABLE product_audit (
    audit_id SERIAL PRIMARY KEY,
    product_id INT,
    action TEXT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------
-- TRIGGER FUNCTION
-- ---------------------------

CREATE OR REPLACE FUNCTION log_product_insert()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO product_audit(product_id,action)
    VALUES (NEW.product_id,'INSERT');
    RETURN NEW;
END;
$$;

-- ---------------------------
-- TRIGGER
-- ---------------------------

CREATE TRIGGER product_insert_trigger
AFTER INSERT ON products
FOR EACH ROW
EXECUTE FUNCTION log_product_insert();

-- ---------------------------
-- FULL TEXT SEARCH EXAMPLE
-- ---------------------------

-- Example query:
-- SELECT * FROM products
-- WHERE to_tsvector(name) @@ to_tsquery('Laptop');

-- ---------------------------
-- TRANSACTION EXAMPLE
-- ---------------------------

-- BEGIN;
-- UPDATE products SET price = price + 100 WHERE product_id = 1;
-- ROLLBACK;

-- ---------------------------
-- COMPLEX QUERY EXAMPLE
-- ---------------------------

-- Total spending per user
-- SELECT
--     u.name,
--     COUNT(o.order_id) AS total_orders,
--     SUM(oi.quantity * oi.price) AS total_spent
-- FROM users u
-- LEFT JOIN orders o ON u.user_id = o.user_id
-- LEFT JOIN order_items oi ON o.order_id = oi.order_id
-- GROUP BY u.name;

-- =====================================================
-- END OF FILE
-- =====================================================