# In-Depth Analysis Report: EverAfter (rork-everafter-wedding-planning-platform)

## 1. Project Overview

- **Project Name:** EverAfter
- **Inferred Purpose:** A comprehensive, AI-powered mobile and web platform for wedding planning. The application is designed to be a complete assistant for engaged couples, helping manage guests, vendors, budgets, tasks, and timelines, with AI providing insights and suggestions throughout the process.
- **Development Stage:** **Active Development & Mature**. The last commit was 3 days ago. The repository contains extensive documentation, a complete backend schema, and a rich feature set, indicating it is a well-established and actively progressing project with clear business goals, evidenced by an `INVESTOR_PITCH.md`.

## 2. Technology Stack

- **Core:** Expo (React Native), TypeScript.
- **Backend:** **Convex**. This project has a fully-realized backend using Convex. The schema is detailed and covers all major aspects of wedding planning, including `weddings`, `guests`, `vendors`, `budget`, `tasks`, `timeline`, and `photos`.
- **AI Integration:** AI is a core component of the platform. The UI includes numerous AI-driven features like `AIInsights`, `AITaskSuggestions`, `AITimelineGenerator`, and `AIVendorChecklist`.

## 3. Core Functionality & Features

- **Comprehensive Wedding Management:** The dashboard provides a full suite of tools for wedding planning:
    - **Guest Management:** Guest lists and invitations.
    - **Vendor Management:** Vendor tracking, comparison (`vendor-compare`), and checklists.
    - **Financials:** Budgeting tools (`BudgetDetailModal`).
    - **Scheduling:** Timeline and task management, including a `GanttChart` component.
    - **Visuals:** Photo boards and uploads.
- **AI-Powered Assistance:** The platform leverages AI to proactively help users with planning, offering suggestions for tasks, timelines, and vendor selection.
- **Data-Driven:** The application is built on a robust data model in Convex, allowing for complex relationships between guests, vendors, tasks, and budget items.

## 4. Project Structure

- **`convex/`:** The heart of the application, containing the entire backend data model and logic.
- `app/`: A sophisticated dashboard layout with nested navigation for all major planning features.
- `components/`: A large collection of high-level components, many of which are AI-focused.
- **Documentation:** The project is extremely well-documented, with progress reports, phase completion summaries, a product-requirements-document-style roadmap, and investor-facing materials. This level of documentation is rare and indicates a highly organized process.

## 5. Potential for Merger & Conclusion

- **Uniqueness:** This is a highly unique and domain-specific flagship application. Its purpose (wedding planning) is entirely distinct from all other projects in the "rork" ecosystem.
- **Recommendation:** `EverAfter` is a standalone platform and is **not a candidate for a merger**. It is one of the three major, mature applications identified, alongside KONSTRUKT (construction) and Eclat OS (hospitality/community). It demonstrates the "rork" pattern of building powerful, AI-driven applications for specific business verticals using a common set of technologies (React Native, Convex, AI services). Any shared logic or components (especially the AI assistant UI) could be extracted into a shared library, but the application itself is a distinct product.
