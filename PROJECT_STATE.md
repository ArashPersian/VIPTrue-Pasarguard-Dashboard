# PROJECT_STATE

- Project: VIPTrue PasarGuard Dashboard
- Upstream compatibility: PasarGuard `v5.1.0`
- Compatibility branch: `viptrue/v5.1.0`
- Working branch: `agent/fix-brand-theme-compat`
- Base release: `v5.1.0-custom.2`
- Base commit: `17d698b7c91c7719c680fe9d9cc75bf19716dacf`
- Patch release: `v5.1.0-custom.3`
- Merged PR: `#3`
- Merge and release commit: `86f52b8671975a564017c23888b1076ef7945dd6`
- Theme implementation commit: `8937415fa2ff017a501e02258d067f6992b7adbc`
- Reseller hardening commit: `7cd02ae004ae83839dd480ce0fbd91b59ddb64b5`

## Current production state

- `v5.1.0-custom.2` is active at `https://panel.vip504.com/dashboard/`
- Nginx is active and Dashboard plus brand endpoints return HTTP `200`
- Backend/API/database/subscription behavior remain unchanged
- Owner session was manually authenticated for the browser audit
- All 27 major Owner routes loaded their expected page heading without an
  application alert or visible PasarGuard branding
- Reseller session was manually authenticated for the browser audit
- Reseller navigation exposes only Dashboard, Users, API Keys and Settings
- Dashboard, Users, API Keys and Theme loaded with the `VIPTrue Reseller Panel`
  title, VIPTrue support link and no application console errors
- Direct navigation to all 25 Owner-only Statistics, Hosts, Groups, Nodes,
  Cores, Logs, Templates, Admins, Admin Roles, administrative Settings and
  Bulk routes was redirected to the Reseller Dashboard
- No version/update notice or visible PasarGuard branding appeared for Reseller
- Reseller `Blue + Dark` persisted after reload and was restored to
  `Default + System` after the test
- Existing non-default theme selection and persistence work, but production
  still has a neutral/flat page surface and an incomplete Live Preview

## Implemented for v5.1.0-custom.3

- Replaced the incorrect shield mark in the compact sidebar, favicon,
  Apple touch icon and web manifest with the official winged VIPTrue logo
- Reused the optimized `1024x585` official logo already shipped by the
  dashboard (`353196` bytes) instead of the `1.28 MiB` source attachment
- Removed the obsolete `viptrue-mark.svg` from the release payload
- Added palette-specific surfaces for Default, Red, Rose, Orange, Green,
  Blue, Yellow and Violet in both Light and Dark modes
- Each palette now controls the page gradient, neon highlight, cards,
  inputs, popovers, sidebar surfaces and existing primary/chart colors
- Rebuilt Live Preview to show the real themed background, compact brand,
  sidebar, cards, chart colors, input and primary action in real time
- Removed fixed page backgrounds and card-wide backdrop blur to reduce
  scroll/paint cost, especially on mobile and lower-power devices
- Added release-gating budgets for total build size, static file count,
  main JavaScript/CSS, Theme route, logo and dashboard entrypoint
- Added the performance budget gate to both dashboard CI and tagged releases
- Hid the Cores list editor preference unless the signed-in role can read Cores;
  the production audit exposed this irrelevant Owner-only preference to
  Reseller even though RouteGuard correctly blocked the Cores page
- Added a static release gate for the Cores preference permission check

## Verification completed

- `git diff --check`
- VIPTrue branding, owner-gate, theme-surface and obsolete-logo verification
- Focused ESLint: zero errors; two pre-existing Fast Refresh warnings
- Clean production Vite build: `5278` modules, `5.09s`
- Release-equivalent build with `VITE_BASE_API=/`
- Dashboard build after Reseller hardening: `21902186` bytes across `328`
  static files including
  the release `404.html`
- Main JavaScript: `126550` bytes raw / `35617` bytes gzip
- Main CSS: `241619` bytes raw / `32570` bytes gzip
- Theme route: `18811` bytes raw / `4392` bytes gzip
- Official optimized logo: `353196` bytes
- Performance budgets passed
- Reseller-audit test archive SHA256:
  `427da20ab707aca495b5283e501d2d4746a4ea908036aec0dc2ea52d9b477924`
- Archive contains Dashboard/404 entrypoints and the official logo, and does
  not contain the obsolete shield asset
- GitHub `VIPTrue Dashboard CI` run `#14` passed on Reseller hardening commit
  `7cd02ae`
- PR `#3` was merged into `viptrue/v5.1.0` at `86f52b8`
- Release publisher workflow run `#2` (`30448278721`) completed successfully
- Release tag `v5.1.0-custom.3` points exactly to merge commit `86f52b8`
- Release contains the dashboard archive and its SHA256 file; the one-time
  publisher branch was deleted automatically
- Independently downloaded release archive SHA256:
  `e8dc8aad9f4045cda7db299db02d98e46e72e3c3bfdbd29dfaca61b2003918cc`
- Tagged installer SHA256:
  `7080bebd7b3faa3e7659704e73d43eeb6796a388a3d776a4961bb6b18bc3719d`

Known upstream baseline: Monaco/Ace editor worker chunks above Vite's generic
`500 kB` warning remain unchanged from PasarGuard `v5.1.0`. The VIPTrue patch
does not add an editor dependency or eager-load those route-specific chunks.

## Remaining work

- Install `v5.1.0-custom.3` on the production server
- Smoke-test Nginx, Dashboard and official logo endpoints
- Hard-refresh and verify Owner plus Reseller branding, Live Preview,
  palette-specific backgrounds and the hidden Reseller Cores preference

## Next exact step

Download and verify the tagged installer, install `v5.1.0-custom.3` using
archive SHA256
`e8dc8aad9f4045cda7db299db02d98e46e72e3c3bfdbd29dfaca61b2003918cc`,
then run the production Nginx/HTTP and Owner/Reseller browser smoke tests.
