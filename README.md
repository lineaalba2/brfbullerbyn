# Brf Bullerbyn — webbplats

Statisk webbplats för bostadsrättsföreningen Brf Bullerbyn i Bara (juridiskt namn "Brf Bullerbyn 1 i Bara", org.nr 769636-3394). Inget byggsteg — bara HTML, CSS och lite JavaScript.

## Snabbstart för styrelsen

Webbplatsen är gjord för att vara enkel att uppdatera. Du behöver inte kunna programmera — du redigerar bara två filer direkt på GitHub i webbläsaren.

### Lägga upp en nyhet

1. Gå till `data/news.json` på GitHub.
2. Klicka på pennan (✏️) längst upp till höger för att redigera.
3. Lägg till en ny post överst i listan, t.ex.:

   ```json
   {
     "date": "2026-06-01",
     "title": "Sommarstädning 14 juni",
     "body": "Lördag 14 juni kl. 10.00 städar vi tillsammans. **Fika bjuds.**"
   }
   ```

   - `date` skrivs alltid som `ÅÅÅÅ-MM-DD`.
   - `body` får innehålla enkel formatering: `**fetstil**`, `*kursiv*`, listor med `-`, och länkar `[text](url)`. Använd `\n\n` för nytt stycke.
4. Glöm inte kommat mellan poster.
5. Klicka **Commit changes** längst ner. Sidan uppdateras automatiskt inom ett par minuter.

### Uppdatera styrelsen

Redigera `data/board.json` på samma sätt. Lägg till/ta bort medlemmar i `members`-listan. Sätt `updated` till dagens datum när du ändrar.

### Publicera en årsredovisning eller annat dokument

1. Lägg PDF-filen i mappen `documents/` på GitHub (Add file → Upload files). Använd ett tydligt filnamn, t.ex. `arsredovisning-2025.pdf`.
2. Öppna `data/documents.json` och lägg till en post överst:

   ```json
   {
     "category": "arsredovisning",
     "title": "Årsredovisning 2025",
     "file": "/documents/arsredovisning-2025.pdf",
     "date": "2026-04-20"
   }
   ```

   Kategorier: `arsredovisning`, `stadgar`, `stamma`, `ordningsregler`, `ovrigt`. Dokumentet dyker upp automatiskt på rätt plats — årsredovisningar och stadgar under *Om föreningen*, övrigt under *Regler & råd → Nyttiga dokument*. Detaljer finns i [`documents/README.md`](documents/README.md).

### Ändra annan text

Övriga texter (om föreningen, regler, området osv) ligger direkt i `.html`-filerna. De kan redigeras på GitHub också — leta upp filen, klicka på pennan och ändra texten mellan taggarna.

## Filer

```
.
├── index.html              Startsida med nyhetsflöde
├── nyheter.html            Alla nyheter
├── om-foreningen.html
├── styrelsen.html          (laddar data/board.json)
├── regler.html
├── omradet.html
├── felanmalan.html         (formulär)
├── kontakt.html            (formulär)
├── 404.html
├── partials/
│   ├── header.html         Delad sidhuvud-meny
│   └── footer.html         Delad sidfot
├── data/
│   ├── news.json           Nyheter (redigeras av styrelsen)
│   ├── board.json          Styrelsen (redigeras av styrelsen)
│   └── documents.json      Lista över publicerade dokument
├── documents/              PDF-filer (årsredovisningar m.m.)
├── assets/
│   ├── style.css
│   └── main.js
└── .github/workflows/pages.yml   Auto-deploy
```

## Kontaktformulär

Formulären på `kontakt.html` och `felanmalan.html` använder den gratis tjänsten [FormSubmit](https://formsubmit.co) — inga konton eller server behövs. Meddelanden skickas till **brfbullerbyn@gmail.com**.

**Första gången formuläret används** skickar FormSubmit ett bekräftelsemejl till brfbullerbyn@gmail.com — öppna det och klicka på länken för att aktivera formuläret. Detta görs en gång.

Om mottagaradressen behöver bytas: sök efter `brfbullerbyn@gmail.com` i `kontakt.html` och `felanmalan.html` och ersätt.

## Hosting

Webbplatsen är konfigurerad för GitHub Pages. När repot ligger på GitHub:

1. Gå till **Settings → Pages**.
2. Sätt **Source: GitHub Actions**.
3. Pusha till `main`-branchen — sajten deployas automatiskt via `.github/workflows/pages.yml`.

URL blir då `https://<användarnamn>.github.io/<reponamn>/` eller en egen domän om ni vill köpa en (t.ex. `bullerbyn1.se`). Kostnad: 0 kr för GitHub Pages, ~100 kr/år för en egen `.se`-domän.

### Alternativ: Cloudflare Pages

Cloudflare Pages är också gratis och något snabbare. Skapa ett konto, koppla GitHub-repot, och välj `/` som output directory. Inget byggkommando behövs.

## Köra lokalt

Eftersom HTML-filerna laddar partials/JSON via `fetch` måste det köras genom en lokal webbserver (inte bara öppnas som fil):

```bash
cd brfbullerbyn
python3 -m http.server 8000
# öppna http://localhost:8000
```

## Licens & ansvar

Innehållet ägs av Brf Bullerbyn. Webbplatsens kod är fri att återanvända.
