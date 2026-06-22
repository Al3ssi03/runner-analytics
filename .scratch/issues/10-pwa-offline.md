## Parent

PRD: PaceUp v1

## What to build

Modalità offline read-only: Dashboard e Obiettivi sono accessibili senza connessione grazie a service worker Workbox e cache IndexedDB delle ultime 12 settimane. Include manifest PWA e install prompt per aggiungere l'app alla home screen.

## Acceptance criteria

- [ ] Vite PWA plugin (Workbox) configurato con strategia cache NetworkFirst per le API, CacheFirst per asset statici
- [ ] Dati Dashboard (Verdict, grafici, training load) cached in IndexedDB dopo ogni caricamento online
- [ ] Dati Obiettivi (lista Goal + progresso) cached in IndexedDB
- [ ] Offline: Dashboard e Obiettivi mostrano i dati cached con banner "Modalità offline — dati aggiornati a [data]"
- [ ] Offline: tab Attività e Profilo mostrano messaggio "Disponibile solo online"
- [ ] Offline: nessuna scrittura (niente creazione Goal offline)
- [ ] `manifest.json` configurato: nome "PaceUp", icona, theme_color, display standalone
- [ ] Install prompt: banner "Aggiungi PaceUp alla home screen" su mobile dopo 2 visite
- [ ] Lighthouse PWA score ≥ 90

## Blocked by

- #4 (Verdict engine + Dashboard)
- #8 (Goal feature)
