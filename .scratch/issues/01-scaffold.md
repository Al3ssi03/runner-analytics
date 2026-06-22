## What to build

Setup completo del monorepo PaceUp: frontend React+Vite+TypeScript, backend Fastify+TypeScript, database PostgreSQL con Drizzle ORM, deployment su Railway, CI GitHub Actions.

Questo slice non ha UI visibile al runner — è la fondamenta su cui poggiano tutti gli altri slice.

## Acceptance criteria

- [ ] Frontend React 18 + Vite + TypeScript avviabile con `npm run dev`
- [ ] Backend Fastify + TypeScript avviabile con `npm run dev`, espone `GET /health` → `{ ok: true }`
- [ ] Drizzle ORM configurato, prima migration eseguita (tabella `runners` vuota)
- [ ] PostgreSQL raggiungibile dal backend in locale via Docker Compose
- [ ] Railway: frontend e backend deployati, variabili d'ambiente configurate
- [ ] GitHub Actions: workflow CI che esegue type-check e build su ogni PR
- [ ] `.env.example` con tutte le variabili richieste documentate

## Blocked by

None — can start immediately
