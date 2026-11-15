-- =============================================================
-- Demo NubeSoft (Grupo 06) - Migración que "trae" un pull request
-- Simula un cambio de esquema que solo debe existir en el branch
-- del PR. Es idempotente: se puede ejecutar varias veces.
-- =============================================================
ALTER TABLE pedido ADD COLUMN IF NOT EXISTS canal VARCHAR(10) NOT NULL DEFAULT 'WEB';
ALTER TABLE pedido ADD COLUMN IF NOT EXISTS total NUMERIC(12,2);

UPDATE pedido p
SET total = s.total
FROM (SELECT pedido_id, sum(cantidad * precio_unit) AS total
      FROM detalle_pedido GROUP BY pedido_id) s
WHERE s.pedido_id = p.id AND p.total IS NULL;

CREATE INDEX IF NOT EXISTS idx_pedido_estado_fecha ON pedido(estado, fecha);

-- Cambio destructivo de prueba: anular pedidos antiguos (solo afecta al branch)
UPDATE pedido SET estado = 'ANULADO' WHERE fecha < DATE '2026-02-01';
