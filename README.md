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

## Supabase Auth Setup (Android)

The login flow uses Supabase Auth with Google OAuth and routes users by
`profiles.custom_name`:

- `custom_name` empty -> onboarding name.
- `custom_name` present -> crops.

Run with Supabase + Mapbox defines:

```powershell
flutter run `
  --dart-define MAPBOX_ACCESS_TOKEN=YOUR_PUBLIC_MAPBOX_TOKEN `
  --dart-define SUPABASE_URL=https://YOUR_PROJECT.supabase.co `
  --dart-define SUPABASE_PUBLISHABLE_KEY=sb_publishable_xxx
```

Before testing Google login end-to-end, complete this checklist in Supabase:

1. Enable Google provider in `Authentication > Providers > Google`.
2. Add Android Client ID(s) in the provider configuration.
3. Set `Site URL` to a non-localhost URL (for example your project URL) to avoid fallback redirects to `http://localhost:3000`.
4. Add both redirect URLs in `Authentication > URL Configuration > Redirect URLs`:
   - `damkinaapp://login-callback`
   - `damkinaapp://login-callback/`
