# Crush Agent Conventions

## Morph Fast Apply as Default Code Backend

- **Preferred code backend:** Morph Fast Apply
- **Canonical tools:**
  - `code.search` – Morph-backed codebase search
  - `code.edit` – high-level edit planning using Morph
  - `code.apply` – apply edits via Morph Fast Apply

### Expectations for Crush

- For any code modifications, **use Morph-backed tools by default**.
- Call `code.search` / `code.edit` / `code.apply` when they are available in the MCP/tooling environment.
- Avoid custom or naive apply paths unless explicitly requested.
- Assume Morph Fast Apply is the authoritative mechanism for writing edits to disk.
