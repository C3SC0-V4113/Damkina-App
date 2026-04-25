# damkina_app

Damkina Flutter MVP app.

## Mapbox Setup

Mapbox is used for location selection flows (`/onboarding/location`,
`/locations/new`, `/locations/:locationId/edit`).

Do not store tokens in the repository. Run with:

```powershell
flutter run --dart-define MAPBOX_ACCESS_TOKEN=YOUR_PUBLIC_MAPBOX_TOKEN
```

If `MAPBOX_ACCESS_TOKEN` is missing, the map picker shows a recoverable
configuration error screen instead of crashing.
