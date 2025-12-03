-- Crear orden
INSERT INTO orders (user_id, order_date, total)
VALUES (3, NOW(), 0.00);

-- agregar producto
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT 1, product_id, 4, price FROM products WHERE product_id IN (18, 19);


-- total
UPDATE orders
SET total = (
  SELECT SUM(quantity * unit_price) FROM order_items WHERE order_id = 1
)
WHERE order_id = 1;

-- actulizar stock
UPDATE products
SET stock = stock - 4 WHERE product_id IN (18, 19);


-- detalles 
SELECT  
  o.order_id,  
  u.user_name,  
  o.order_date,  
  p.product_name,  
  oi.quantity,  
  oi.unit_price,  
  (oi.quantity * oi.unit_price) AS subtotal,  
  o.total  
FROM orders o  
JOIN users u ON o.user_id = u.user_id  
JOIN order_items oi ON o.order_id = oi.order_id  
JOIN products p ON oi.product_id = p.product_id  
WHERE o.order_id = 1;


DELETE FROM orders WHERE order_id IN (1, 2, 3, 4);
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM order_items;
SELECT * FROM orders;
SELECT * FROM order_items;
ALTER TABLE orders AUTO_INCREMENT = 1;

DROP TABLE order_items;
DROP TABLE orders;
DROP TABLE products;
DROP TABLE users;