# PRD — PaceUp v1

## Problema

I runner amatori (30-50 anni, 3-5 uscite/settimana) usano Strava per tracciare le uscite ma non riescono a capire se stanno davvero migliorando. Strava mostra i dati ma non li interpreta. PaceUp risponde a una domanda sola: **stai migliorando?**

## Target user

Runner amatori e semi-esperti, 30-50 anni, già utenti Strava, che corrono 3-5 volte a settimana. Usano smartphone (iOS o Android). Non sono data scientist — vogliono una risposta chiara, non un foglio di calcolo.

## Soluzione

PWA mobile-first che si connette a Strava via OAuth, sincronizza le Activity tramite webhook, calcola un Verdict esplicito di miglioramento e permette al runner di impostare Goal personali con proiezione sul raggiungimento.

---

## Feature scope v1

### 1. Auth — Strava OAuth

- Login esclusivamente via Strava OAuth 2.0
- Al primo login: sync storico completo delle Activity (gestione rate limit Strava)
- Webhook Strava attivo: ogni nuova Activity aggiorna il DB in tempo reale

### 2. Dashboard

Layout: bottom tab bar (4 tab: Dashboard / Obiettivi / Attività / Profilo)

**Hero card — Verdict:**
- Giudizio esplicito: `improving ✅` / `plateau ⚠️` / `regression 🔻`
- Basato su regressione lineare del Pace nelle ultime 12 settimane (Verdict window)
- Indicatore short-term: confronto ultime 4 settimane vs 4 precedenti

**Metriche Tier 1 (sempre visibili):**
- Pace trend (grafico linea, 12 settimane)
- Volume settimanale (km/settimana, barchart)
- CTL / ATL / TSB (training load, area chart)
- Race predictor (5K / 10K / HM — stima da passo attuale)

**Metriche Tier 2 (visibili solo se HR disponibile):**
- HR efficiency trend (passo:FC ratio)
- Aerobic decoupling (HR drift nei lunghi)
- VO2max stimato

### 3. Goal — Obiettivi personali

Tipi supportati:
- **Gara**: "Voglio correre la mezza di Milano in 1h50 entro aprile"
- **Passo**: "Voglio portare il mio passo a 5:30/km entro 3 mesi"
- **Volume**: "Voglio arrivare a 50 km/settimana"

Per ogni Goal:
- Progresso attuale → target
- Scostamento dal target
- Proiezione: "ce la fai entro la scadenza?" (sì / rischio / no)
- Storico dei Goal completati

### 4. Attività

- Lista Activity recenti (scroll infinito)
- Dettaglio singola Activity: mappa GPS, splits, HR se disponibile, confronto vs media personale

### 5. Profilo

- Avatar e nome da Strava
- Stato connessione Strava (revocare accesso)
- Impostazioni notifiche (on/off per tipo)
- Info app (versione, privacy policy)

### 6. Notifiche push (Web Push Protocol)

- **Post-run recap**: inviata dopo ogni sync webhook — "Ottima uscita! 5:42/km, +3% vs media 12 sett."
- **Goal milestone**: quando il runner raggiunge 25% / 50% / 75% / 100% del Goal

### 7. Offline

- Read-only: Dashboard e Obiettivi visibili con dati in cache (service worker + IndexedDB)
- Cache: ultime 12 settimane di Activity
- Nessuna scrittura offline

---

## Tech stack

| Layer | Tecnologia |
|---|---|
| Frontend | React 18 + Vite, TypeScript, Recharts |
| Styling | Tailwind CSS (tema Dark unico in v1) |
| Backend | Fastify + Node.js, TypeScript |
| Database | PostgreSQL |
| ORM | Drizzle ORM |
| Auth | Strava OAuth 2.0 + JWT |
| Push notifications | Web Push Protocol (Vapid) |
| Hosting | Railway (frontend + backend + DB) |
| PWA | Vite PWA plugin (Workbox) |

---

## Architettura a alto livello

```
[Strava API] ──webhook──▶ [Fastify Backend] ──▶ [PostgreSQL]
                                │
                         [JWT Auth]
                                │
                    [React PWA] ◀──── REST API ────┤
                         │                         │
                  [Service Worker]          [Push Notification]
                  [IndexedDB cache]         [Web Push Protocol]
```

---

## Schema DB (entità principali)

- `runners` — id, strava_id, name, avatar_url, access_token, refresh_token
- `activities` — id, runner_id, strava_id, date, distance_m, duration_s, avg_pace, avg_hr, max_hr, suffer_score, polyline
- `goals` — id, runner_id, type (race|pace|volume), target_value, target_date, created_at, completed_at
- `push_subscriptions` — id, runner_id, endpoint, keys

---

## Non incluso in v1 (backlog v2)

- Integrazione FIDAL
- Integrazione Garmin / HRV
- Freemium / Stripe
- Temi UI aggiuntivi (Light Clean, Energy)
- Social features (comparazione con altri runner)
- Coaching AI (suggerimenti allenamento)

---

## Metriche di successo

- Retention 30 giorni > 40% (runner torna almeno 1 volta/settimana)
- Time-to-insight < 10 secondi (dal login al Verdict)
- Sync post-run < 30 secondi dal completamento dell'Activity su Strava

---

*PRD generato dopo sessione /grill-with-docs — 2026-06-23*
