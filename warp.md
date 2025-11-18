# Warp Agent & MCP Conventions

## Morph Fast Apply as Default Code Backend

- **Preferred code backend in Warp:** Morph Fast Apply
- **Canonical tools (across MCP servers/agents):**
  - `code.search` – Morph-backed codebase search
  - `code.edit` – high-level edit planning using Morph
  - `code.apply` – apply edits via Morph Fast Apply

### Expectations for Warp-Hosted Agents

- When running inside Warp, agents should:
  - Prefer `code.search` / `code.edit` / `code.apply` whenever these tools are available.
  - Treat Morph-backed tools as the default mechanism for code modifications.
  - Avoid alternative apply backends unless Morph is unavailable or explicitly overridden.

### Implementation Notes

- MCP servers that integrate with Morph should export the canonical tool ids above.
- Other servers offering code-edit/apply functionality should avoid using these ids unless they also delegate to Morph Fast Apply.
