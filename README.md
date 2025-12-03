# Play-Coop — Instrucciones para conectar la BD (.sql) con XAMPP y MySQL Workbench

Este documento explica, paso a paso, cómo importar el archivo .sql de la base de datos y cómo conectar desde una instancia local de MySQL Workbench usando el servidor MySQL proporcionado por XAMPP. Los pasos asumen un entorno local (Windows/macOS/Linux) con XAMPP instalado.

Contenido:
- Requisitos
- 1) Usando XAMPP + phpMyAdmin (importar .sql)
- 2) Usando la línea de comandos MySQL (importar .sql)
- 3) Conectar MySQL Workbench a la instancia de XAMPP
- 4) Configurar la aplicación (ejemplos de variables de conexión)
- 5) Problemas frecuentes y soluciones
- 6) Buenas prácticas

Requisitos
- XAMPP instalado y funcionando (https://www.apachefriends.org)
- Archivo de volcado de la base de datos: ejemplo `database_dump.sql` (colócalo en una carpeta accesible)
- MySQL Workbench instalado (opcional, para administración desde GUI)
- Conocimientos básicos de terminal/panel de control de XAMPP

1) Usando XAMPP + phpMyAdmin (importar .sql)
1. Abre el XAMPP Control Panel y arranca el servicio MySQL (y Apache si necesitas phpMyAdmin vía web).
2. Abre phpMyAdmin en el navegador: http://localhost/phpmyadmin
3. (Opcional) Crea una nueva base de datos:
   - Haz clic en "Databases" → escribe el nombre (por ejemplo `play_coop_db`) → "Create".
4. Selecciona la base de datos creada en la columna de la izquierda.
5. Ve a la pestaña "Import".
6. En "File to import" haz clic en "Choose file" y selecciona `database_dump.sql`.
7. Ajusta opciones si tu dump tiene una codificación distinta (normalmente UTF-8) y presiona "Go".
8. phpMyAdmin mostrará un mensaje de éxito o error. En caso de error, revisa el mensaje (problemas comunes: tamaño del archivo, límites de upload en php.ini).

2) Usando la línea de comandos MySQL (importar .sql)
- Localiza el binario `mysql` incluido en XAMPP:
  - Windows típico: `C:\xampp\mysql\bin\mysql.exe`
  - macOS/Linux: `/Applications/XAMPP/xamppfiles/bin/mysql` o `mysql` si está en PATH
- Comando para importar (ejemplo Windows / general):
  - Crear la BD (si no existe):
    - mysql -u root -p -e "CREATE DATABASE play_coop_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
  - Importar el archivo:
    - mysql -u root -p play_coop_db < path/to/database_dump.sql
  - Se te pedirá la contraseña del usuario (por defecto, XAMPP suele usar `root` sin contraseña; presiona Enter si está vacía).

3) Conectar MySQL Workbench a la instancia de XAMPP
1. Asegúrate de que el servicio MySQL esté en ejecución desde el XAMPP Control Panel.
2. Abre MySQL Workbench.
3. Crea una nueva conexión:
   - Click en "+" junto a "MySQL Connections".
   - Connection Name: `Play-Coop (local XAMPP)` u otro nombre.
   - Connection Method: Standard (TCP/IP).
   - Hostname: `127.0.0.1` o `localhost`
   - Port: `3306` (verifica en XAMPP si está usando otro puerto)
   - Username: `root` (por defecto en XAMPP)
   - Password: dejar vacío o configurar "Store in Vault..." si tienes contraseña
4. Test Connection: si todo está bien, Workbench se conectará y mostrará OK.
5. Para importar un .sql desde Workbench:
   - Menú: Server → Data Import.
   - Selecciona "Import from Self-Contained File" y elige `database_dump.sql`.
   - Selecciona la base de datos destino (o marca "New" para crearla) y pulsa "Start Import".

4) Configurar la aplicación (ejemplos)
- Variables comunes:
  - DB_HOST=127.0.0.1
  - DB_PORT=3306
  - DB_USER=root
  - DB_PASS= (vacío por defecto en XAMPP)
  - DB_NAME=play_coop_db

Ejemplo Node.js (mysql2):
const pool = mysql.createPool({
  host: process.env.DB_HOST || '127.0.0.1',
  port: Number(process.env.DB_PORT) || 3306,
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASS || '',
  database: process.env.DB_NAME || 'play_coop_db'
});

Ejemplo PHP (PDO):
$dsn = "mysql:host=127.0.0.1;port=3306;dbname=play_coop_db;charset=utf8mb4";
$pdo = new PDO($dsn, 'root', '');

Ajusta los ejemplos al lenguaje y biblioteca que uses en el proyecto.

5) Problemas frecuentes y soluciones
- Error de conexión (ECONNREFUSED):
  - Verifica que MySQL está en ejecución en XAMPP.
  - Asegúrate de usar 127.0.0.1 y puerto 3306 (o el que muestre XAMPP).
- Archivo .sql muy grande:
  - phpMyAdmin puede tener límites de upload; usa la línea de comandos o MySQL Workbench.
- Permisos / usuario root sin contraseña:
  - Para producción crea un usuario con permisos mínimos y una contraseña fuerte.
- Puerto 3306 en uso:
  - Revisa qué proceso usa el puerto o cambia el puerto de MySQL en XAMPP (my.ini/my.cnf) y actualiza la conexión en Workbench/proyecto.

6) Buenas prácticas
- No usar root para la aplicación; crea un usuario específico:
  - En MySQL:
    - CREATE USER 'play_user'@'localhost' IDENTIFIED BY 'tu_password';
    - GRANT ALL PRIVILEGES ON play_coop_db.* TO 'play_user'@'localhost';
    - FLUSH PRIVILEGES;
- Mantener copias del .sql fuera del directorio público del servidor.
- Documentar la versión de MySQL esperada (incompatibilidades posibles entre versiones).

  - Crear un archivo `.env.example` con las variables de conexión.
  - Adaptar las instrucciones al framework/lenguaje específico del proyecto si me indicas cuál usan.
