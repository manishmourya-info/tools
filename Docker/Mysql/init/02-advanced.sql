USE ecommerce;

-- VIEW: Order Summary
CREATE VIEW order_summary AS
SELECT o.id, u.name, o.total_amount, o.status
FROM orders o
JOIN users u ON o.user_id = u.id;

-- STORED PROCEDURE: Place Order
DELIMITER $$

CREATE PROCEDURE place_order(
    IN p_user_id INT,
    IN p_total DECIMAL(10,2)
)
BEGIN
    INSERT INTO orders(user_id, total_amount, status)
    VALUES (p_user_id, p_total, 'PENDING');
END $$

DELIMITER ;

-- TRIGGER: Reduce stock after order
DELIMITER $$

CREATE TRIGGER reduce_stock
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock = stock - NEW.quantity
    WHERE id = NEW.product_id;
END $$

DELIMITER ;