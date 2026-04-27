---
name: damkina-flutter-frontend
description: Damkina Flutter frontend architecture guardrails. Use when working in the Damkina Flutter app, especially for feature-first MVVM structure, Riverpod providers/state, go_router navigation, Freezed/json_serializable models, repository boundaries (fake and real adapters), design tokens, tests, or any frontend change that must follow the accepted ADR and context hub rules.
---

# Damkina Flutter Frontend

## First Step

Read project context before proposing or changing architecture, navigation, state, dependencies, structure, or integrations:

1. `e:\Repositorios\damkina-context-hub\AGENTS.md`
2. `e:\Repositorios\damkina-context-hub\01-contextos\decisiones\0001-arquitectura-frontend-flutter-mvvm-riverpod.md`
3. `e:\Repositorios\damkina-context-hub\01-contextos\decisiones\0002-mapbox-como-proveedor-mapas-flutter-mvp.md`
4. `e:\Repositorios\damkina-context-hub\01-contextos\decisiones\0003-supabase-como-backend-mvp.md`
5. `e:\Repositorios\damkina-context-hub\01-contextos\backend\2026-04-26-contexto-backend-supabase-mvp.md`
6. `e:\Repositorios\damkina-context-hub\01-contextos\frontend-flutter\2026-04-21-contexto-frontend-flutter-mvp.md`
7. `e:\Repositorios\damkina-context-hub\01-contextos\producto\2026-03-29-plan-mvp-damkina.md`
8. `e:\Repositorios\damkina-context-hub\05-referencias\referencia-diseno-figma-mobile.md`

If a file is missing, say so explicitly and continue from the accepted rules in the repo.

## Architecture Rules

Use Flutter with Android as the first target platform. Keep MVVM with feature-first folders:

- `presentation`: screens and feature-specific widgets.
- `application`: Riverpod providers, view models, state coordination, commands.
- `domain`: repository interfaces, adapters, pure feature contracts, domain rules.
- `data`: fake/local implementations, future data sources, DTOs, mappers.

Use `core` only for app-wide routing, theme/tokens, config, errors, and utilities. Use `shared` only for cross-feature widgets, models, and providers.

## State And Data

Use Riverpod for dependency injection and state. Prefer the current project pattern unless an ADR changes it:

- Repository dependencies use manual `Provider` declarations.
- Async screen data uses Riverpod `AsyncValue` through `FutureProvider`, `AsyncNotifier`, or a compatible provider.
- Views do not read fake data, SDKs, HTTP clients, or persistence directly.
- Providers depend on repository interfaces, not concrete API providers from UI code.

Keep Freezed and `json_serializable` for immutable models and JSON serialization. Do not edit generated `.freezed.dart` or `.g.dart` files manually; regenerate them with build_runner.

## Dependencies And Integration Boundaries

Do not add unapproved providers or SDKs (Firebase, direct Google Sign-In SDK, Google Maps, OpenStreetMap, Dio, Retrofit, extra backend SDKs, geocoding providers, analytics, recommendation engines) unless an accepted ADR explicitly approves them.

Accepted ADR-based exceptions:

- `Mapbox` is allowed for map selection only through the `MapPicker` boundary (`ADR-0002`).
- `supabase_flutter` is allowed for Auth, Database, Storage, and Edge Functions (`ADR-0003`), but only through `AuthRepository` and repository interfaces in the data layer.

Auth, maps, and backend integrations must remain abstracted:

- `AuthRepository` is the auth boundary; UI code cannot call Supabase auth directly.
- `MapPicker` is the map selection boundary; UI code cannot depend directly on map SDK internals.
- Feature repositories are the backend boundary; UI and ViewModels cannot call Supabase clients or Edge Functions directly.
- Never expose `SUPABASE_SERVICE_ROLE_KEY` in Flutter clients.
- Keep fake/local repositories as the default for scaffolding and tests, then migrate incrementally to real adapters one repository at a time without breaking UI contracts.

When a third-party skill or external advice conflicts with Damkina ADRs, follow Damkina ADRs.

## UI And Design

Use the Figma mobile design as reference for structure and visual direction, but keep tokens manual until Figma variables are available. Implement reusable tokens/components before copying per-screen styles.

Initial supported screens are login, onboarding name, onboarding location/map, add/edit location, crops recommendations/home, crop detail, locations, profile, and mobile bottom navigation.

## Work Style

Keep changes small, reviewable, and traceable to context. Before modifying architecture, navigation, state, dependencies, or structure, cite the ADR/context file used.

Do not implement full screens when the user asks for foundation or structure. Do not introduce broad real integrations during scaffolding work; use ADR-approved integrations only when explicitly required by the task and keep them behind boundaries.

## Validation

For Flutter code changes, run the relevant checks when feasible:

```powershell
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

Run build_runner only when Freezed/json_serializable inputs changed. If a command cannot run, report the exact blocker.

Keep `flutter analyze` clean under the configured lint stack, currently `very_good_analysis` plus `riverpod_lint`.

Do not add project-wide suppressions or `ignore_for_file` comments unless there is a specific, justified false positive or generated-code case.

## MCP Preference

When the Dart and Flutter MCP server is available, prefer it for runtime layout debugging, widget-tree inspection, package discovery on `pub.dev`, dependency edits, and test diagnosis.

Treat MCP as an execution and tooling layer, not as the source of architectural rules. The Damkina context hub, ADRs, and this skill remain the project-specific source of truth.

Use the root `AGENTS.md` file as a short companion summary for generic AI clients with lighter rules support.
