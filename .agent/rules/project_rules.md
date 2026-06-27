---
trigger: always_on
---

# Project Rules

## Architecture & Structure

- **Feature-First Architecture**: Features are located in `lib/features/`. Each feature directory typically contains:
  - `view/`: Widgets and pages.
  - `controller/`: State management (Controllers/Cubits).
  - `data/`: Repositories and data sources (if specific to feature).
  - `model/`: Feature-specific models.
- **Proprietary Core**: Common utilities, widgets, and configurations are in `lib/core/`.
- **Dependency Injection**: Use `rxget`'s `GetIn` / `GetInWidget` for dependency injection.
  - Register dependencies in `lib/core/di/di.dart` or locally using `GetInWidget` for feature-scoped or transient dependencies.
  - Example: `GetInWidget(dependencies: [GetIn(() => MyController())], child: ...)`

## State Management

- **RxGet**: Use `rxget` for reactive state management and dependency injection.
- **Flutter Hooks**: Use `HookWidget` for UI logic and local state management where appropriate.
- **Flutter Bloc**: Used in some areas (check context), but `rxget` seems primary for newer features based on `AuthPage` and `Di`.

## Navigation

- **AutoRoute**: Use `auto_route` for all navigation.
  - Define routes in `lib/core/routes/app_router.dart` and `app_route_enum.dart`.
  - Use `@RoutePage()` annotation for page widgets.
  - Navigate using `context.router.push(...)` or `AutoRouter.of(context)...`.

## Styling & Theme

- **Gap**: Use `Gap` widget for spacing (instead of `SizedBox`).
- **Assets**: Use `gen/assets.gen.dart` (FlutterGen) for accessing assets (e.g., `Assets.icon.support.image(...)`).
- **Theming**: Access theme colors via `context.appColor` extension (e.g., `context.appColor.splash`).

## Utilities & Helpers

- **Internationalization (i18n)**: Use `slang` (t. ...) for strings (e.g., `t.appSupport`).
- **Data Models**: Use `freezed` and `json_serializable` for immutable data models.

## Coding Conventions

- **Imports**: Prefer relative imports for files within the same feature/module, and absolute imports (package:...) for core or external dependencies? (Codebase uses both, but relative seems common in features). *Self-correction: Codebase uses relative imports for local feature files and strict separation.*
- **Linting**: Follow standard Dart linting rules as enforced by the project.

## Specific Libraries

- **Supabase**: Used for backend interaction (`Supabase.instance.client`).
- **Hive**: Used for local storage.

## General AI Behavior

- **Clean Code**: Prioritize readability and separation of concerns.
- **Proactive Refactoring**: If you see opportunities to move logic to utilities (like `UrlLauncherUtil`), suggest or do it.
- **Context Awareness**: Check `Di` container for available services before creating new instances.
- **Flutter UI Best Practices**:
    * **Use Widget Classes Over Widget Functions**: Always prefer creating separate, standalone `StatelessWidget` or `StatefulWidget` (or `HookWidget`) classes instead of writing helper methods/functions that return a `Widget` (e.g., `_buildMyWidget()`).
    * **Strict 200-Line Limit**: Enforce a maximum limit of 200 lines of code for any single widget class (ideally keeping them under 100 lines) to guarantee high readability and ease of testing.
    * **Separate Widgets**: Separate widgets into their own dedicated files under the appropriate directory structure (e.g., in a `widgets/` folder of the feature) rather than cluttering a single file with multiple widgets.

## Build & Package Management

- **Swift Package Manager (SPM)**: Use Swift Package Manager for iOS package management.
  - **No CocoaPods**: Do NOT create, configure, or commit CocoaPods files (such as `Podfile`, `Podfile.lock`, `Pods/` directory, or `.xcworkspace`) to the repository. If any CocoaPods files are auto-generated during development, build, or analysis tasks, delete or ignore them immediately, as the project solely relies on Swift Package Manager.
