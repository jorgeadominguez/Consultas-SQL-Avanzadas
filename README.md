# 🏨 Consultas SQL Avanzadas - Gestión de Alojamientos Turísticos

Este repositorio contiene la solución a la evaluación práctica de **Consultas SQL Avanzadas**. Se incluyen 20 consultas funcionales que abarcan operaciones CRUD, filtrados, múltiples tipos de JOINs, funciones de agregación y subconsultas.

## 🛠️ Motor de Base de Datos
* **Gestor:** PostgreSQL (Compatible con versiones 14+)
* **Herramientas de ejecución:** DBeaver / pgAdmin / psql

## 🗄️ Esquema de la Base de Datos
El proyecto trabaja sobre una base de datos relacional llamada `accommodations_tourism`, diseñada para gestionar una plataforma de alquiler de alojamientos. A continuación se describe el esquema principal y las relaciones entre sus tablas:

### Tablas Principales (Entidades Fuertes)
* **`owners` (Propietarios):** Almacena la información de los dueños de los alojamientos (nombre, empresa, contacto, país).
* **`guests` (Huéspedes):** Registra a los clientes que realizan reservas (nombre, email, nacionalidad, pasaporte).
* **`locations` (Ubicaciones):** Contiene direcciones detalladas, ciudades, países y coordenadas geográficas.
* **`staff_users` (Empleados):** Gestión de usuarios administrativos del sistema con sus respectivos roles.

### Tablas de Alojamientos y Características
* **`accommodations` (Alojamientos):** Entidad central. Se relaciona con `owners`, `locations` y `accommodation_types`. Almacena el precio base, capacidad y detalles generales de la propiedad.
* **`accommodation_types` (Tipos):** Catálogo de tipos de alojamiento (Hotel, Villa, Casa, etc.).
* **`rooms` (Habitaciones):** Habitaciones específicas dentro de un alojamiento con su capacidad y precio.
* **`amenities` (Comodidades):** Catálogo de servicios (WiFi, Piscina, etc.).
* **`accommodation_amenities`:** Tabla pivote (Many-to-Many) que vincula los alojamientos con sus comodidades.

### Tablas de Transacciones (Operaciones)
* **`bookings` (Reservas):** Tabla transaccional principal. Vincula a los huéspedes (`guests`) con los alojamientos (`accommodations`) y habitaciones (`rooms`). Registra fechas de check-in/out, número de personas y desglose de montos.
* **`booking_statuses` (Estados de Reserva):** Catálogo de estados (Pending, Confirmed, CheckedIn, etc.).
* **`booking_guests` (Acompañantes):** Personas adicionales vinculadas a una reserva específica.
* **`payments` (Pagos):** Registra los pagos realizados para cada reserva (`bookings`), incluyendo montos, métodos de pago y estados de la transacción.
* **`reviews` (Reseñas):** Calificaciones y comentarios dejados por los huéspedes hacia los alojamientos después de su estadía.

---
**Estructura del Repositorio:**
* `consultas_sql.sql`: Archivo principal que contiene las 20 consultas requeridas ejecutables y documentadas mediante comentarios.
