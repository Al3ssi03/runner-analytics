## Parent

PRD: PaceUp v1

## What to build

Flusso completo di autenticazione via Strava OAuth 2.0 e sync iniziale delle Activity storiche. Il Runner clicca "Connetti con Strava", autorizza l'app, viene rediretto alla Dashboard con i suoi dati già sincronizzati. Include il tab Profilo con avatar, nome e opzione di revoca accesso.

## Acceptance criteria

- [ ] Bottone "Connetti con Strava" nella schermata di login
- [ ] OAuth flow completo: redirect Strava → callback backend → JWT rilasciato al frontend
- [ ] Runner salvato in tabella `runners` (strava_id, name, avatar_url, access_token, refresh_token)
- [ ] Al primo login: sync storico Activity (tutte le run disponibili) con gestione rate limit Strava (200 req/15min)
- [ ] Activity salvate in tabella `activities` (distanza, durata, avg_pace, avg_hr, date, strava_id)
- [ ] Token refresh automatico quando scade
- [ ] Route frontend protette: redirect a login se JWT assente/scaduto
- [ ] Tab Profilo: mostra avatar e nome da Strava, bottone "Disconnetti Strava" che revoca OAuth e cancella JWT
- [ ] Logout pulisce JWT lato client e sessione lato backend

## Blocked by

- #1 (Project scaffold)
