-- ==============================================================================
-- 🧾 SCRIPT DE CONSULTAS SQL AVANZADAS - GESTIÓN DE ALOJAMIENTOS TURÍSTICOS
-- Autor: [Tu Nombre/Usuario]
-- Motor de Base de Datos: PostgreSQL
-- Descripción: 20 Consultas CRUD, JOINs y de Agregación para evaluación.
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 01 | INSERT | Insertar propietario
-- Agrega un nuevo propietario a la base de datos.
-- ------------------------------------------------------------------------------
INSERT INTO owners (first_name, last_name, company_name, email, phone, country) 
VALUES ('Carlos', 'Mendoza', 'Inversiones CM', 'cmendoza@example.com', '+503 7000-0000', 'El Salvador');

-- ------------------------------------------------------------------------------
-- 02 | INSERT | Insertar alojamiento
-- Crea un alojamiento vinculado al propietario recién creado (asumiendo ID 21),
-- un tipo de alojamiento (1=Hotel) y una ubicación (1).
-- ------------------------------------------------------------------------------
INSERT INTO accommodations (owner_id, accommodation_type_id, location_id, name, description, max_guests, bedroom_count, bathroom_count, base_price_per_night, currency_code)
VALUES (
    (SELECT MAX(owner_id) FROM owners), 
    1, 1, 'Hotel San Salvador Centro', 'Hotel céntrico con excelentes vistas.', 
    4, 2, 1, 85.50, 'USD'
);

-- ------------------------------------------------------------------------------
-- 03 | INSERT | Huésped y reserva
-- Registra un huésped y seguidamente su reserva para el alojamiento 1.
-- ------------------------------------------------------------------------------
INSERT INTO guests (first_name, last_name, email, nationality)
VALUES ('Lucia', 'Ramirez', 'lramirez@example.com', 'Costa Rica');

INSERT INTO bookings (guest_id, accommodation_id, booking_status_id, check_in_date, check_out_date, adult_count, subtotal_amount, tax_amount, total_amount, booking_reference)
VALUES (
    (SELECT MAX(guest_id) FROM guests), 
    1, 1, '2026-10-01', '2026-10-05', 2, 200.00, 26.00, 226.00, 'BK-NUEVA2026'
);

-- ------------------------------------------------------------------------------
-- 04 | INSERT | Insertar pago
-- Registra el pago para la reserva recién creada.
-- ------------------------------------------------------------------------------
INSERT INTO payments (booking_id, amount, payment_method, payment_status, transaction_reference)
VALUES (
    (SELECT MAX(booking_id) FROM bookings), 
    226.00, 'CreditCard', 'Completed', 'TXN-99887766'
);

-- ------------------------------------------------------------------------------
-- 05 | SELECT | Alojamientos activos
-- Filtra todos los alojamientos que están actualmente activos para recibir reservas.
-- ------------------------------------------------------------------------------
SELECT accommodation_id, name, base_price_per_night 
FROM accommodations 
WHERE is_active = true;

-- ------------------------------------------------------------------------------
-- 06 | SELECT | Huéspedes por país
-- Filtra los huéspedes por una nacionalidad específica (ej. 'México').
-- ------------------------------------------------------------------------------
SELECT guest_id, first_name, last_name, email 
FROM guests 
WHERE nationality = 'México';

-- ------------------------------------------------------------------------------
-- 07 | SELECT | Reservas por fechas
-- Muestra reservas usando BETWEEN para un rango de fechas de check-in.
-- ------------------------------------------------------------------------------
SELECT booking_id, booking_reference, check_in_date, check_out_date 
FROM bookings 
WHERE check_in_date BETWEEN '2025-06-01' AND '2025-12-31';

-- ------------------------------------------------------------------------------
-- 08 | UPDATE | Actualizar precio
-- Modifica el precio base por noche de un alojamiento específico (ID = 1).
-- ------------------------------------------------------------------------------
UPDATE accommodations 
SET base_price_per_night = base_price_per_night * 1.10 
WHERE accommodation_id = 1;

-- ------------------------------------------------------------------------------
-- 09 | UPDATE | Estado reserva
-- Actualiza el estado de una reserva específica a "Confirmed" (ID 2).
-- ------------------------------------------------------------------------------
UPDATE bookings 
SET booking_status_id = 2 
WHERE booking_reference = 'BK-NUEVA2026';

-- ------------------------------------------------------------------------------
-- 10 | DELETE | Eliminar reseña
-- Elimina una reseña específica utilizando su ID con un WHERE seguro.
-- ------------------------------------------------------------------------------
DELETE FROM reviews 
WHERE review_id = 10;

