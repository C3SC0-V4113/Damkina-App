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

- Do not add unapproved providers/SDKs (Firebase, direct Google Sign-In SDK, Google Maps, OpenStreetMap, Dio, Retrofit, extra backend SDKs, geocoding providers, analytics SDKs, recommendation engines) without an accepted ADR.
- Accepted exceptions:
  - `Mapbox` is allowed for map selection through the `MapPicker` boundary (`ADR-0002`).
  - `Mapbox` reverse geocoding/elevation is allowed only for lightweight picker preview UX through a dedicated geodata boundary (`ADR-0004`).
  - `supabase_flutter` is allowed for Auth/Database/Storage/Edge Functions (`ADR-0003`) behind `AuthRepository` and repository interfaces.
- Keep auth behind `AuthRepository`.
- Keep map selection behind `MapPicker`.
- Keep geodata preview behind `LocationSelectionMetadataResolver`.
- Keep backend and Edge Function access behind repository interfaces in the data layer.
- Prefer fake/local repositories first, then migrate incrementally to real adapters without coupling views to SDK clients.
- Never expose `SUPABASE_SERVICE_ROLE_KEY` in client apps.

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
