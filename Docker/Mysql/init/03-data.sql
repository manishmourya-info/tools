USE ecommerce;

-- USERS
INSERT INTO users (name, email, password) VALUES
('Manish Mourya', 'manish@test.com', 'pass'),
('Rahul Sharma', 'rahul@test.com', 'pass'),
('Priya Patel', 'priya@test.com', 'pass'),
('Amit Kumar', 'amit@test.com', 'pass'),
('Sneha Singh', 'sneha@test.com', 'pass');

-- USER PROFILES
INSERT INTO user_profiles (user_id, address, phone, preferences) VALUES
(1, 'Nashik, India', '9999999999', JSON_OBJECT('theme','dark','language','en')),
(2, 'Mumbai, India', '8888888888', JSON_OBJECT('theme','light','notifications',true)),
(3, 'Delhi, India', '7777777777', JSON_OBJECT('theme','dark')),
(4, 'Pune, India', '6666666666', JSON_OBJECT('theme','light','currency','INR')),
(5, 'Bangalore, India', '5555555555', JSON_OBJECT('theme','dark','betaUser',true));

-- PRODUCTS
INSERT INTO products (name, price, stock, attributes) VALUES
('Gaming Laptop', 120000, 15, JSON_OBJECT('brand','ASUS','ram','16GB','gpu','RTX 4060')),
('iPhone 15', 80000, 25, JSON_OBJECT('brand','Apple','storage','128GB')),
('Samsung Galaxy S23', 70000, 30, JSON_OBJECT('brand','Samsung','storage','256GB')),
('Wireless Mouse', 1500, 100, JSON_OBJECT('brand','Logitech')),
('Mechanical Keyboard', 5000, 50, JSON_OBJECT('brand','Keychron')),
('Monitor 27 inch', 20000, 20, JSON_OBJECT('brand','LG','resolution','4K'));

-- CATEGORIES
INSERT INTO categories (name) VALUES
('Electronics'),
('Mobiles'),
('Accessories');

-- PRODUCT-CATEGORY MAPPING
INSERT INTO product_categories VALUES
(1,1),
(2,2),
(3,2),
(4,3),
(5,3),
(6,1);

-- ORDERS
INSERT INTO orders (user_id, total_amount, status) VALUES
(1, 120000, 'PAID'),
(2, 80000, 'SHIPPED'),
(3, 70000, 'DELIVERED'),
(4, 6500, 'PENDING'),
(5, 20000, 'PAID'),
(1, 1500, 'DELIVERED'),
(2, 5000, 'PAID');

-- ORDER ITEMS
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 120000),
(2, 2, 1, 80000),
(3, 3, 1, 70000),
(4, 4, 1, 1500),
(4, 5, 1, 5000),
(5, 6, 1, 20000),
(6, 4, 1, 1500),
(7, 5, 1, 5000);

-- PAYMENTS
INSERT INTO payments (order_id, payment_method, payment_status, transaction_details) VALUES
(1, 'CARD', 'SUCCESS', JSON_OBJECT('txnId','txn_001','bank','HDFC')),
(2, 'UPI', 'SUCCESS', JSON_OBJECT('txnId','txn_002','app','GPay')),
(3, 'NETBANKING', 'SUCCESS', JSON_OBJECT('txnId','txn_003')),
(4, 'UPI', 'FAILED', JSON_OBJECT('txnId','txn_004','reason','Insufficient balance')),
(5, 'CARD', 'SUCCESS', JSON_OBJECT('txnId','txn_005')),
(6, 'UPI', 'SUCCESS', JSON_OBJECT('txnId','txn_006')),
(7, 'CARD', 'SUCCESS', JSON_OBJECT('txnId','txn_007'));

-- EXTRA: EDGE CASES

-- User with no orders
INSERT INTO users (name, email, password) VALUES
('NoOrder User', 'noorder@test.com', 'pass');

-- Product with zero stock
INSERT INTO products (name, price, stock, attributes) VALUES
('Out of Stock Item', 9999, 0, JSON_OBJECT('brand','Test'));

-- Failed payment scenario
INSERT INTO orders (user_id, total_amount, status) VALUES
(3, 9999, 'PENDING');

INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(LAST_INSERT_ID(), 7, 1, 9999);

INSERT INTO payments (order_id, payment_method, payment_status, transaction_details)
VALUES
(LAST_INSERT_ID(), 'UPI', 'FAILED', JSON_OBJECT('reason','Timeout'));