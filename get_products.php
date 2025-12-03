<?php
/**
 * Play&Coop: API para obtener el listado de productos desde la Base de Datos.
 */

// Headers
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *'); // En producción restringe esto al dominio de tu app

// 1. Configuración de la Base de Datos (DB)
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "play";

// 2. Crear la Conexión
$conn = new mysqli($servername, $username, $password, $dbname);

// 3. Verificar la Conexión
if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(["error" => "Error de conexión con MySQL: " . $conn->connect_error]);
    exit;
}

// 4. Consulta SQL para obtener todos los productos
$sql = "SELECT product_id, product_name, product_desc, price, stock, product_category FROM products";
$result = $conn->query($sql);

$products = array();

if ($result === false) {
    // Error en la consulta SQL
    http_response_code(500);
    echo json_encode(["error" => "Error en la consulta SQL: " . $conn->error]);
    $conn->close();
    exit;
}

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        // Normalizar tipos (especialmente price a float)
        if (isset($row['price'])) {
            $row['price'] = (float)$row['price'];
        }
        // Aseguramos que product_id sea int para coherencia en el front
        if (isset($row['product_id'])) {
            $row['product_id'] = (int)$row['product_id'];
        }
        $products[] = $row;
    }
}

// 5. Cerrar la conexión y devolver los datos
$conn->close();

// Respuesta: por compatibilidad devolvemos directamente el array de productos
// Si no hay productos, devolvemos un array vacío (tu JS lo manejará).
echo json_encode($products);
