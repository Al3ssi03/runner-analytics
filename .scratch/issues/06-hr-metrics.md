## Parent

PRD: PaceUp v1

## What to build

Metriche Tier 2 basate sulla frequenza cardiaca, visibili solo se il Runner usa un cardiofrequenzimetro. Include HR efficiency trend, aerobic decoupling e stima VO2max.

HR efficiency = pace (sec/km) diviso avg_hr: scende nel tempo = runner più efficiente.
Aerobic decoupling = differenza % tra HR efficiency nella prima e seconda metà delle uscite lunghe (> 12km).
VO2max stimato = formula da pace e FC (Jack Daniels / Strava method).

## Acceptance criteria

- [ ] API `GET /analytics/hr-metrics` restituisce HR efficiency trend, decoupling medio, VO2max stimato — solo se il Runner ha almeno 4 Activity con dati HR nelle ultime 12 settimane
- [ ] Se dati HR insufficienti: sezione non mostrata in Dashboard (non un errore, semplicemente assente)
- [ ] Grafico HR efficiency trend (linea, 12 settimane)
- [ ] Indicatore aerobic decoupling: "Buona resistenza aerobica" (< 5%) / "Attenzione al volume" (5-10%) / "Riduci il ritmo" (> 10%)
- [ ] Card VO2max con valore stimato e fascia di riferimento per età/sesso

## Blocked by

- #4 (Verdict engine + Dashboard)
