CREATE DATABASE play;
use play;

CREATE TABLE `products` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `product_name` varchar(50) NOT NULL,
  `product_desc` text DEFAULT NULL,
  `price` DECIMAL(10,2) DEFAULT 0.00,
  `stock` int DEFAULT 0,
  `product_category` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`product_id`) 
); 	

INSERT INTO products (product_name, product_desc, price, stock, product_category) 
VALUES 
('monopoly', 
'¡Arriésgalo todo o quiebra en el intento en el juego de mesa Monopoly! En esta edición del divertido juego de mesa para toda la familia, diviértete jugando el clásico juego que tanto adoran los fans; ahora con características mejoradas. Hemos incluido una elegante bandeja de almacenamiento para guardar el dinero, las cartas y los componentes de manera bien organizada. También hemos aumentado el tamaño de los peones, casas y hoteles comparados con los de las ediciones anteriores para facilitar el manejo de estos componentes. Los jugadores recorren el tablero comprando todas las propiedades que puedan. Mientras más posean, más alquiler podrán cobrar de los demás. ¡El último con dinero, cuando ya los demás estén en bancarrota, será el ganador! Este juego de mesa familiar para niños y adultos es una fantástica opción.',
99.000, 20, 'juego de mesa'),

('ajedrez',
'El ajedrez es un juego de estrategia que se juega entre dos jugadores en un tablero de 64 casillas, donde cada jugador controla 16 piezas con el objetivo de "jaque mate" al rey del oponente',
40.000, 35, 'juego de mesa'),

('damas chinas', 
'Las damas chinas es un juego de mesa de estrategia que se juega en un tablero en forma de estrella, donde el objetivo es mover todas tus piezas al triángulo opuesto antes que tus oponentes',
35.000, 15, 'juego de mesa'),

('parques',
'El parqués es un juego de mesa que se juega con dos dados y se puede jugar de 2 a 8 jugadores. El objetivo del juego es mover todas las fichas desde la "cárcel" (casilla inicial) hasta la "cielo" (casilla central). Los movimientos se determinan mediante el lanzamiento de los dados, y una vez que las fichas están cerca del "cielo", se usa solo un dado. El parqués es un juego que combina suerte y estrategia, y es considerado un "juego de azar razonado" o de "pensamiento aleatorio"',
44.000, 10, 'juego de mesa'),

('Scrabble',
'El clásico juego de palabras donde los jugadores forman términos en un tablero con fichas de letras. Gana quien acumule más puntos creando palabras estratégicas. Ideal para mejorar vocabulario y pasar horas de diversión en familia.',
85.000, 25, 'juego de mesa'),

('Jenga',
'Juego de destreza física y mental en el que los jugadores retiran bloques de madera de una torre y los colocan en la parte superior sin que se derrumbe. Perfecto para reuniones sociales.',
65.000, 30, 'juego de mesa'),

('Uno',
'Juego de cartas rápido y dinámico donde el objetivo es quedarse sin cartas antes que los demás. Incluye cartas especiales que cambian el rumbo de la partida. Muy popular entre niños y adultos.',
35.000, 50, 'juego de mesa'),

('Risk',
'Juego de estrategia militar en el que los jugadores buscan conquistar territorios en un mapa mundial. Combina suerte con dados y planificación táctica. Ideal para quienes disfrutan largas partidas.',
120.000, 18, 'juego de mesa'),

('Catan',
'Juego de colonización y comercio donde los jugadores construyen poblados y carreteras en una isla ficticia. Se negocian recursos como madera, trigo y piedra para expandirse. Muy popular en Colombia.',
160.000, 12, 'juego de mesa'),

('Twister',
'Juego físico y divertido en el que los jugadores deben colocar manos y pies en círculos de colores según las instrucciones de una ruleta. Perfecto para fiestas y reuniones familiares.',
70.000, 20, 'juego de mesa'),

('Trivial Pursuit',
'Juego de preguntas y respuestas de cultura general. Los jugadores avanzan en el tablero respondiendo correctamente en categorías como historia, ciencia y entretenimiento.',
110.000, 10, 'juego de mesa'),

('Clue',
'Juego de misterio en el que los jugadores deben descubrir quién cometió un asesinato, con qué arma y en qué lugar. Combina deducción y lógica.',
95.000, 15, 'juego de mesa'),

('Domino',
'Juego tradicional con fichas rectangulares divididas en dos partes con puntos. El objetivo es colocar fichas coincidiendo números hasta quedarse sin piezas.',
30.000, 40, 'juego de mesa'),

('Backgammon',
'Juego clásico de estrategia con dados, donde los jugadores mueven fichas en un tablero con el objetivo de sacarlas todas antes que el rival.',
75.000, 12, 'juego de mesa'),

('Pictionary',
'Juego de dibujo y adivinanza. Los jugadores deben representar palabras o frases mediante dibujos para que su equipo las adivine en tiempo limitado.',
90.000, 18, 'juego de mesa'),

('Bingo',
'Juego de azar en el que los jugadores marcan números en cartones conforme se van cantando. El primero en completar una línea o cartón gana.',
40.000, 25, 'juego de mesa'),

('Labyrinth',
'Juego de tablero en el que los jugadores deben encontrar tesoros moviendo pasillos en un laberinto cambiante. Combina estrategia y memoria.',
85.000, 10, 'juego de mesa'),

('Carcassonne',
'Juego de colocación de losetas donde los jugadores construyen ciudades, caminos y campos medievales. Se gana sumando puntos por las áreas controladas.',
150.000, 8, 'juego de mesa'),

('Yahtzee',
'Juego de dados en el que los jugadores buscan formar combinaciones como póker, full o escalera. Gana quien acumule más puntos en la hoja de puntuación.',
55.000, 20, 'juego de mesa');



CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `user_name` varchar(50) NOT NULL,
  `user_email` varchar(50) NOT NULL UNIQUE,
  `user_password` varchar(60) NOT NULL, 
  PRIMARY KEY (`user_id`)
); 

INSERT INTO users (user_name, user_email, user_password)
VALUES 
('juan', 'juan@gmail.com', '1234567'),
('magnus', 'magnus@gmail.com', '1234567'),
('bal', 'bal@gmail.com', '1234567');



CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `order_date`  DATETIME DEFAULT CURRENT_TIMESTAMP,
  `total` DECIMAL(10,2) DEFAULT 0.00 , 
  PRIMARY KEY (`order_id`),
  foreign key(`user_id`) references users(user_id) ON DELETE CASCADE
); 

CREATE TABLE `order_items` (
  `order_item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id`  int NOT NULL,
  `quantity` int DEFAULT 0, 
  `unit_price` DECIMAL(10,2) DEFAULT 0.00,
  PRIMARY KEY (`order_item_id`),
  foreign key(`order_id`) references orders(order_id) ON DELETE CASCADE,
  foreign key(`product_id`) references products(product_id) 
); 


