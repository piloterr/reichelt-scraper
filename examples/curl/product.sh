#!/usr/bin/env bash
# Reichelt Product API – cURL example
# Usage: PILOTERR_API_KEY=your-key ./product.sh
set -euo pipefail

curl -sS -G "https://api.piloterr.com/v2/reichelt/product" \
  -H "x-api-key: ${PILOTERR_API_KEY}" \
  --data-urlencode query=https://www.reichelt.de/de/de/shop/produkt/arduino_uno_rev_3_smd-variante_atmega328_usb-119045
