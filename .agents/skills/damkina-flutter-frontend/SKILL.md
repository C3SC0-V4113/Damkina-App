---
name: damkina-flutter-frontend
description: Damkina Flutter frontend architecture guardrails. Use when working in the Damkina Flutter app, especially for feature-first MVVM structure, Riverpod providers/state, go_router navigation, Freezed/json_serializable models, fake repositories, design tokens, tests, or any frontend change that must follow the accepted ADR and context hub rules.
---

# Damkina Flutter Frontend

## First Step

Read project context before proposing or changing architecture, navigation, state, dependencies, structure, or integrations:

1. `e:\Repositorios\damkina-context-hub\AGENTS.md`
2. `e:\Repositorios\damkina-context-hub\01-contextos\decisiones\0001-arquitectura-frontend-flutter-mvvm-riverpod.md`
3. `e:\Repositorios\damkina-context-hub\01-contextos\frontend-flutter\2026-04-21-contexto-frontend-flutter-mvp.md`
4. `e:\Repositorios\damkina-context-hub\01-contextos\producto\2026-03-29-plan-mvp-damkina.md`
5. `e:\Repositorios\damkina-context-hub\05-referencias\referencia-diseno-figma-mobile.md`

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

Do not add Firebase, Google Sign-In, Google Maps, Mapbox, OpenStreetMap, Dio, Retrofit, backend SDKs, geocoding providers, analytics, or recommendation-engine dependencies unless a later accepted ADR explicitly approves them.

Auth and maps must remain abstracted:

- `AuthRepository` is the auth boundary; real Google/Firebase auth needs ADR.
- `MapPicker` is the map selection boundary; real map/geocoding providers need ADR.
- Backend/API contracts and recommendation engines need ADR before implementation.

When a third-party skill or external advice conflicts with Damkina ADRs, follow Damkina ADRs.

## UI And Design

Use the Figma mobile design as reference for structure and visual direction, but keep tokens manual until Figma variables are available. Implement reusable tokens/components before copying per-screen styles.

Initial supported screens are login, onboarding name, onboarding location/map, add/edit location, crops recommendations/home, crop detail, locations, profile, and mobile bottom navigation.

## Work Style

Keep changes small, reviewable, and traceable to context. Before modifying architecture, navigation, state, dependencies, or structure, cite the ADR/context file used.

Do not implement full screens when the user asks for foundation or structure. Do not introduce real integrations in placeholder or MVP scaffolding work.

## Validation

For Flutter code changes, run the relevant checks when feasible:

```powershell
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

Run build_runner only when Freezed/json_serializable inputs changed. If a command cannot run, report the exact blocker.
