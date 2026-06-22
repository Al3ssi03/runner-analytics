# Domain context — PaceUp

## Canonical terms

- **Runner**: utente che registra le proprie uscite di corsa
- **Activity**: singola sessione di corsa (distanza, durata, HR, RPE)
- **Training load**: carico allenamento settimanale aggregato
- **Pace**: minuti per km (formato mm:ss)
- **RPE**: perceived exertion 1-10, inserito manualmente dal runner
- **Streak**: giorni consecutivi con almeno una Activity
- **Verdict**: giudizio esplicito di miglioramento mostrato al runner (improving ✅ / plateau ⚠️ / regression 🔻), calcolato su 12 settimane
- **CTL**: Chronic Training Load — media ponderata 42 giorni del carico allenante
- **ATL**: Acute Training Load — media ponderata 7 giorni del carico allenante
- **TSB**: Training Stress Balance — CTL meno ATL, indica la freschezza del runner
- **Race predictor**: stima del tempo gara (5K / 10K / HM) calcolata dal passo attuale del runner
- **HR efficiency**: rapporto passo:FC nel tempo — migliora = runner più efficiente aerobicamente
- **Aerobic decoupling**: deriva della FC durante le uscite lunghe — segnale di sovrallenamento
- **Goal**: obiettivo personale del runner (tipo: gara | passo | volume) con target numerico e scadenza
- **Post-run recap**: notifica push inviata automaticamente dopo ogni sync di un'Activity da Strava via webhook
- **Verdict window**: finestra di valutazione del Verdict — 12 settimane principale, 4 settimane short-term

## Avoid

- "workout" → usa Activity
- "exercise" → usa Activity
- "user" → usa Runner
- "session" → usa Activity
- "score" → usa Verdict
- "goal" in italiano → usa Goal (termine tecnico) o "obiettivo" nel testo UI

## Metric tiers

- **Tier 1** — sempre disponibili (nessun hardware extra): pace trend, volume settimanale, CTL/ATL/TSB, Race predictor
- **Tier 2** — disponibili solo se il runner usa cardiofrequenzimetro: HR efficiency, Aerobic decoupling, VO2max stimato

## v2 backlog (non implementare in v1)

- Integrazione FIDAL (gare passate + iscrizioni future)
- Integrazione Garmin Connect (HRV, recovery metrics)
- Freemium monetization (Stripe)
- Temi aggiuntivi (Light Clean, Energy) — v1 ha solo Dark
