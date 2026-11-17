# BRND FIT – losse app met gedeelde database en Apple Gezondheid

## 1. Supabase (gratis) – ± 5 minuten
1. Maak een account op https://supabase.com en een **New project** (regio: Frankfurt/West EU). Bewaar het databasewachtwoord.
2. Ga naar **SQL Editor → New query**, plak de inhoud van `supabase.sql` en klik **Run**.
3. Ga naar **Authentication → URL Configuration** en zet **Site URL** op `https://antoniebrnd.github.io/brnd-fit/`.
4. Ga naar **Project Settings → API** en kopieer de **Project URL** en de **anon / publishable key**. Zet ze in `config.js` (of stuur ze naar Claude).
5. Na het inloggen van Antonie en Mels: **Authentication → Providers/Sign In → Allow new users to sign up** uitzetten. Dan kan verder niemand een account maken.

## 2. Online zetten
De app staat na een merge naar `main` automatisch op `https://antoniebrnd.github.io/brnd-fit/` (GitHub Pages; zet eenmalig Settings → Pages → Source op **GitHub Actions**).
Open die link op je iPhone in Safari → Deel → **Zet op beginscherm**.

## 3. Apple Gezondheid koppelen (per persoon)
In de app: menu (☰) → **Instellingen → Apple Gezondheid → Koppelcode maken**. Daar staan de URL, de key, de code en de stappen voor de automatisering in de app **Opdrachten**.
De iPhone stuurt dan elke dag stappen, actieve kcal en slaap naar `ingest_health`.

## Wat de app ermee doet
- **Stappen** → extra verbruikte kcal (± 0,0005 kcal per stap per kg lichaamsgewicht) bij je calorieën, weektotaal en onderlinge stand.
- **Slaap** → laatste nacht en de afgelopen 7 nachten t.o.v. je slaapdoel (Instellingen), met advies om eerder/later te gaan slapen.
- **Herstelscore** (0–100) uit slaap van afgelopen nacht, slaaptekort van de week en de trainingsbelasting van gisteren.
