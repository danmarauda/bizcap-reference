# Bizcap Typography – Draft (from live site)

> Source: https://www.bizcap.com.au (via Chrome DevTools MCP sampling of headings, body, buttons, links)
> Status: **Draft** – please confirm against official brand guidelines / Figma.

## Font families (from computed styles)

The homepage uses the following `font-family` stacks:

- `"Open Sans", sans-serif`
- `Opensans, sans-serif`
- `"DM Sans", sans-serif`

### Proposed canonical mapping

For the app design system, propose:

- `bizcap.font.heading` → `"DM Sans", system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif`
- `bizcap.font.body` → `"Open Sans", system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif`

These can later be adjusted once the official typography spec is confirmed.

## Token suggestions

We’ll refine sizes/line-heights once we have Figma specs, but here is the intended structure:

- `bizcap.text.h1`
- `bizcap.text.h2`
- `bizcap.text.h3`
- `bizcap.text.body`
- `bizcap.text.caption`

Each will include:

- `fontFamily`
- `fontWeight`
- `fontSize`
- `lineHeight`

Example for later implementation (not final values):

- `bizcap.text.h1` – heading on hero section
  - `fontFamily`: `bizcap.font.heading`
  - `fontWeight`: `700`
  - `fontSize`: `clamp(32px, 4vw, 48px)`
  - `lineHeight`: `1.1`

Once you share Figma or written guidelines, we’ll update this file with **exact tokens** and then generate TS token files for web/mobile.
