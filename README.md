# MaKandra

Deze repository bevat de frontend en backend code voor MaKandra.

## Projectstructuur

- `index.html`, `style.css`, `script.js` — frontend website
- `backend/server.js` — Node.js API server
- `backend/config/db.js` — MySQL database connectie
- `backend/.env.example` — voorbeeld van de benodigde omgevingsvariabelen

## MySQL verbinden

De backend gebruikt `mysql2` en leest de database-instellingen uit omgevingsvariabelen.
Maak een bestand `backend/.env` met dezelfde velden als `backend/.env.example`:

- `DB_HOST`
- `DB_USER`
- `DB_PASSWORD`
- `DB_NAME`
- `DB_PORT`

Zorg dat de MySQL-server publiek bereikbaar is of beschikbaar via een cloud-database provider.

## Wat je niet kunt doen op GitHub Pages

GitHub Pages kan alleen statische bestanden hosten. Het kan geen Node.js-server of MySQL-database uitvoeren.
Daarom moet de backend op een aparte server of clouddienst worden ingezet, bijvoorbeeld:

- Railway
- Render
- Vercel (serverless API)
- Heroku
- DigitalOcean

## Frontend verbinden met de backend

In `script.js` staat de API-basis URL:

- lokaal: `http://localhost:3000`
- productieserver: vervang deze door de URL van jouw gedeployde backend

Je kunt `index.html` aanpassen om `window.API_BASE` te zetten naar je backend-URL.

## Starten in lokaal ontwikkelomgeving

1. Ga naar de `backend` map
2. Kopieer `backend/.env.example` naar `backend/.env`
3. Vul de database- en SMTP-instellingen in
4. Run `npm install`
5. Run `npm run dev`

## Belangrijk

- Zorg dat je `backend/.env` niet naar GitHub pusht
- Alleen de backend hoeft een echte MySQL-verbinding te hebben
- De frontend kan via CORS met de backend communiceren zolang de backend openbaar bereikbaar is
