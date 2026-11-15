-- =============================================================
-- Demo NubeSoft (Grupo 06) - Esquema de ejemplo
-- Producto ficticio: "GestiónPedidos" de un cliente de NubeSoft
-- Ejecutar sobre el branch main del proyecto Neon.
-- Solo datos ficticios: NO cargar datos reales ni personales.
-- =============================================================
DROP TABLE IF EXISTS detalle_pedido, pedido, producto, cliente CASCADE;

CREATE TABLE cliente (
    id          SERIAL PRIMARY KEY,
    razon_social VARCHAR(120) NOT NULL,
    ruc         CHAR(11)     NOT NULL UNIQUE,
    ciudad      VARCHAR(60)  NOT NULL,
    creado_en   TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE producto (
    id          SERIAL PRIMARY KEY,
    sku         VARCHAR(20)   NOT NULL UNIQUE,
    nombre      VARCHAR(120)  NOT NULL,
    precio      NUMERIC(10,2) NOT NULL CHECK (precio > 0),
    stock       INTEGER       NOT NULL DEFAULT 0 CHECK (stock >= 0)
);

CREATE TABLE pedido (
    id          SERIAL PRIMARY KEY,
    cliente_id  INTEGER     NOT NULL REFERENCES cliente(id),
    fecha       DATE        NOT NULL,
    estado      VARCHAR(15) NOT NULL DEFAULT 'REGISTRADO'
                CHECK (estado IN ('REGISTRADO','DESPACHADO','ENTREGADO','ANULADO'))
);

CREATE TABLE detalle_pedido (
    pedido_id   INTEGER       NOT NULL REFERENCES pedido(id) ON DELETE CASCADE,
    producto_id INTEGER       NOT NULL REFERENCES producto(id),
    cantidad    INTEGER       NOT NULL CHECK (cantidad > 0),
    precio_unit NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (pedido_id, producto_id)
);

CREATE INDEX idx_pedido_cliente ON pedido(cliente_id);
CREATE INDEX idx_pedido_fecha   ON pedido(fecha);
