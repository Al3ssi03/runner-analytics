## Parent

PRD: PaceUp v1

## What to build

Motore del Verdict e prima versione della Dashboard. Il Runner apre l'app e vede immediatamente un giudizio chiaro ("Stai migliorando ✅"), con il grafico del passo nelle ultime 12 settimane e il volume settimanale.

Il Verdict si basa su regressione lineare del pace su 12 settimane (trend principale) combinata con confronto delle ultime 4 settimane vs le 4 precedenti (indicatore short-term).

## Acceptance criteria

- [ ] API `GET /analytics/verdict` restituisce: `{ verdict: "improving"|"plateau"|"regression", slope: number, shortTerm: "up"|"neutral"|"down", dataPoints: number }`
- [ ] Verdict "improving" se slope negativa (pace migliora) e short-term "up"
- [ ] Verdict "plateau" se slope < soglia di significatività statistica
- [ ] Verdict "regression" se slope positiva e short-term "down"
- [ ] Hero card Dashboard: Verdict con icona e colore (verde/giallo/rosso)
- [ ] Grafico pace trend (linea, 12 settimane) con linea di regressione sovrapposta
- [ ] Barchart volume settimanale (km/settimana, ultimi 12 settimane)
- [ ] Se dati insufficienti (< 4 settimane di Activity): messaggio "Continua ad allenarti, torni tra qualche settimana"
- [ ] Tema Dark applicato a tutta la Dashboard

## Blocked by

- #2 (Strava OAuth + sync)
