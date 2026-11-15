-- =============================================================
-- Demo NubeSoft (Grupo 06) - Verificación de aislamiento
-- Ejecutar en main y en el branch del PR y comparar resultados.
-- =============================================================
-- 1) ¿Existe la columna nueva? (en main: 0 filas; en el branch: 2 filas)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'pedido' AND column_name IN ('canal','total');

-- 2) Pedidos anulados (en el branch serán más que en main)
SELECT estado, count(*) AS pedidos
FROM pedido GROUP BY estado ORDER BY estado;

-- 3) Consulta representativa del producto: ventas por ciudad
SELECT c.ciudad, count(DISTINCT p.id) AS pedidos,
       sum(d.cantidad * d.precio_unit)::numeric(14,2) AS ventas
FROM pedido p
JOIN cliente c        ON c.id = p.cliente_id
JOIN detalle_pedido d ON d.pedido_id = p.id
WHERE p.estado <> 'ANULADO'
GROUP BY c.ciudad ORDER BY ventas DESC;

-- 4) Versión del motor (PostgreSQL estándar)
SELECT version();
