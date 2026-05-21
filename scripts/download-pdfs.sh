#!/usr/bin/env bash
# Laddar ner alla PDF-filer från gamla sajten (bullerbyn1.bostadsratterna.se)
# och lägger dem i ../documents/ med snygga filnamn.
#
# Kör skriptet:   bash scripts/download-pdfs.sh
# Efteråt:        git add documents/ && git commit -m "Add PDFs" && git push
#
# Skriptet är idempotent — redan nedladdade filer hoppas över.

set -e
cd "$(dirname "$0")/.."
mkdir -p documents
cd documents

B="https://bullerbyn1.bostadsratterna.se"

declare -a downloads=(
  "$B/system/files/bullerbyn1_bostadsratterna_se/92800e9c589d78ce194a9179c55d67c7/1412_AR_2020.pdf|arsredovisning-2020.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/23ce947bb52e8ec3e59b17a825b174a6/2021_AR_Signerad.pdf|arsredovisning-2021.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/092ead1201a72b5c47e23c28e23aa8fc/2022_ARRB_Signerad.pdf|arsredovisning-2022.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/2024/54075912c3e3676a6fac0718060d4c51/2023_arrb_signerad.pdf|arsredovisning-2023.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/2025/055eb0a87cdcdd64dac9138c85e29239/arsredovisning_2024_0.pdf|arsredovisning-2024.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/2026/493b0eeaba65d19ecc05e2f943a49d76/brf_bullerbyn_1_i_bara_769636-3394_-_arsredovisning_2025-12-31.pades_.pdf|arsredovisning-2025.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/696b46792f9858c8e452d08b57721c52/7696363394_Stadgar_2018-05-24_1.pdf|stadgar-2018-05-24.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/2b9e2379454689c3e655b79d4164a0e7/Energideklaration_Liljegatan_40-42-44_2021.pdf|energideklaration-liljegatan-40-42-44-2021.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/17a520332ff33494080fba45bb80a44a/Energideklaration_Liljegatan_46-48_2021.pdf|energideklaration-liljegatan-46-48-2021.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/8c61e4843be9d835f4cfc2f73b80086e/Energideklaration_Liljegatan_50-52_2021.pdf|energideklaration-liljegatan-50-52-2021.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/3bce9fd14daf91ac6b913afce2ce5a7b/Energideklaration_Nackrosgatan_25-27-29_2021.pdf|energideklaration-nackrosgatan-25-27-29-2021.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/6511ee664bfea88f31d2fd8120be7fc6/Energideklaration_Nackrosgatan_31-33_2021.pdf|energideklaration-nackrosgatan-31-33-2021.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/70e6e9cc1aefeebf9758da6424bb9b70/Energideklaration_Nackrosgatan_35-37_2021.pdf|energideklaration-nackrosgatan-35-37-2021.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/c023aa294749b9f5037119ad782596ad/Energideklaration_Nackrosgatan_39-41-43_2021.pdf|energideklaration-nackrosgatan-39-41-43-2021.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/c7776fed3f4ace91af138a5d22c65710/2.4_Oppenfiber_Broschyr.pdf|oppenfiber-broschyr.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/0c068f00fa6757aeff66adad36791b37/3.0_Energispartips.pdf|energispartips.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/35d74d1654e8dfd57f27003a2dc058e6/4.2_Utemiljo.pdf|utemiljo.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/9dc495416c02d91c68abef1f533d9ff5/4.0_Skotsel_och_underhall_av_byggnad_-_invandiga_ytor.pdf|skotsel-och-underhall-av-byggnad-invandiga-ytor.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/b3d86d1e4d59b47fa092affaca6647e6/6.0_Ansvar_for_underhall.pdf|ansvar-for-underhall.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/5842ad2d44e02b0056e976bd2aff641c/2.2_Elektriska_installationer.pdf|elektriska-installationer.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/dfdb0ae405e46eb2f79c471ffce63127/5.0_Atgarder_vid_brand_vattenskada_och_elavbrott.pdf|atgarder-vid-brand-vattenskada-och-elavbrott.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/91646bd92d1346394f9b11541bb420cd/9.0_SBC_Ekonomisk_forvaltare.pdf|sbc-ekonomisk-forvaltare.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/ef5a037a817570db364eb4ac01115267/12.1_Garanti_Nibe.pdf|garanti-nibe.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/89f64db2a34135bfcc7d6dcf99fa6c48/12.0_Garanti_Bosch.pdf|garanti-bosch.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/6fe917aaa2ae28b5fd59a10662f8f22a/12.2_Garanti_Elitfonster_0.pdf|garanti-elitfonster.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/35aaac6cb375baaafc8c3d0f8d8704e5/20230601_Integritetspolicy_1.0.pdf|integritetspolicy.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/0d475d228597ba7fdd9e7b2c81d63fa4/andrahandsansokan_0.pdf|andrahandsansokan.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/7d2dae7df3651994a8c43aab23319f1d/Blankett_-_Till_och_ombyggnad_0.pdf|ansokan-om-och-tillbyggnad.pdf"
  "$B/system/files/bullerbyn1_bostadsratterna_se/0a0fb2cb9fa91ae0d0409246a6908cd3/klipphacken_0.pdf|klipphacken.pdf"
)

ok=0; skip=0; fail=0
for entry in "${downloads[@]}"; do
  url="${entry%%|*}"
  out="${entry##*|}"
  if [ -s "$out" ]; then
    skip=$((skip+1))
    continue
  fi
  printf "%-55s " "$out"
  code=$(curl -sS -L --connect-timeout 30 --max-time 180 -o "$out" -w "%{http_code}" "$url" 2>/dev/null) || true
  if [ "$code" = "200" ] && [ -s "$out" ]; then
    size=$(wc -c < "$out" | tr -d ' ')
    echo "OK ($size bytes)"
    ok=$((ok+1))
  else
    echo "FAIL (HTTP $code)"
    rm -f "$out"
    fail=$((fail+1))
  fi
  sleep 1
done

echo ""
echo "Klart: $ok nya, $skip redan nere, $fail misslyckade"
