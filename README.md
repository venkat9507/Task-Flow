# Task Flow

A beautiful, intuitive personal to-do list app with offline-first architecture, built with Flutter.

## 📱 Features

-   **Task Management**: Create, edit, delete, and complete tasks seamlessly.
-   **Categories**: Organize tasks with custom categories (Personal, Work, Shopping, etc.) with color-coding and icons.
-   **Advanced Filtering & Sorting**:
    -   Filter by Pending, Completed, Today, Overdue, or High Priority.
    -   Sort by Due Date (Earliest first) or Priority.
    -   Quickly clear filters to view all tasks (Newest first).
-   **Authentication Flow**: Secure login system (mocked for demo) with persistent session management.
-   **Settings & Customization**:
    -   **Theme**: Support for Light, Dark, and System modes using `flex_color_scheme`.
    -   **Data Management**: Clear completed tasks or reset all app data (Tasks & Categories).
    -   **Category Management**: Dedicated screen to manage categories.
-   **Animations**: Smooth UI transitions using `flutter_animate`.
-   **Offline-First**: robust local database ensured data is always available.

## 🛠 Tech Stack

-   **Framework**: Flutter (Dart)
-   **Flutter Version**: `3.35.7`

### Architecture
The app follows **Clean Architecture** principles to ensure separation of concerns, scalability, and testability:
-   **Presentation Layer**: UI (Screens, Widgets) and State Management (Providers/Notifiers).
-   **Domain Layer**: Entities, Use Cases, and Repository Interfaces (Pure Dart, no Flutter dependencies).
-   **Data Layer**: Models, Data Sources (Local/Remote), and Repository Implementations.

### State Management
**Choice**: [Riverpod](https://riverpod.dev/) (`flutter_riverpod` + `riverpod_generator`)

**Why?**
-   **Compile-time safety**: Catches dependency errors early.
-   **Testability**: easy to mock providers and override dependencies.
-   **Separation of concerns**: Notifiers manage business logic separate from UI widgets.
-   **Dependency Injection**: Integrates cleanly with Clean Architecture.

### Persistence
**Choice**:
1.  **[sqflite](https://pub.dev/packages/sqflite)**: For structured data (Tasks, Categories).
    *   **Why?**: Relational data model suits the task-category relationship. efficiently handles filtering, sorting, and large datasets.
2.  **[flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)**: For sensitive data (Auth Tokens).
    *   **Why?**: Industry standard for storing sensitive information securely on-device.

### Dependency Injection
**Choice**: `get_it` + `injectable`
*   **Why?**: Automates dependency registration (Singleton, Factory) via code generation, reducing boilerplate and ensuring type safety across layers.

## 🚀 Setup Instructions

1.  **Prerequisites**:
    -   Flutter SDK installed and configured.
    -   An IDE (VS Code or Android Studio).

2.  **Clone the Repository**:
    ```bash
    git clone https://github.com/yourusername/task_flow.git
    cd task_flow
    ```

3.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

4.  **Generate Code**:
    This project uses code generation for Riverpod, Freezed, and JSON serialization. You **MUST** run this command:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

5.  **Run the App**:
    ```bash
    flutter run
    ```

## ⚖️ Assumptions & Trade-offs

-   **Local-First Assumption**: The app assumes a single-user environment on a single device. Data is stored locally.
-   **Build Runner**: A heavy reliance on code generation (`build_runner`) improves developer experience (less boilerplate, more safety) but adds a step to the build process.
-   **Mock Authentication**: The current backend is simulated. It accepts any email/password (e.g., `user@example.com` / `password`) but simulates a realistic network delay and token storage flow.

## ⚠️ Known Limitations

-   **No Remote Sync**: Data does not sync across devices (Cloud sync is planned for future versions).
-   **Asset Uploads**: Profile pictures and task attachments are not currently supported.
-   **Notifications**: Push notifications for due tasks are not yet implemented.

## 🔧 Project Structure

```
lib/
├── core/               # Core utilities, constants, theme, router, DI
├── features/           # Feature-based folders
│   ├── auth/           # Authentication feature
│   ├── categories/     # Category management
│   ├── tasks/          # Task management (Main feature)
│   └── settings/       # App settings
└── main.dart           # Entry point
```

---
