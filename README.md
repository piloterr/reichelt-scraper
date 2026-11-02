<p align="center">
  <a href="https://www.piloterr.com"><img src="images/banner.png" alt="Reichelt Scraper API by Piloterr – scrape Reichelt data as JSON" width="100%"></a>
</p>

# Reichelt Scraper API

[![Discord](https://img.shields.io/badge/Discord-Join%20the%20community-5865F2?logo=discord&logoColor=white)](https://discord.gg/CFj3ph8aHU) [![Get API key](https://img.shields.io/badge/Piloterr-Get%20a%20free%20API%20key-111827)](https://app.piloterr.com) [![API docs](https://img.shields.io/badge/Docs-OpenAPI-0EA5E9)](https://app.piloterr.com/openapi) [![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

The **Piloterr Reichelt Scraper API** lets you extract public data from Reichelt as **clean, structured JSON** — no proxies, headless browsers or HTML parsing to maintain. Endpoints available in production:

- **Reichelt Product API** — Read one reichelt.de product URL, including article number, EAN, and the euro price.
- **Reichelt Search API** — Search reichelt.de by keyword or category.

Use it for price monitoring, assortment tracking, competitor analysis, product research or catalog enrichment.

| Endpoint | Path | Credits | What you get |
|---|---|---|---|
| [Reichelt Product API](#reichelt-product-api) | `/v2/reichelt/product` | 1 | Read one reichelt.de product URL, including article number, EAN, and the euro price. |
| [Reichelt Search API](#reichelt-search-api) | `/v2/reichelt/search` | 1 | Search reichelt.de by keyword or category. Euro prices are rebuilt from the number, including whole-euro amounts. |

## Table of contents

- [How it works](#how-it-works)
- [Reichelt Product API](#reichelt-product-api)
- [Reichelt Search API](#reichelt-search-api)
- [Code examples in other languages](#code-examples-in-other-languages)
- [Practical use cases](#practical-use-cases)
- [Why Piloterr?](#why-piloterr)
- [FAQ](#faq)
- [Related scrapers](#related-scrapers)
- [Support](#support)

## How it works

1. **Create a free Piloterr account** and copy your API key from the [dashboard](https://app.piloterr.com).
2. **Send a `GET` (or `POST`) request** to `https://api.piloterr.com/v2/...` with the header `x-api-key: YOUR_API_KEY`.
3. **Receive structured JSON** — Piloterr handles rendering, proxies, retries and parsing.

```bash
export PILOTERR_API_KEY="your-api-key"
pip install requests        # Python
# TypeScript: Node.js 18+ (native fetch), run with `npx tsx file.ts`
```

> Every endpoint accepts both `GET` (query string) and `POST` (JSON body with the same fields).

## Reichelt Product API

Read one reichelt.de product URL, including article number, EAN, and the euro price.

`GET | POST https://api.piloterr.com/v2/reichelt/product` · **1 credit per request** · [Full reference](https://app.piloterr.com/openapi)

### Request parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `query` | string | ✅ | A reichelt.de or reichelt.com product link. A search link returns 400. |
| `return_page_source` | boolean | — | Set to true to get the raw HTML in result. |

### Python example

```python
import json
import os
import requests

response = requests.get(
    "https://api.piloterr.com/v2/reichelt/product",
    headers={"x-api-key": os.environ["PILOTERR_API_KEY"]},
    params={
        "query": "https://www.reichelt.de/de/de/shop/produkt/arduino_uno_rev_3_smd-variante_atmega328_usb-119045",
    },
    timeout=120,
)
response.raise_for_status()
data = response.json()

print(json.dumps(data, indent=2, ensure_ascii=False)[:2000])
```

### TypeScript example

```typescript
type ReicheltProduct = {
  ean?: string;
  mpn?: string;
  url?: string;
  brand?: string;
  price?: number;
  title?: string;
  images?: string[];
  currency?: string;
  in_stock?: boolean;
  image_url?: string;
  product_id?: string;
  description?: string;
  price_display?: string;
  article_number?: string;
};

const params = new URLSearchParams({
  "query": "https://www.reichelt.de/de/de/shop/produkt/arduino_uno_rev_3_smd-variante_atmega328_usb-119045",
});

const response = await fetch(`https://api.piloterr.com/v2/reichelt/product?${params}`, {
  headers: { "x-api-key": process.env.PILOTERR_API_KEY! },
});
if (!response.ok) throw new Error(`Piloterr error ${response.status}: ${await response.text()}`);

const data = (await response.json()) as ReicheltProduct;

console.log(JSON.stringify(data, null, 2).slice(0, 2000));
```

<details>
<summary><b>POST variant</b></summary>

```http
POST https://api.piloterr.com/v2/reichelt/product
x-api-key: YOUR_API_KEY
Content-Type: application/json

{"query": "https://www.reichelt.de/de/de/shop/produkt/arduino_uno_rev_3_smd-variante_atmega328_usb-119045"}
```
</details>

### Output example

Example response from the API reference, abridged — real values depend on the page you scrape.

```json
{
  "ean": "9783645651394",
  "mpn": "A000073",
  "url": "https://www.reichelt.de/de/de/shop/produkt/arduino_uno_rev_3_smd-variante_atmega328_usb-119045",
  "brand": "ARDUINO",
  "price": 19.9,
  "title": "Arduino Uno Rev. 3, SMD-Variante, ATmega328, USB",
  "images": [
    "https://cdn-reichelt.de/resize/600%2F-/web/xxl_ws/A300%2FARDUINO_UNO_01_NEU.png?type=ProductXxl&resize=600%252F-&",
    "https://cdn-reichelt.de/resize/600%2F-/web/xxl_ws/A300%2FARDUINO_UNO_02_NEU.png?type=ProductXxl&resize=600%252F-&"
  ],
  "currency": "EUR",
  "in_stock": true,
  "image_url": "https://cdn-reichelt.de/resize/600%2F-/web/xxl_ws/A300%2FARDUINO_UNO_01_NEU.png?type=ProductXxl&resize=600%252F-&",
  "product_id": "119045",
  "description": "ARDUINO™ UNO - OPEN SOURCE Prototyp Plattform Ein Microcontroller-Board basierend auf dem ATMega328 von Atmel. Dieses Board enthält alle …",
  "price_display": "19,90 €",
  "article_number": "ARDUINO UNO"
}
```

### Response fields

| Field | Type | Description |
|---|---|---|
| `ean` | string |  |
| `mpn` | string |  |
| `url` | string |  |
| `brand` | string |  |
| `price` | number |  |
| `title` | string |  |
| `images` | string[] |  |
| `currency` | string |  |
| `in_stock` | boolean |  |
| `image_url` | string |  |
| `product_id` | string |  |
| `description` | string |  |
| `price_display` | string |  |
| `article_number` | string |  |

## Reichelt Search API

Search reichelt.de by keyword or category. Euro prices are rebuilt from the number, including whole-euro amounts.

`GET | POST https://api.piloterr.com/v2/reichelt/search` · **1 credit per request** · [Full reference](https://app.piloterr.com/openapi)

### Request parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `query` | string | ✅ | What to look for. A word such as 1n4148, or a reichelt.de search or category link. A product link returns 400. |
| `page` | number | — | Page number, starting at 1. Page 2 is PAGE=1 on the shop. |
| `return_page_source` | boolean | — | Set to true to get the raw HTML in result. |

### Python example

```python
import json
import os
import requests

response = requests.get(
    "https://api.piloterr.com/v2/reichelt/search",
    headers={"x-api-key": os.environ["PILOTERR_API_KEY"]},
    params={
        "query": "1n4148",
    },
    timeout=120,
)
response.raise_for_status()
data = response.json()

print(json.dumps(data, indent=2, ensure_ascii=False)[:2000])
```

### TypeScript example

```typescript
type ReicheltSearch = {
  results?: {
    url?: string;
    brand?: string;
    price?: number;
    title?: string;
    currency?: string;
    in_stock?: boolean;
    image_url?: string;
    attributes?: {
      name?: string;
      value?: string;
    }[];
    product_id?: string;
    price_display?: string;
    article_number?: string;
  }[];
  pagination?: {
    next?: unknown;
    page?: number;
    per_page?: number;
    total_pages?: number;
    total_results?: number;
  };
};

const params = new URLSearchParams({
  "query": "1n4148",
});

const response = await fetch(`https://api.piloterr.com/v2/reichelt/search?${params}`, {
  headers: { "x-api-key": process.env.PILOTERR_API_KEY! },
});
if (!response.ok) throw new Error(`Piloterr error ${response.status}: ${await response.text()}`);

const data = (await response.json()) as ReicheltSearch;

console.log(JSON.stringify(data, null, 2).slice(0, 2000));
```

<details>
<summary><b>POST variant</b></summary>

```http
POST https://api.piloterr.com/v2/reichelt/search
x-api-key: YOUR_API_KEY
Content-Type: application/json

{"query": "1n4148"}
```
</details>

### Output example

Example response from the API reference, abridged — real values depend on the page you scrape.

```json
{
  "results": [
    {
      "url": "https://www.reichelt.de/de/de/shop/produkt/kleinsignal-schalt-diode_100_v_300_ma_sod-123-332913",
      "brand": "HOTTECH SEMICONDUCTOR",
      "price": 0.02,
      "title": "Kleinsignal-Schalt-Diode, 100 V, 300 mA, SOD-123",
      "currency": "EUR",
      "in_stock": false,
      "image_url": "https://cdn-reichelt.de/resize/130%2F-/web/artikel_ws/A400%2FSOD-123-HOTTECH.jpg?type=Product&resize=130%252F-&",
      "attributes": [
        {},
        {}
      ],
      "product_id": "332913",
      "price_display": "0,02 €",
      "article_number": "1N4148W HOT"
    }
  ],
  "pagination": {
    "next": null,
    "page": 1,
    "per_page": 8,
    "total_pages": 1,
    "total_results": 8
  }
}
```

### Response fields

| Field | Type | Description |
|---|---|---|
| `results[]` | object[] |  |
| `results[].url` | string |  |
| `results[].brand` | string |  |
| `results[].price` | number |  |
| `results[].title` | string |  |
| `results[].currency` | string |  |
| `results[].in_stock` | boolean |  |
| `results[].image_url` | string |  |
| `results[].attributes[]` | object[] |  |
| `results[].product_id` | string |  |
| `results[].price_display` | string |  |
| `results[].article_number` | string |  |
| `pagination` | object |  |
| `pagination.next` | object |  |
| `pagination.page` | integer |  |
| `pagination.per_page` | integer |  |
| `pagination.total_pages` | integer |  |
| `pagination.total_results` | integer |  |

## Code examples in other languages

Ready-to-run examples live in the [`examples/`](examples) folder. Each one reads your key from the `PILOTERR_API_KEY` environment variable.

| Language | Product | Search |
|---|---|---|
| cURL (Bash) | [`product`](examples/curl/product.sh) | [`search`](examples/curl/search.sh) |
| PHP | [`product`](examples/php/product.php) | [`search`](examples/php/search.php) |
| C# | [`product`](examples/csharp/Product.cs) | [`search`](examples/csharp/Search.cs) |
| Go | [`product`](examples/go/product.go) | [`search`](examples/go/search.go) |
| Java | [`product`](examples/java/ProductExample.java) | [`search`](examples/java/SearchExample.java) |
| Ruby | [`product`](examples/ruby/product.rb) | [`search`](examples/ruby/search.rb) |
| Node.js | [`product`](examples/nodejs/product.mjs) | [`search`](examples/nodejs/search.mjs) |

## Practical use cases

- **Price monitoring** — Track prices, promotions and availability over time to react to competitors.
- **Assortment & catalog tracking** — Follow new products, delisted items and category changes.
- **Competitor analysis** — Benchmark ranges, brands and positioning across retailers.
- **Product research** — Spot best-sellers and trends from search results.
- **Catalog enrichment** — Pull titles, images and attributes into your PIM or marketplace listings.

## Why Piloterr?

- **No infrastructure** — no proxies, headless browsers or CAPTCHA solving to run yourself.
- **Structured JSON** — stable, documented fields instead of brittle HTML selectors.
- **Pay per request** — transparent credit cost per endpoint, failed requests are retried for you.
- **One API key, hundreds of sources** — Reichelt plus many other e-commerce, search and company data endpoints in the [Piloterr library](https://www.piloterr.com/library).
- **Any language** — plain HTTPS + JSON, with examples for Python, TypeScript, cURL, PHP, C#, Go, Java, Ruby and Node.js.

## FAQ

### Is it legal to scrape Reichelt?

Collecting publicly available data is generally allowed in many jurisdictions, but rules depend on your country, the data you collect and how you use it. Avoid personal data unless you have a lawful basis, respect the website's terms where they apply, and get legal advice for your specific use case. This is not legal advice.

### Do I need proxies or a headless browser?

No. Piloterr handles rendering, proxy rotation and retries on its side. You only send an HTTPS request with your `x-api-key` header and receive JSON.

### How much does a request cost?

Credits per call: `/v2/reichelt/product` **1**, `/v2/reichelt/search` **1**. See the [Piloterr website](https://www.piloterr.com) for plans.

### What data does the Reichelt API return?

Each endpoint returns structured JSON: **Reichelt Product** — `ean`, `mpn`, `url`, `brand`, `price`, `title`; **Reichelt Search** — `results[]`, `results[].url`, `results[].brand`, `results[].price`, `results[].title`, `results[].currency`.

### How do I paginate Reichelt results?

Use the `page` parameter and keep requesting while the response indicates more results.

### Can I get the raw HTML instead of JSON?

Yes. Set `return_page_source=true` and the response becomes `{"result": "..."}` with the page source.

### Which languages are supported?

Any language that can make an HTTP request. This README shows Python and TypeScript; the [`examples/`](examples) folder contains cURL, PHP, C#, Go, Java, Ruby and Node.js.

## Related scrapers

- [About You Scraper API](https://github.com/piloterr/aboutyou-scraper)
- [Action Scraper API](https://github.com/piloterr/action-scraper)
- [Aldi Scraper API](https://github.com/piloterr/aldi-scraper)
- [Alibaba Scraper API](https://github.com/piloterr/alibaba-scraper)
- [AliExpress Scraper API](https://github.com/piloterr/aliexpress-scraper)
- [Allegro Scraper API](https://github.com/piloterr/allegro-scraper)
- [All Piloterr scrapers on GitHub](https://github.com/piloterr)

## Support

- 💬 Join the [Piloterr Discord](https://discord.gg/CFj3ph8aHU) to ask questions and share what you build.
- 📚 Browse the [API reference (OpenAPI)](https://app.piloterr.com/openapi) and the [Piloterr library](https://www.piloterr.com/library).
- 🔑 [Get your API key](https://app.piloterr.com).

---

<p align="center">
  <a href="https://www.piloterr.com">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="images/logo-dark.svg">
      <img src="images/logo.svg" alt="Piloterr" height="32">
    </picture>
  </a>
  <br>
  <sub>Built by <a href="https://www.piloterr.com">Piloterr</a> — web scraping APIs for e-commerce, search, real estate and more, one API key.</sub>
</p>

<sub>Reichelt is a trademark of its respective owner. This repository is not affiliated with or endorsed by Reichelt. Examples are released under the MIT license.</sub>
