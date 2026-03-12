# Premium Flight Booking App

A state-of-the-art Flutter flight booking application featuring high-end Glassmorphic UI, MVVM architecture, and professional PDF ticket generation.

## 🚀 Getting Started

### Prerequisites
*   Flutter SDK (^3.10.8)
*   Android Studio / VS Code
*   Active Internet Connection (for API data)

### Steps to Run
The project uses **Flavors** for environment management. Use the following commands to run the app:

*   **Development Environment:**
    ```bash
    flutter run -t lib/main_dev.dart
    ```
*   **Staging Environment:**
    ```bash
    flutter run -t lib/main_staging.dart
    ```
*   **Production Environment:**
    ```bash
    flutter run -t lib/main_prod.dart
    ```

## 📦 Key Dependencies
*   **Navigation:** `go_router`
*   **State Management:** `provider`
*   **Dependency Injection:** `get_it`
*   **Networking:** `dio` & `dio_smart_retry`
*   **Local Database:** `sqflite`
*   **PDF & Printing:** `pdf` & `printing`
*   **UI Components:** `cached_network_image`, `barcode_widget`, `device_preview`
*   **Utils:** `path_provider`, `permission_handler`, `intl`

## 🏛️ Architecture & Approach

### 1. MVVM + Clean Architecture
The project follows a modular structure inspired by MNC standards:
*   **Presentation Layer:** ViewModels handle state logic using `ChangeNotifier`. Screens are built with reusable widgets.
*   **Domain Layer:** Abstract repositories define the contracts for data operations, ensuring decoupled logic.
*   **Data Layer:** Concrete implementations of repositories handling API calls (via Dio) and local storage (via SQLite).
*   **Core:** Centralized constants, theme tokens, router configuration, and shared utilities.

### 2. Design Philosophy: Premium Glassmorphism
*   Implemented a high-end "Frosted Glass" aesthetic using `BackdropFilter` and translucent HSL-based color schemes.
*   Focused on micro-animations and `BouncingScrollPhysics` to ensure a native, luxury feel across both iOS and Android.

### 3. Professional Features
*   **PDF Generation:** MNC-standard boarding passes generated with QR codes and saved directly to the device's Download folder.
*   **Robust Routing:** Centralized `GoRouter` with barrel-file exports for scalable navigation management.
*   **Connectivity Management:** Real-time internet monitoring with a persistent connectivity wrapper.

## ⏱️ Development Summary
*   **Approach:** Systematic builds starting from core design tokens to feature-specific implementation, followed by architectural optimization (Barrel exports/DI).
*   **Hours Taken:** Approximately **28 hours** (including design iteration, architecture setup, and feature refinement).

---
*Developed with focus on Pixel-Perfection and Scalability.*
