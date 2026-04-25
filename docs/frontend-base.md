# Damkina Flutter Frontend Base

This base follows the accepted frontend ADR:

- MVVM with feature-first folders.
- Riverpod for state and dependency injection.
- `AsyncValue` through Riverpod `FutureProvider` for loading/error/data.
- `go_router` for declarative routing.
- Freezed and `json_serializable` for immutable models.
- Repository interfaces with fake/local implementations while backend, auth,
  geocoding, and recommendation providers remain undecided.
- Map selection uses Mapbox through the `MapPicker` boundary, as accepted in
  `ADR-0002`.

Figma was used as mobile reference for the supported screen list and bottom
navigation shape. Figma variables were not available through MCP because the
Starter plan call limit was reached, so theme tokens are manual and temporary.

Pending ADRs before real integrations:

- Backend and API contracts.
- Google auth provider.
- Geocoding provider.
- Recommendation engine.
- Crop image source.

## AI Workflow In Damkina

Damkina uses three complementary layers for AI-assisted frontend work:

- `damkina-flutter-frontend` skill in `.agents/skills/`:
  the main project-specific source of truth for architecture, dependency
  boundaries, validation, and workflow.
- Root `AGENTS.md`:
  a shorter first-party rules file for AI clients that work better with a
  lightweight project-level instructions file.
- Dart and Flutter MCP server for Codex:
  a tooling layer for Flutter and Dart runtime context, not a replacement for
  project rules.

### When To Use Each Layer

- Use the local skill for Damkina-specific architecture and process rules.
- Use `AGENTS.md` as the compact summary for generic AI clients and lighter
  rule-loading scenarios.
- Use the Dart and Flutter MCP server when available for:
  - runtime or layout debugging,
  - widget-tree inspection,
  - package discovery on `pub.dev`,
  - dependency edits in `pubspec.yaml`,
  - test diagnosis and Flutter/Dart tool interactions with live context.

### Precedence

If guidance conflicts, follow this order:

1. Damkina ADRs and context hub.
2. `.agents/skills/damkina-flutter-frontend`.
3. Root `AGENTS.md`.
4. Generic Flutter rules or external AI guidance.
