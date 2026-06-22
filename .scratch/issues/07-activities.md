## Parent

PRD: PaceUp v1

## What to build

Tab Attività con lista delle run recenti e schermata di dettaglio per ogni Activity. Il Runner può scorrere le sue uscite e vedere i dati di ogni singola corsa con confronto rispetto alla sua media personale.

## Acceptance criteria

- [ ] API `GET /activities?page=N&limit=20` con paginazione cursor-based
- [ ] Tab Attività: lista con scroll infinito — ogni riga mostra data, distanza, pace medio, durata
- [ ] Pull-to-refresh che forza sync da Strava API
- [ ] Schermata dettaglio Activity (navigazione da lista): mappa GPS (polyline Strava su mappa leggera), splits km per km, pace e HR per split se disponibile
- [ ] Badge confronto: pace di questa Activity vs media personale ultime 12 settimane (es. "+3% più veloce del solito")
- [ ] Gestione Activity senza GPS (es. treadmill): mappa assente, solo dati numerici

## Blocked by

- #2 (Strava OAuth + sync)
