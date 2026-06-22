## Parent

PRD: PaceUp v1

## What to build

Sistema di notifiche push Web Push (Vapid) con due trigger: post-run recap dopo ogni nuova Activity sincronizzata via webhook, e goal milestone quando il Runner raggiunge 25/50/75/100% di un Goal.

## Acceptance criteria

- [ ] Backend genera coppia chiavi Vapid all'avvio (configurabili via env)
- [ ] API `POST /push/subscribe` salva la subscription del browser in tabella `push_subscriptions`
- [ ] API `DELETE /push/subscribe` rimuove la subscription (per il toggle nelle impostazioni)
- [ ] Dopo ogni webhook Activity (#3): notifica "Post-run recap" con pace medio, distanza e confronto vs media personale
- [ ] Dopo ogni aggiornamento progresso Goal (#8): notifica al raggiungimento di 25%, 50%, 75%, 100%
- [ ] Tab Profilo: toggle "Notifiche attive" che abilita/disabilita subscription
- [ ] Gestione subscription scadute/rifiutate: rimozione silenziosa dal DB
- [ ] Le notifiche funzionano anche con il browser chiuso (service worker)

## Blocked by

- #3 (Strava webhook)
- #8 (Goal feature)
