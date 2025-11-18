# Bizcap Event Stack – Reference Index

Authoritative links for the core stack used by the Bizcap event scoping system.

> This file is intentionally lightweight: it lists canonical docs and GitHub repos.
> Use it as a jumping-off point; deeper notes can live in additional files under `docs/stack/*`.

---

## Better T Stack
- (CLI / template) – check project docs or README where you installed it from.
- When you have the exact GitHub URL, add it here under a `GitHub:` bullet.

## Next.js (Web)
- Docs: https://nextjs.org/docs
- GitHub: https://github.com/vercel/next.js

## Convex (Backend)
- Docs: https://docs.convex.dev
- JavaScript client repo: https://github.com/get-convex/convex-js

## Clerk (Auth – Web & Mobile)
- Docs (JS): https://clerk.com/docs
- JS/Next.js SDK repo: https://github.com/clerk/javascript

## HeroUI (ex-NextUI)
- Docs: https://www.heroui.dev/docs
- GitHub: https://github.com/heroui-inc/heroui

## Expo & EAS (Mobile)
- Expo docs: https://docs.expo.dev
- EAS docs: https://docs.expo.dev/eas
- Expo repo: https://github.com/expo/expo

## Vercel (Web deploy)
- Docs: https://vercel.com/docs

## Tailwind CSS (Styling)
- Docs: https://tailwindcss.com/docs

## picaOS (Integrations layer)
- Use your internal picaOS documentation and workspace dashboard.
- Add any internal or public docs links here once confirmed.

---

### How to use this repo

- Clone upstream repos into `repos/` (read-only):
  - Example: `cd repos && git clone https://github.com/vercel/next.js`
  - Example: `cd repos && git clone https://github.com/get-convex/convex-js`
  - Example: `cd repos && git clone https://github.com/clerk/javascript`
  - Example: `cd repos && git clone https://github.com/expo/expo`
  - Example: `cd repos && git clone https://github.com/heroui-inc/heroui`
- Create additional notes per tech:
  - `docs/stack/convex-notes.md`
  - `docs/stack/clerk-web.md`
  - `docs/stack/clerk-mobile.md`
  - `docs/stack/picaos-flows.md`

Keep this index small, accurate, and updated as we lock in the exact versions and upstream references for the project.