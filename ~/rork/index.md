# Rork Ecosystem: Strategic Overview & Consolidation Plan

## 1. Executive Summary

The "rork" repositories represent a collection of sophisticated, AI-powered applications, all built on a shared technology stack. The portfolio is centered around several major, standalone "flagship" applications, each targeting a specific business vertical (construction, wedding planning, fitness, real estate).

However, the current multi-repo setup has led to significant code duplication, especially of UI components, AI service integrations, and configurations. The key to managing this ecosystem effectively is to **consolidate active projects into a monorepo** and **archive obsolete prototypes**. This will streamline development, reduce maintenance overhead, and improve code quality.

## 2. Core Technology Stack

A common tech stack is the unifying thread across the ecosystem:

-   **Frontend:** Expo (React Native) & TypeScript
-   **Backend:** A mix of **Convex** (for mature applications) and Hono/tRPC (as boilerplate in prototypes).
-   **AI Services:** Google Gemini, OpenAI, Vapi, and ElevenLabs.
-   **State Management:** Zustand.
-   **Deployment:** Vercel is commonly used (inferred from `vercel.json` files).
-   **Development:** A custom `rork` CLI tool is used in many projects.

## 3. Portfolio Analysis

The 20 repositories can be categorized as follows:

### 3.1. Flagship Applications

These are mature, standalone products with unique business domains. They should be the primary focus of future development.

| Repository | Project Name | Domain | Backend | Status |
| :--- | :--- | :--- | :--- | :--- |
| `rork-ai-assistant-construction`| **KONSTRUKT** | Construction / Safety | Hono/tRPC (Plan to migrate) | Active |
| `rork-everafter-wedding-planning-platform`| **EverAfter** | Wedding Planning | Convex | Active |
| `rork-mastra-voice-ai` | **Mastra** | Fitness & Wellness | Convex | Active |
| `rork-haus-ai-command-center` | **HAUS** | Real Estate | Hono/tRPC (Developed) | Active |
| `rork-askara` | **AskARA** | Core Platform / Comms | Convex / LiveKit | Mature |

### 3.2. Supporting Prototypes & Components

These repositories were created to develop specific features in isolation. Their code is valuable but should be merged into a shared library and the repos archived.

| Repository | Inferred Purpose | Recommendation |
| :--- | :--- | :--- |
| `rork-haus-voice-search` | UI prototype for the HAUS platform's voice search. | Merge into `rork-haus-ai-command-center`. |
| `rork-reusable-scroll-navigation-component` | Testbed for a timeline scroll component. | Move component to a shared UI library. |
| `rork-voice-agent-interface` | Testbed for the ElevenLabs voice interface. | Move component to a shared UI/voice library. |

### 3.3. Distinct Applications (Lower Tier)

These are functional, standalone apps that are either less mature than the flagships or have a very narrow focus. They are candidates for inclusion in the monorepo.

| Repository | Inferred Purpose | Domain | Backend | Status |
| :--- | :--- | :--- | :--- | :--- |
| `rork-ara-property-services-app` | Admin dashboard for property services. | Property Services | Hono/tRPC (Boilerplate) | Active |
| `rork-ara-property-services-mobile-app` | Field app for property services. | Property Services | Hono/tRPC (Boilerplate) | Active |
| `rork-ask-ara---knowledge-assistant` | AI-powered contract analysis tool. | Legal / Document AI | None | Active |
| `rork-prestart-meeting-manager` | Safety meeting sign-on and management. | Construction / Safety | Supabase | Active |
| `rork-hvac-diagnostic-assistant` | AI-powered diagnostic tool for technicians. | Field Services / HVAC | Gemini (Client-side) | Active |
| `rork-deliveryflow-pro` | Logistics and delivery tracking app. | Logistics | Supabase (Intended) | Inactive |

### 3.4. Obsolete & Redundant Repositories

These repositories are precursors, duplicates, or simple templates that have been superseded by more advanced projects. They should be formally archived.

| Repository | Reason for Archival | Superseded By |
| :--- | :--- | :--- |
| `rork-eclat-os-dashboard` | More advanced version of `rork-alias-agent`, but itself inactive. `rork-alias-agent` is the active project. | `rork-alias-agent` (due to activity) |
| `rork-alias-agent` | Active but simpler version of `rork-eclat-os-dashboard`. | `rork-eclat-os-dashboard` (architecturally) |
| `rork-askara-property-services` | Obsolete prototype. | `rork-askara` |
| `rork-acme-ai-assistant` | Generic, inactive template. | N/A |
| `rork-ara-voice-assistant`| Superseded by the more advanced `rork-askara`. | `rork-askara` |
| `rork-alias-x-maker-coffee-platform`| A static presentation, not an application. | N/A |

## 4. Strategic Recommendations

### 4.1. High Priority: Adopt a Monorepo

The single most impactful change would be to migrate all **active** and **non-obsolete** projects into a single monorepo using `pnpm workspaces` or `nx`.

**Benefits:**
-   **Eliminates Code Duplication:** A single source of truth for components and services.
-   **Simplifies Dependency Management:** One lock file, reducing version conflicts.
-   **Improves Collaboration:** Easier to share code and maintain consistency.

### 4.2. High Priority: Create Shared Packages

Within the new monorepo, create a `packages/` directory to house shared code:

-   `packages/ui`: For common React components like `FloatingAIAssistant`, `VoiceInterface`, `Card`, `Button`, etc.
-   `packages/services`: For shared API clients for Gemini, ElevenLabs, Vapi, Supabase, etc.
-   `packages/config`: For shared configurations like `eslint`, `tsconfig.json`, and `tailwind.config.js`.
-   `packages/types`: For shared type definitions across the ecosystem.

### 4.3. Medium Priority: Consolidate Backend Strategy

The most mature applications (`AskARA`, `EverAfter`, `Mastra`) have successfully adopted **Convex** as their backend. The boilerplate Hono/tRPC backends in the other projects should be officially deprecated. A unified backend strategy centered on Convex would reduce complexity and allow for shared backend logic (e.g., for authentication).

### 4.4. Low Priority: Archive Obsolete Repositories

After migrating the active projects and shared code, the repositories listed in section 3.4 should be formally archived on GitHub to reduce clutter and prevent developers from accidentally using old code.