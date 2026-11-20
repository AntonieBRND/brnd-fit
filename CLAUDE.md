# BRND FIT – werkafspraken voor Claude

Fitness-app (PWA) voor Antonie en Mels. Live: https://antoniebrnd.github.io/brnd-fit/

## Taal en stijl
- Antwoord en schrijf UI-teksten in het Nederlands: kort, informeel, geen em dash (—).
- Stijl: donker (navy/zwart), blauw accent, oranje CTA, pixel-cijfers (Doto-font) en pixel-icoontjes, subtiele animaties, high-end.

## Structuur
- `src/app.html` – de hele app (HTML + CSS + JS in één bestand). **Hier pas je alles aan.**
- `tools/build.mjs` – maakt `index.html` uit `src/app.html` (voegt `<head>`, `config.js` en supabase-js toe).
- `index.html` – gegenereerd. Niet met de hand aanpassen; na een wijziging `node tools/build.mjs` draaien en meecommitten.
- `config.js` – Supabase URL + publishable key, en `shortcutUrl` (iCloud-link van de Opdrachten-opdracht).
- `supabase.sql` – tabellen, RLS en de functies `ingest_health` / `brnd_sync` (stappen vanaf de iPhone).
- `icons/`, `img/`, `fonts/`, `manifest.webmanifest` – assets.

## Code in `src/app.html`
- Globale state `S`, lopende training `draft` (in localStorage), `render()` tekent opnieuw.
- Views: `viewHome`, `viewSession` (training), `viewProgress`, `viewTrainings`, `viewStreak`, `viewBody`, `viewProfile`, …; router `go(name)` / `back()`.
- Klikken via `data-act="…"` in één grote `switch` in de click-handler.
- Lightboxen via `openModal({ type })` / `renderModal`, sheets via `S.sheet` / `renderSheet`, draaiwiel via `openWheel`.
- Opslag: `Store.put/del` (Supabase-tabel `docs(col, id, data)`; lokaal localStorage). Collecties: workouts, plans, body, profiles, health, …
- Oefeningen: `BASE_EX` + zoek-bijnamen in `EX_ALIAS`. Schema's: `BASE_TPL`.

## Werkwijze
1. Pas `src/app.html` aan.
2. `node tools/build.mjs`
3. Test lokaal (bv. Playwright of open `index.html`), check de console op fouten.
4. Commit op een eigen branch en open een pull request naar `main`. Na mergen zet GitHub Actions het binnen 1 à 2 minuten live (de workflow bouwt ook zelf `index.html`).

## Niet doen
- Nooit de Supabase `service_role`/secret key in de repo zetten (alleen de publishable key mag).
- Geen persoonlijke foto's in de repo (de repo is openbaar).
