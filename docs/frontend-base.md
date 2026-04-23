# Damkina Flutter Frontend Base

This base follows the accepted frontend ADR:

- MVVM with feature-first folders.
- Riverpod for state and dependency injection.
- `AsyncValue` through Riverpod `FutureProvider` for loading/error/data.
- `go_router` for declarative routing.
- Freezed and `json_serializable` for immutable models.
- Repository interfaces with fake/local implementations while backend, auth,
  maps, geocoding, and recommendation providers remain undecided.

Figma was used as mobile reference for the supported screen list and bottom
navigation shape. Figma variables were not available through MCP because the
Starter plan call limit was reached, so theme tokens are manual and temporary.

Pending ADRs before real integrations:

- Backend and API contracts.
- Google auth provider.
- Map and geocoding provider.
- Recommendation engine.
- Crop image source.
