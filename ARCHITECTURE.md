# 🏗️ Architecture Design - ResumeForge AI

This document outlines the architectural decisions and engineering principles that guide the development of ResumeForge AI. The goal of this architecture is to ensure **scalability**, **maintainability**, and **developer productivity**.

## 🚀 Architectural Pattern: Feature-Sliced Design

The application follows a modular structure where code is organized into folders representing different layers of abstraction. This avoids the "messy one-file" monolith and provides a clean separation of concerns.

### 🍱 Main Layers

1.  **Core (`src/app/core/`)**:
    *   **Services**: Global, singleton services (e.g., `AiService`, `PdfService`, `AuthService`, `StorageService`). 
    *   **Models**: Central source of truth for all record types and interfaces.
    *   **Guards**: Route protection (e.g., `AuthGuard`).
    *   **Config**: Global application configuration.

2.  **Features (`src/app/features/`)**:
    *   Each domain feature (e.g., `builder`, `templates`, `dashboard`, `auth`) is isolated.
    *   Features contain their own components, localized store logic, and routing.
    *   **Privacy**: Features should only communicate through well-defined shared interfaces or the global state.

3.  **Layout (`src/app/layout/`)**:
    *   Global shell components that define the app's structure (e.g., `TopNav`, `Sidebar`, `Footer`).
    *   These components are static or react to global state.

4.  **Shared (`src/app/shared/`)**:
    *   Stateless, reusable UI components (Buttons, Inputs, Cards).
    *   Shared utility pipes and directives.

---

## 🚦 State Management: Angular Signals + @ngrx/signals

ResumeForge AI utilizes modern **Angular Signals** for reactive data flow. This choice provides several advantages over traditional state management:

-   **Fine-Grained Reactivity**: Only the specific parts of the DOM that depend on a signal will update when the signal changes.
-   **Zero Boilerplate**: No need to write complex Actions, Reducers, or Effects for simple state mutations.
-   **SignalStore**: We use `@ngrx/signals` which provides a highly readable and type-safe "Senior-Level" structure for our state logic, including persistence hooks and method-based mutations.

---

## ⚡ Technical Decision Log

### 1. Standalone Components
All components are built using the `standalone: true` property. This removes the need for `NgModules`, simplifying the dependency graph and enabling better treeshaking.

### 2. PDF Rendering Strategy
Instead of generating PDFs on the server, we use a combination of `html2canvas` and `jsPDF` locally on the client. 
-   **Why?** This ensures 100% visual parity with the on-screen preview and avoids the high costs/latencies associated with server-side browser rendering.

### 3. Modular Styling
Styles are kept close to their respective components using Angular's component-scoped CSS. Global theme signals (colors, typography, grid systems) are managed in `src/styles.css` using CSS Variables for easy theme switching.

---

## 📂 Implementation Checklist

- [x] Feature-Sliced Folder Hierarchy
- [x] Standalone Component implementation
- [x] Signal-based State Management
- [x] Lazy-loading for all feature routes
- [x] Clean Service-to-Store communication

*This architecture is designed to grow with the application, allowing for the easy addition of features like real-time collaboration or multi-user accounts.*
