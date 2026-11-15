# ACT_SEM13_CLOUD – Demo NubeSoft (Grupo 06)

Demo sin costo de Neon Serverless Postgres: una base aislada (branch) por cada pull request, creada y eliminada con GitHub Actions.

- `sql/` – esquema, datos sintéticos, migración de ejemplo y verificación.
- `.github/workflows/neon-branch-por-pr.yml` – crea el branch al abrir el PR y lo borra al cerrarlo.

Configuración en GitHub (Settings → Secrets and variables → Actions): secret `NEON_API_KEY` y variable `NEON_PROJECT_ID`.

Cambio de prueba: columna canal en pedido
