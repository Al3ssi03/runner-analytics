## Parent

PRD: PaceUp v1

## What to build

Integrazione webhook Strava per sincronizzazione in tempo reale. Ogni volta che il Runner completa una corsa su Strava, il backend riceve l'evento, inserisce la nuova Activity nel DB e il frontend si aggiorna senza che il Runner debba fare nulla.

## Acceptance criteria

- [ ] Endpoint `POST /webhooks/strava` che verifica la firma Strava (header `X-Hub-Signature`)
- [ ] Gestione evento `activity.create`: fetch Activity da Strava API e insert in `activities`
- [ ] Gestione evento `activity.update` e `activity.delete`: aggiorna/rimuove dal DB
- [ ] Subscription webhook registrata su Strava (challenge `GET /webhooks/strava`)
- [ ] Frontend polling o WebSocket: nuova Activity visibile nella tab Attività entro 30 secondi dal completamento su Strava
- [ ] Idempotenza: doppio webhook per stessa Activity non crea duplicati

## Blocked by

- #2 (Strava OAuth + sync)
