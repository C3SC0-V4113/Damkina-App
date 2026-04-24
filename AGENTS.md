# Damkina Flutter AI Rules

Use Flutter and Dart idiomatically, but keep Damkina project rules above generic framework advice.

## Core Working Rules

- Read the Damkina context hub before changing architecture, navigation, state, dependencies, structure, or integrations.
- Prefer small, reviewable, traceable changes.
- Keep MVVM with feature-first folders.
- Use Riverpod manually for dependency injection and state.
- Use `AsyncValue` or compatible Riverpod async state for loading, error, and data.
- Use `go_router` for navigation.
- Use Freezed plus `json_serializable` for immutable models and JSON serialization.

## Dependency Boundaries

- Do not add Firebase, Google Sign-In, Google Maps, Mapbox, OpenStreetMap, Dio, Retrofit, geocoding providers, analytics SDKs, backend SDKs, or recommendation-engine dependencies without an accepted ADR.
- Keep auth behind `AuthRepository`.
- Keep map selection behind `MapPicker`.
- Prefer fake or local repositories until contracts and providers are formally decided.

## Code Organization

- Put app-wide concerns in `core`.
- Put cross-feature widgets, models, and providers in `shared`.
- Put feature code inside `presentation`, `application`, `domain`, and `data`.
- Do not let views read SDKs, HTTP clients, or fake data directly.

## Validation

- Run `flutter analyze` and keep it clean under the configured lint stack.
- Run `flutter test` when behavior changes or tests exist.
- Run build_runner only when Freezed or `json_serializable` inputs change.

## MCP Preference

When the Dart and Flutter MCP server is available, prefer it for:

- runtime or layout debugging,
- widget-tree inspection,
- package discovery on `pub.dev`,
- test diagnosis,
- Flutter and Dart tool interactions with live context.

Use the local skill `damkina-flutter-frontend` for project-specific architecture and process rules. If generic Flutter guidance conflicts with Damkina ADRs, Damkina ADRs win.