-- ------------------------------------------------------------------------------
-- 11 | JOIN | Reservas + huésped
-- Muestra la información de la reserva junto con los datos del huésped (INNER JOIN).
-- ------------------------------------------------------------------------------
SELECT b.booking_reference, b.check_in_date, g.first_name, g.last_name, g.email
FROM bookings b
INNER JOIN guests g ON b.guest_id = g.guest_id;

-- ------------------------------------------------------------------------------
-- 12 | JOIN | Alojamiento completo
-- INNER JOIN múltiple uniendo alojamientos, propietarios, tipos y ubicaciones.
-- ------------------------------------------------------------------------------
SELECT a.name AS accommodation, t.type_name, o.first_name AS owner_name, l.city, l.country
FROM accommodations a
INNER JOIN accommodation_types t ON a.accommodation_type_id = t.accommodation_type_id
INNER JOIN owners o ON a.owner_id = o.owner_id
INNER JOIN locations l ON a.location_id = l.location_id;

-- ------------------------------------------------------------------------------
-- 13 | JOIN | Pagos + reservas
-- JOIN combinado para ver el monto pagado, el método, la reserva y el huésped.
-- ------------------------------------------------------------------------------
SELECT p.payment_id, p.amount, p.payment_method, b.booking_reference, g.first_name
FROM payments p
INNER JOIN bookings b ON p.booking_id = b.booking_id
INNER JOIN guests g ON b.guest_id = g.guest_id;

-- ------------------------------------------------------------------------------
-- 14 | LEFT JOIN | Sin reseñas
-- Muestra todos los alojamientos, incluyendo aquellos que no tienen ninguna reseña.
-- ------------------------------------------------------------------------------
SELECT a.accommodation_id, a.name, r.review_id, r.rating
FROM accommodations a
LEFT JOIN reviews r ON a.accommodation_id = r.accommodation_id;

-- ------------------------------------------------------------------------------
-- 15 | LEFT JOIN | Sin reservas
-- Filtra huéspedes registrados en el sistema que NUNCA han hecho una reserva.
-- ------------------------------------------------------------------------------
SELECT g.guest_id, g.first_name, g.last_name, g.email
FROM guests g
LEFT JOIN bookings b ON g.guest_id = b.guest_id
WHERE b.booking_id IS NULL;

-- ------------------------------------------------------------------------------
-- 16 | AGG | Total ingresos
-- Suma el total de dinero recaudado por pagos con estado 'Completed'.
-- ------------------------------------------------------------------------------
SELECT SUM(amount) AS total_ingresos_completados
FROM payments
WHERE payment_status = 'Completed';

-- ------------------------------------------------------------------------------
-- 17 | AGG | Promedio rating
-- Calcula el promedio de calificación (rating) por cada alojamiento.
-- ------------------------------------------------------------------------------
SELECT a.name, ROUND(AVG(r.rating), 2) AS promedio_estrellas
FROM reviews r
INNER JOIN accommodations a ON r.accommodation_id = a.accommodation_id
GROUP BY a.name;

-- ------------------------------------------------------------------------------
-- 18 | AGG | Top alojamientos
-- Cuenta el número de reservas por alojamiento y muestra el top 5.
-- ------------------------------------------------------------------------------
SELECT a.name, COUNT(b.booking_id) AS cantidad_reservas
FROM bookings b
INNER JOIN accommodations a ON b.accommodation_id = a.accommodation_id
GROUP BY a.name
ORDER BY cantidad_reservas DESC
LIMIT 5;

-- ------------------------------------------------------------------------------
-- 19 | HAVING | Más de 3 reservas
-- Agrupa a los huéspedes y muestra solo a los que tienen más de 3 reservas.
-- ------------------------------------------------------------------------------
SELECT g.first_name, g.last_name, COUNT(b.booking_id) AS total_reservas
FROM bookings b
INNER JOIN guests g ON b.guest_id = g.guest_id
GROUP BY g.first_name, g.last_name
HAVING COUNT(b.booking_id) > 3;

-- ------------------------------------------------------------------------------
-- 20 | Subconsulta | Alojamiento más caro
-- Utiliza una subquery para encontrar el alojamiento con el precio por noche más alto.
-- ------------------------------------------------------------------------------
SELECT name, base_price_per_night, currency_code
FROM accommodations
WHERE base_price_per_night = (
    SELECT MAX(base_price_per_night) 
    FROM accommodations
);