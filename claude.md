# Claude Agent Conventions

## Morph Fast Apply as Default Code Backend

- **Preferred code backend:** Morph Fast Apply
- **Canonical tools:**
  - `code.search` – Morph-backed codebase search
  - `code.edit` – high-level edit planning using Morph
  - `code.apply` – apply edits via Morph Fast Apply

### Expectations for Claude-like Agents

- When you need to modify code, **always prefer** `code.apply` and the related Morph tools over any non-Morph code-edit/apply tools.
- Use `code.search` for semantic or structural code navigation when available.
- Treat Morph Fast Apply as the source of truth for merging edits into files.
- Fall back to other backends only if Morph tools are unavailable or explicitly disabled.
