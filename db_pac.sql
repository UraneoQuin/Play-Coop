<<<<<<< HEAD
-- 0. CONTROL DE INICIO: ELIMINACIÓN DE ESTRUCTURAS ANTIGUAS
-- Elimina la base de datos 'play' si existe.
DROP DATABASE IF EXISTS play;

-- 1. CREACIÓN DE LA BASE DE DATOS
CREATE DATABASE IF NOT EXISTS play;
-- Selecciona la base de datos para todas las operaciones subsiguientes.
USE play;

-- 2. ELIMINACIÓN DE TABLAS (En orden inverso por las Foreign Keys)
-- Aunque DROP DATABASE borra las tablas, esto previene errores si solo ejecutas una parte del script.
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS products;


-- 3. TABLA DE PRODUCTOS
=======
-- 1. CREACIÓN DE LA BASE DE DATOS
CREATE DATABASE IF NOT EXISTS play;
USE play;

-- 2. TABLA DE PRODUCTOS
>>>>>>> 135ed7dd8e8176776e50bb0ceabd05b0527269ac
CREATE TABLE `products` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `product_name` varchar(100) NOT NULL,
  `product_desc` text DEFAULT NULL,
  `price` DECIMAL(10,2) DEFAULT 0.00,
  `stock` int DEFAULT 0,
  `product_category` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`product_id`) 
);
<<<<<<< HEAD
=======

-- 3. INSERTAR DATOS (Precios corregidos sin puntos de miles)
INSERT INTO products (product_name, product_desc, price, stock, product_category) VALUES 
('Monopoly', '¡Arriésgalo todo o quiebra en el intento! Juego familiar de compra y venta de propiedades.', 99000.00, 20, 'juego de mesa'),
('Ajedrez', 'Juego de estrategia clásico para dos jugadores en un tablero de 64 casillas.', 40000.00, 35, 'juego de mesa'),
('Damas Chinas', 'Juego de estrategia en tablero de estrella. Mueve tus piezas al lado opuesto.', 35000.00, 15, 'juego de mesa'),
('Parqués', 'Juego tradicional colombiano de azar y estrategia con dados para llegar al cielo.', 44000.00, 10, 'juego de mesa'),
('Scrabble', 'Forma palabras en el tablero y suma puntos. Ideal para mejorar vocabulario.', 85000.00, 25, 'juego de mesa'),
('Jenga', 'Retira bloques de madera de la torre sin que se derrumbe.', 65000.00, 30, 'juego de mesa'),
('Uno', 'Juego de cartas rápido donde el objetivo es quedarse sin cartas.', 35000.00, 50, 'juego de mesa'),
('Risk', 'Estrategia militar para conquistar territorios en un mapa mundial.', 120000.00, 18, 'juego de mesa'),
('Catan', 'Juego de colonización y comercio de recursos en una isla.', 160000.00, 12, 'juego de mesa'),
('Twister', 'Juego físico de colocar manos y pies en colores según la ruleta.', 70000.00, 20, 'juego de mesa'),
('Trivial Pursuit', 'Preguntas y respuestas de cultura general para ganar quesitos.', 110000.00, 10, 'juego de mesa'),
('Clue', 'Descubre quién cometió el asesinato, dónde y con qué arma.', 95000.00, 15, 'juego de mesa'),
('Domino', 'Juego clásico de fichas rectangulares uniendo números iguales.', 30000.00, 40, 'juego de mesa'),
('Backgammon', 'Carrera de fichas y dados en un tablero triangular.', 75000.00, 12, 'juego de mesa'),
('Pictionary', 'Dibuja para que tu equipo adivine la palabra antes del tiempo.', 90000.00, 18, 'juego de mesa'),
('Bingo', 'Juego de azar marcando números en cartones.', 40000.00, 25, 'juego de mesa'),
('Labyrinth', 'Mueve los pasillos del laberinto para encontrar tesoros.', 85000.00, 10, 'juego de mesa'),
('Carcassonne', 'Construye ciudades y caminos medievales colocando losetas.', 150000.00, 8, 'juego de mesa'),
('Yahtzee', 'Juego de dados estilo póker para conseguir la mayor puntuación.', 55000.00, 20, 'juego de mesa');
>>>>>>> 135ed7dd8e8176776e50bb0ceabd05b0527269ac

-- 4. TABLA DE USUARIOS
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `user_name` varchar(50) NOT NULL,
  `user_email` varchar(50) NOT NULL UNIQUE,
  `user_password` varchar(60) NOT NULL, 
  PRIMARY KEY (`user_id`)
); 

<<<<<<< HEAD
-- 5. TABLA DE ORDENES (CARRITO CONFIRMADO)
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `order_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `total` DECIMAL(10,2) DEFAULT 0.00 , 
  PRIMARY KEY (`order_id`),
  FOREIGN KEY(`user_id`) REFERENCES users(user_id) ON DELETE CASCADE
); 

-- 6. TABLA DE ITEMS DE LA ORDEN
CREATE TABLE `order_items` (
  `order_item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int DEFAULT 0, 
  `unit_price` DECIMAL(10,2) DEFAULT 0.00,
  PRIMARY KEY (`order_item_id`),
  FOREIGN KEY(`order_id`) REFERENCES orders(order_id) ON DELETE CASCADE,
  FOREIGN KEY(`product_id`) REFERENCES products(product_id) 
); 


-- 7. INSERCIÓN DE DATOS INICIALES

