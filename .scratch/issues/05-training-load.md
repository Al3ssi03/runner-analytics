## Parent

PRD: PaceUp v1

## What to build

Metriche di training load (CTL, ATL, TSB) e Race predictor nella Dashboard. Il Runner vede quanto è fresco/affaticato e una stima del suo tempo su 5K, 10K e mezza maratona.

CTL = media esponenziale 42 giorni del Training Stress Score (TSS) giornaliero.
ATL = media esponenziale 7 giorni del TSS.
TSB = CTL − ATL (positivo = fresco, negativo = affaticato).
TSS di ogni Activity calcolato da durata e suffer score Strava (o stima da pace se suffer score assente).

## Acceptance criteria

- [ ] API `GET /analytics/training-load` restituisce CTL, ATL, TSB correnti e serie storica 12 settimane
- [ ] Area chart CTL/ATL in Dashboard con legenda
- [ ] Indicatore TSB corrente con label "Fresco" (> +10) / "In forma" (-10..+10) / "Affaticato" (< -10)
- [ ] API `GET /analytics/race-predictor` restituisce stime per 5K, 10K, 21K basate sul pace medio recente (formula di Riegel)
- [ ] Card Race predictor in Dashboard con 3 distanze e tempi stimati
- [ ] Aggiornamento automatico dopo ogni nuova Activity (via webhook #3)

## Blocked by

- #4 (Verdict engine + Dashboard)
