# Flight Booking App

A state-of-the-art Flutter flight booking application featuring high-end Glassmorphic UI, MVVM architecture, and professional boarding pass generation. Designed with a focus on pixel-perfection and scalability.

---

## 🛠️ Flutter Version
- **Flutter SDK:** `3.38.9 (Stable)`
- **Dart SDK:** `^3.10.8`

---

## 🚀 Getting Started

### Prerequisites
*   Flutter SDK installed and configured.
*   Android Studio / VS Code / Xcode (for iOS).
*   Active Internet Connection (to fetch real-time flight data).

### Steps to Run
The project uses **Dart entry points** for environment management (Development, Staging, Production). Follow these steps to get the app running:

1.  **Clone the repository** (if not already local).
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the application (choose an environment):**
    *   **Development:**
        ```bash
        flutter run -t lib/main_dev.dart
        ```
    *   **Staging:**
        ```bash
        flutter run -t lib/main_staging.dart
        ```
    *   **Production:**
        ```bash
        flutter run -t lib/main_prod.dart
        ```

---

## 📦 Key Dependencies Used

### Core Architecture
*   **Navigation:** `go_router` (Centralized declarative routing)
*   **State Management:** `provider` (MVVM pattern implementation)
*   **Dependency Injection:** `get_it` (Service locator for repositories and services)

### Networking & Data
*   **API Client:** `dio` with `dio_smart_retry` (Robust HTTP requests)
*   **Caching:** `dio_cache_interceptor` (Offline-first capabilities)
*   **Local Database:** `sqflite` (Persistence for saved trips)
*   **Connectivity:** `connectivity_plus` (Real-time network status monitoring)

### UI & UX
*   **Image Loading:** `cached_network_image` (Optimized network image rendering)
*   **Utilities:** `intl` (Currency and Date formatting)
*   **Barcode/QR:** `barcode_widget` (Dynamic QR code generation for tickets)
*   **PDF & Printing:** `pdf` & `printing` (Professional boarding pass generation)
*   **Device Testing:** `device_preview` (UI responsiveness testing)

---

## 🏛️ Approach & Thought Process

### 1. Architectural Strategy: MVVM + Clean Architecture
I adopted a modular approach inspired by industry standards (MNC-level projects) to ensure the codebase is maintainable and testable:
*   **Presentation Layer:** Uses `ChangeNotifier` (via Provider) to decouple business logic from the UI. Barrel files are used to keep exports clean.
*   **Domain Layer:** Defines abstract repository interfaces, ensuring the UI doesn't depend on direct data sources.
*   **Data Layer:** Handles API calls and local SQLite storage. Implements repository contracts.
*   **Core Layer:** Centralized theme tokens (HSL-based), constants, and shared utility functions.

### 2. Design Philosophy: Premium Glassmorphism
The UI was built to "WOW" the user at first glance:
*   **Visuals:** Extensive use of `BackdropFilter` for frosted glass effects, vibrant gradients, and curated HSL color palettes.
*   **Interactions:** Custom micro-animations, `BouncingScrollPhysics`, and animated transitions (like the 'From-To' swap) to enhance engagement.
*   **Responsiveness:** Meticulous attention to padding, sizing, and typography to achieve a 100% pixel-perfect match with modern design trends.

### 3. Feature Highlights
*   **Ticket Lifecycle:** Users can search for flights, view details, book, and download professional PDF boarding passes directly to their device.
*   **Robustness:** Integrated error handling for network failures, empty states for saved data, and a persistent connectivity wrapper.

---

## ⏱️ Development Summary
*   **Approximate Hours:** ~18 to 20 hours.
*   **Workload:** This includes initial architecture setup, UI design iterations, implementing the local database for saved trips, PDF generation logic, and final pixel-perfect refinements.

---

*Built By Sayak Mishra*
