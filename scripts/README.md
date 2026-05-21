# Skript

## download-pdfs.sh

Laddar ner alla PDF-filer (årsredovisningar, stadgar, energideklarationer, garantier, blanketter m.m.) från gamla sajten på bostadsratterna.se och placerar dem i `documents/` med snygga filnamn.

**Kör så här i terminalen:**

```bash
cd brfbullerbyn
bash scripts/download-pdfs.sh
```

Skriptet är idempotent — om en fil redan ligger nedladdad hoppar det över den. När du är klar:

```bash
git add documents/
git commit -m "Add PDFs from old site"
git push
```

Sen behöver `data/documents.json` också uppdateras med posterna för de nya dokumenten — se mallen i `documents/README.md`.
