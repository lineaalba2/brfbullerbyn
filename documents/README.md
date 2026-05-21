# Dokument

Lägg PDF-filer (årsredovisningar, stadgar, protokoll, m.m.) i den här mappen och registrera dem i `../data/documents.json` så dyker de upp på webbplatsen.

## Att lägga upp ett nytt dokument

1. **Namnge filen** — använd små bokstäver, bindestreck istället för mellanslag, och årtal sist. Exempel:
   - `arsredovisning-2025.pdf`
   - `stamma-protokoll-2025.pdf`
2. **Ladda upp filen till den här mappen** på GitHub (Add file → Upload files).
3. **Öppna `data/documents.json`** och lägg till en post överst i listan:

   ```json
   {
     "category": "arsredovisning",
     "title": "Årsredovisning 2025",
     "file": "/documents/arsredovisning-2025.pdf",
     "date": "2026-04-20"
   }
   ```

4. **Kategorier som finns:**
   - `arsredovisning` → visas under *Om föreningen → Årsredovisningar*
   - `stadgar` → visas under *Om föreningen → Stadgar och styrdokument*
   - `stamma` → visas under *Om föreningen → Årsstämmor* (kallelser, protokoll)
   - `ordningsregler` → visas under *Regler & råd → Nyttiga dokument*
   - `ovrigt` → visas under *Regler & råd → Nyttiga dokument*
5. **Commit changes.** Sidan uppdateras automatiskt.

## Filer

PDF-filer ska helst vara under 10 MB. Är de större, komprimera först — annars blir nedladdningen seg.

PDF:erna är publika när de ligger i denna mapp. Lägg inte upp dokument med personuppgifter eller känslig information här.