-- Insertar Productos
INSERT INTO products (product_name, product_desc, price, stock, product_category) VALUES 
('Monopoly', '¡Arriésgalo todo o quiebra en el intento! Juego familiar de compra y venta de propiedades.', 99000.00, 20, 'juego de mesa'),
('Ajedrez', 'Juego de estrategia clásico para dos jugadores en un tablero de 64 casillas.', 40000.00, 35, 'juego de mesa'),
('Damas Chinas', 'Juego de estrategia en tablero de estrella. Mueve tus piezas al lado opuesto.', 35000.00, 15, 'juego de mesa'),
('Parqués', 'Juego tradicional colombiano de azar y estrategia con dados para llegar al cielo.', 44000.00, 10, 'juego de mesa'),
('Scrabble', 'Forma palabras en el tablero y suma puntos. Ideal para mejorar vocabulario.', 85000.00, 25, 'juego de mesa'),
('Jenga', 'Retira bloques de madera de la torre sin que se derrumbe.', 65000.00, 30, 'juego de mesa'),
('Uno', 'Juego de cartas rápido donde el objetivo es quedarse sin cartas.', 35000.00, 50, 'juego de mesa'),
('Risk', 'Estrategia militar para conquistar territorios en un mapa mundial.', 120000.00, 18, 'juego de mesa'),
('Catan', 'Juego de colonización y comercio de recursos en una isla.', 160000.00, 12, 'juego de mesa'),
('Twister', 'Juego físico de colocar manos y pies en colores según la ruleta.', 70000.00, 20, 'juego de mesa'),
('Trivial Pursuit', 'Preguntas y respuestas de cultura general para ganar quesitos.', 110000.00, 10, 'juego de mesa'),
('Clue', 'Descubre quién cometió el asesinato, dónde y con qué arma.', 95000.00, 15, 'juego de mesa'),
('Domino', 'Juego clásico de fichas rectangulares uniendo números iguales.', 30000.00, 40, 'juego de mesa'),
('Backgammon', 'Carrera de fichas y dados en un tablero triangular.', 75000.00, 12, 'juego de mesa'),
('Pictionary', 'Dibuja para que tu equipo adivine la palabra antes del tiempo.', 90000.00, 18, 'juego de mesa'),
('Bingo', 'Juego de azar marcando números en cartones.', 40000.00, 25, 'juego de mesa'),
('Labyrinth', 'Mueve los pasillos del laberinto para encontrar tesoros.', 85000.00, 10, 'juego de mesa'),
('Carcassonne', 'Construye ciudades y caminos medievales colocando losetas.', 150000.00, 8, 'juego de mesa'),
('Yahtzee', 'Juego de dados estilo póker para conseguir la mayor puntuación.', 55000.00, 20, 'juego de mesa');

-- Insertar Usuarios
=======
>>>>>>> 135ed7dd8e8176776e50bb0ceabd05b0527269ac
INSERT INTO users (user_name, user_email, user_password) VALUES 
('juan', 'juan@gmail.com', '1234567'),
('magnus', 'magnus@gmail.com', '1234567'),
('bal', 'bal@gmail.com', '1234567');

<<<<<<< HEAD
-- EJEMPLO DE ORDEN DE PRUEBA
INSERT INTO orders (user_id, order_date, total) VALUES (1, NOW(), 0.00);
=======
<<<<<<< HEAD
-- 5. TABLA DE ORDENES (CARRITO CONFIRMADO)
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `order_date`  DATETIME DEFAULT CURRENT_TIMESTAMP,
  `total` DECIMAL(10,2) DEFAULT 0.00 , 
  PRIMARY KEY (`order_id`),
  FOREIGN KEY(`user_id`) REFERENCES users(user_id) ON DELETE CASCADE
); 

-- 6. TABLA DE ITEMS DE LA ORDEN
CREATE TABLE `order_items` (
  `order_item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id`  int NOT NULL,
  `quantity` int DEFAULT 0, 
  `unit_price` DECIMAL(10,2) DEFAULT 0.00,
  PRIMARY KEY (`order_item_id`),
  FOREIGN KEY(`order_id`) REFERENCES orders(order_id) ON DELETE CASCADE,
  FOREIGN KEY(`product_id`) REFERENCES products(product_id) 
); 

-- EJEMPLO DE ORDEN DE PRUEBA
INSERT INTO orders (user_id, order_date, total) VALUES (1, NOW(), 0.00);

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(1, 1, 2, 99000.00),   -- 2 Monopoly (Precio corregido)
(1, 2, 1, 40000.00);   -- 1 Ajedrez (Precio corregido)

-- Actualizar el total automáticamente
UPDATE orders
SET total = (
  SELECT SUM(quantity * unit_price)
  FROM order_items
  WHERE order_id = 1
)
WHERE order_id = 1;
=======
>>>>>>> 135ed7dd8e8176776e50bb0ceabd05b0527269ac

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES 
(1, 1, 2, 99000.00), 
(1, 2, 1, 40000.00);

-- Actualizar el total automáticamente
UPDATE orders
SET total = (
  SELECT SUM(quantity * unit_price)
  FROM order_items
  WHERE order_id = 1
)
<<<<<<< HEAD
WHERE order_id = 1;
=======
WHERE order_id = ?;

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

WHERE o.order_id = ?;
>>>>>>> 6be29f8da38c91e1d745563fabdc9520ffb85a70
>>>>>>> 135ed7dd8e8176776e50bb0ceabd05b0527269ac
