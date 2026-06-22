# Domain context — runner analytics app

## Canonical terms
- **Runner**: utente che registra le proprie uscite di corsa
- **Activity**: singola sessione di corsa (distanza, durata, HR, RPE)
- **Training load**: carico allenamento settimanale aggregato
- **Pace**: minuti per km (formato mm:ss)
- **RPE**: perceived exertion 1-10, inserito manualmente dal runner
- **Streak**: giorni consecutivi con almeno una activity

## Avoid
- "workout" → usa Activity
- "exercise" → usa Activity  
- "user" → usa Runner
- "session" → usa Activity