-- =============================================================
-- Demo NubeSoft (Grupo 06) - Datos de prueba sintéticos
-- Genera ~1 000 clientes, 300 productos, 20 000 pedidos y
-- ~60 000 líneas de detalle con generate_series (datos ficticios).
-- =============================================================
INSERT INTO cliente (razon_social, ruc, ciudad)
SELECT 'Empresa Demo ' || g,
       lpad((20000000000 + g)::text, 11, '0'),
       (ARRAY['Lima','Arequipa','Trujillo','Cusco','Piura','Chiclayo'])[1 + (g % 6)]
FROM generate_series(1, 1000) AS g;

INSERT INTO producto (sku, nombre, precio, stock)
SELECT 'SKU-' || lpad(g::text, 5, '0'),
       'Producto de prueba ' || g,
       round((5 + random() * 495)::numeric, 2),
       (random() * 500)::int
FROM generate_series(1, 300) AS g;

INSERT INTO pedido (cliente_id, fecha, estado)
SELECT 1 + (random() * 999)::int,
       DATE '2026-01-01' + (random() * 300)::int,
       (ARRAY['REGISTRADO','DESPACHADO','ENTREGADO','ANULADO'])[1 + (random() * 3)::int]
FROM generate_series(1, 20000);

INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unit)
SELECT p.id, pr.id, 1 + (random() * 9)::int, pr.precio
FROM pedido p
CROSS JOIN LATERAL (
    SELECT id, precio FROM producto
    WHERE p.id > 0                      -- fuerza re-evaluación por fila
    ORDER BY random() LIMIT 3
) pr
ON CONFLICT DO NOTHING;

ANALYZE;

-- Resumen de lo cargado
SELECT 'cliente' AS tabla, count(*) FROM cliente
UNION ALL SELECT 'producto', count(*) FROM producto
UNION ALL SELECT 'pedido', count(*) FROM pedido
UNION ALL SELECT 'detalle_pedido', count(*) FROM detalle_pedido;
