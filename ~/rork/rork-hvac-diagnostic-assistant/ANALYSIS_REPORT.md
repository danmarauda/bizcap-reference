# In-Depth Analysis Report: rork-hvac-diagnostic-assistant

## 1. Project Overview

- **Project Name:** HVAC Diagnostic Assistant
- **Inferred Purpose:** A specialized mobile application designed to assist HVAC (Heating, Ventilation, and Air Conditioning) technicians in the field. The app uses AI to diagnose problems, likely by processing audio, video, and other data collected by the technician.
- **Development Stage:** **Active Development**. The last commit was 4 days ago. The project has a clear, focused feature set and established connectivity to its core AI service.

## 2. Technology Stack

- **Core:** Expo (React Native), TypeScript.
- **AI Backend:** **Google Gemini**. The project has a dedicated `api/geminiService.ts` file for interacting with the Gemini API, which is the core of its diagnostic capabilities.
- **UI Style:** The presence of a `components/glass/` directory suggests the application uses a "glassmorphism" UI style, aiming for a modern, semi-transparent aesthetic.
- **Backend:** Contains the standard Hono/tRPC boilerplate, which is not used for the core AI functionality.

## 3. Core Functionality & Features

- **AI-Powered Diagnostics:** The central feature is using Gemini to analyze HVAC issues.
- **Field-Oriented Workflow:** The app's structure suggests a specific workflow for technicians:
    1.  **Scan:** An `ar-scan.tsx` screen implies the use of Augmented Reality to scan HVAC units.
    2.  **Record:** A `recording.tsx` screen allows the technician to capture data (likely audio or video). A `WaveformBanner.tsx` component supports this.
    3.  **Report:** A `report.tsx` screen displays the AI-generated diagnostic report.
- **Information Hub:** The app also provides access to `Manuals` and `Job Summary` information, making it a comprehensive tool for technicians on-site.

## 4. Project Structure

- `api/`: Contains the client-side service for connecting to the Google Gemini API. This is the most critical part of the application's logic.
- `app/`: A simple layout focused on the Scan -> Record -> Report workflow.
- `components/`: Contains UI elements for displaying diagnostic information, timelines, and components for a "glass" UI.
- `backend/`: Standard boilerplate, not a functional backend.

## 5. Potential for Merger & Conclusion

- **Uniqueness:** This is a highly specialized, vertical-specific tool. Its purpose (HVAC diagnostics) is unique within the "rork" ecosystem.
- **Recommendation:** This is a standalone application and **not a candidate for a merger**. Its specific workflow and UI are tailored for a single purpose. Like the other unique "rork" apps, it could benefit from a shared component library for basic UI elements, but the core application is distinct. It represents another example of the "rork" strategy: applying a common tech stack and AI to solve problems in diverse, specific industries.
