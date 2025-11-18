# Bizcap Brand Colors – Draft (from live site)

> Source: https://www.bizcap.com.au (via Chrome DevTools MCP, root + navbar/body sampling)
> Status: **Draft** – please confirm against official brand guidelines / Figma.

## Base

- `bizcap.base.background` – `#FFFFFF`  
  - From `<body>` background.
- `bizcap.base.text` – `#1A191E`  
  - From `<body>` text color (rgb(26, 25, 30)).

## Neutrals (inferred)

- `bizcap.neutral.900` – `#1A191E`  
  - Primary text / navbar color.
- `bizcap.neutral.0` – `#FFFFFF`  
  - Page background.

## Notes

- This file is **only** based on computed styles from the homepage and should be treated as a starting point.
- Once we have official brand tokens (from Figma / guidelines), we will:
  - Replace these hex values where needed.
  - Expand to include primary/secondary/semantic colors as defined by Bizcap (e.g. lending green, accent colors, error/success states).
- These names are chosen to map cleanly into our shared token package:
  - Web: Tailwind + HeroUI theme (e.g. `colors.bizcap.base.background`).
  - Mobile: React Native theme tokens with the same semantic names.
