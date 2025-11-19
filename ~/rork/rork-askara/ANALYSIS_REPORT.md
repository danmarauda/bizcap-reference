# In-Depth Analysis Report: The AskARA Platform

**Note:** This report covers two related repositories: `rork-askara` and `rork-askara-property-services`. The analysis reveals that `rork-askara` is the primary, canonical, and most advanced project, while `rork-askara-property-services` is an older, stale subset or prototype.

---

## 1. Project Overview

- **Project Name:** AskARA Platform
- **Canonical Repository:** `rork-askara`
- **Inferred Purpose:** AskARA is a highly advanced, production-oriented platform that serves as the core of the "ARA" ecosystem. It functions as a comprehensive mobile application with a real backend, focusing on real-time communication (voice/video), issue tracking, contact management, and interaction with multiple AI services.
- **Development Stage:**
    - `rork-askara`: **Mature / Feature Complete**. While the last commit was 5 weeks ago, the repository is incredibly feature-rich, with extensive documentation, a functional backend, tests, and CI/CD scripts. It appears to be a production-ready application.
    - `rork-askara-property-services`: **Stale / Obsolete**. The last commit was 3 months ago. This repository contains a small subset of the features and none of the production infrastructure found in the main `rork-askara` project. It should be considered an archival prototype.

## 2. Technology Stack (`rork-askara`)

- **Core:** Expo (React Native), TypeScript.
- **Backend:** **Convex**. This is a significant differentiator. The project uses Convex for its database schema, server-side functions (`mutations`, `queries`), authentication, and real-time data synchronization. The boilerplate Hono/tRPC backend is likely a remnant.
- **Real-time Communication:** **LiveKit**. The platform has a Python-based `livekit-agent` and dedicated Convex functions for managing real-time audio and video, indicating a sophisticated streaming capability.
- **AI & Voice Services:** A comprehensive `services` layer with clients for **Vapi**, **ElevenLabs**, **Supabase**, and **Convex** itself.
- **Testing:** A full test suite (`__tests__/`) with unit and integration tests covering components, services, and backend functions.
- **CI/CD & Operations:** The project includes scripts for environment setup, version bumping, build validation, and extensive documentation on CI/CD, security, and monitoring.

## 3. Core Functionality & Features (`rork-askara`)

- **Unified Communication:** A central interface for interacting with multiple AI assistants (`askARA2`, `vapi-assistant`) via voice and chat.
- **Business Operations:** Includes screens and logic for managing `issues`, `contacts`, `schedules`, and `compliance`.
- **Real-time Voice/Video:** Full integration with LiveKit for real-time communication sessions.
- **Production-Grade Infrastructure:** The project is built for production, with features for monitoring, crash reporting (`sentry`), and a detailed security and deployment process.

## 4. Project Structure (`rork-askara`)

- `convex/`: Contains the entire backend, including the database schema and server-side business logic.
- `livekit-agent/`: A Python agent for handling LiveKit communications.
- `__tests__/`: A comprehensive testing suite.
- `docs/`: Extremely detailed documentation covering all aspects of the project from setup to production deployment.
- `scripts/`: Operational scripts for CI/CD and development.
- `services/`: A rich layer of clients for interacting with numerous external and internal services.

## 5. Potential for Merger & Conclusion

- **Canonical Source:** `rork-askara` is clearly the "source of truth" and the most complete application in the entire "rork" collection. It is the culmination of features prototyped in many of the other repositories.
- **Redundancy:** `rork-askara-property-services` is redundant and can be safely archived. Its concepts and features are fully realized in the main `rork-askara` application.
- **Recommendation:** The `rork-askara` repository should be treated as the **core platform**. All future development for the "ARA" ecosystem should be focused here. The other "ARA" repositories are likely obsolete. This project is not a candidate for a merger; rather, it is the target that other functionalities would be merged *into*.
