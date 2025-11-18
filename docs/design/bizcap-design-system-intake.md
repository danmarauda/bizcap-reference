# Bizcap Design System – Intake

Goal: capture **all Bizcap brand assets** here first, then translate them into a reusable design system for the event-scoping apps (web + mobile).

## 1. Brand source of truth

Please link the canonical brand sources:

- Figma design system URL(s):
  - `TODO: add`  
- Brand guidelines PDF / doc:
  - `TODO: add`  
- Public site(s) that reflect current branding (for reference only):
  - `TODO: add`

## 2. Assets to collect (files go under `assets/bizcap/*`)

### 2.1 Logos (`assets/bizcap/logos`)
- Primary logos (full color, dark/light backgrounds).
- Monochrome / reversed versions.
- Horizontal / stacked variants.
- File formats:
  - Prefer: `.svg`, `.pdf` (vector).
  - Also: `.png` for quick use.

Suggested filenames:
- `bizcap-logo-primary-dark.svg`
- `bizcap-logo-primary-light.svg`
- `bizcap-logo-mark-only.svg`

### 2.2 Icons (`assets/bizcap/icons`)
- App icons, favicons.
- Any custom iconography used in Bizcap UI.

Suggested structure:
- `app-icon/` – platform app icons.
- `system/` – generic system icons.
- `brand/` – custom branded icons.

### 2.3 Colors (`assets/bizcap/colors`)
- Brand palette: primaries, neutrals, semantic colors.
- Provide **tokens with names + hex values**.

Create (or paste) a file like `brand-colors.json` or `brand-colors.md` with entries such as:
- `bizcap.blue.500` – `#TODO`
- `bizcap.blue.600` – `#TODO`
- `bizcap.neutral.900` – `#TODO`
- `bizcap.success.500` – `#TODO`
- `bizcap.warning.500` – `#TODO`
- `bizcap.error.500` – `#TODO`

These will map directly into:
- Tailwind config + HeroUI theme for web.
- React Native theme tokens for mobile.

### 2.4 Typography (`assets/bizcap/typography`)
- Primary and secondary font families.
- Weights and styles (e.g. `Regular`, `Medium`, `Semibold`, `Bold`).
- Line heights, letter spacing rules if specified.

Include:
- Font license info (if required).
- Webfont binaries (`.woff2`) and/or links to Google Fonts / host.

Also create a small `typography-tokens.md` describing:
- Headings scale (e.g. H1–H6 sizes).
- Body, caption, label sizes.

### 2.5 Illustrations / imagery (`assets/bizcap/illustrations`)
- Any brand-specific illustrations or photography sets.
- Background textures, patterns.

### 2.6 Components (`assets/bizcap/components`)
- Screenshots or exports of canonical components from Figma, for quick reference:
  - Buttons, inputs, selects.
  - Cards, modals, alerts.
  - Navigation patterns.

These are visual references only; we will reimplement them using HeroUI / React Native + tokens.

### 2.7 Motion (`assets/bizcap/motion`)
- Lottie files or video snippets if Bizcap has motion guidelines.
- Any rules for animation duration, easing, and usage.

## 3. Mapping to implementation

Once assets are dropped in:

1. We will derive **design tokens** into a shared package in the main app:
   - Colors → `packages/shared-ui-tokens/colors.ts`.
   - Typography → `packages/shared-ui-tokens/typography.ts`.
   - Radii/shadows/spacing → same package.
2. We will configure:
   - Tailwind + HeroUI theme in `apps/web` using these tokens.
   - A mobile theme in `apps/mobile` consuming the same token values.
3. Logos and icons will be used as:
   - Static assets in Next.js (e.g. `public/brand/*`).
   - App icons and splash screens in Expo / EAS.

## 4. Checklist

Before development starts, ensure we have:

- [ ] Figma links and brand guidelines documented above.
- [ ] Logos (SVG + PNG) placed in `assets/bizcap/logos`.
- [ ] Brand colors captured in a structured file under `assets/bizcap/colors`.
- [ ] Typography fonts + tokens in `assets/bizcap/typography`.
- [ ] Any key component screenshots in `assets/bizcap/components`.
- [ ] Any relevant icons / app icons in `assets/bizcap/icons`.

Once these are in place, we’ll lock them into tokens and themes in the main Bizcap app repo.