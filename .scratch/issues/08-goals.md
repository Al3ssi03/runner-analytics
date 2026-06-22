## Parent

PRD: PaceUp v1

## What to build

Feature Goal completa: il Runner crea obiettivi personali (gara, passo o volume), l'app calcola il progresso attuale e proietta se riuscirà a raggiungerlo entro la scadenza.

## Acceptance criteria

- [ ] API `POST /goals` accetta: `{ type: "race"|"pace"|"volume", targetValue: number, targetDate: string, label: string }`
- [ ] API `GET /goals` restituisce Goal attivi con progresso calcolato e proiezione
- [ ] API `DELETE /goals/:id` elimina un Goal
- [ ] Tipo **passo**: target in sec/km, progresso = pace medio attuale, proiezione lineare dal trend
- [ ] Tipo **volume**: target km/settimana, progresso = media ultime 4 settimane, proiezione da trend volume
- [ ] Tipo **gara**: target tempo (es. "1:50:00"), progresso = tempo stimato dal race predictor, proiezione da miglioramento pace
- [ ] Tab Obiettivi: lista Goal attivi, barra progresso, label proiezione ("In linea ✅" / "A rischio ⚠️" / "Difficile ❌")
- [ ] Form creazione Goal accessibile dal tab Obiettivi
- [ ] Goal completato: archiviato con data completamento, visibile in sezione "Obiettivi raggiunti"

## Blocked by

- #2 (Strava OAuth + sync)
