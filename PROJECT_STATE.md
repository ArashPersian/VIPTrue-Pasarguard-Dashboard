# PROJECT_STATE

- Project: VIPTrue PasarGuard Dashboard
- Upstream compatibility: PasarGuard `v5.1.0`
- Compatibility branch: `viptrue/v5.1.0`
- Working branch: `agent/fix-brand-theme-compat`
- Base release: `v5.1.0-custom.2`
- Base commit: `17d698b7c91c7719c680fe9d9cc75bf19716dacf`
- Planned patch release: `v5.1.0-custom.3`
- Draft PR: `#3`
- Implementation commit: `8937415fa2ff017a501e02258d067f6992b7adbc`

## Current production state

- `v5.1.0-custom.2` is active at `https://panel.vip504.com/dashboard/`
- Nginx is active and Dashboard plus brand endpoints return HTTP `200`
- Backend/API/database/subscription behavior remain unchanged
- Owner session was manually authenticated for the browser audit
- All 27 major Owner routes loaded their expected page heading without an
  application alert or visible PasarGuard branding
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

## Verification completed

- `git diff --check`
- VIPTrue branding, owner-gate, theme-surface and obsolete-logo verification
- Focused ESLint: zero errors; two pre-existing Fast Refresh warnings
- Clean production Vite build: `5278` modules, `5.09s`
- Release-equivalent build with `VITE_BASE_API=/`
- Dashboard build: `21902132` bytes across `328` static files including
  the release `404.html`
- Main JavaScript: `126550` bytes raw / `35628` bytes gzip
- Main CSS: `241619` bytes raw / `32570` bytes gzip
- Theme route: `18757` bytes raw / `4360` bytes gzip
- Official optimized logo: `353196` bytes
- Performance budgets passed
- Test archive: `6540692` bytes
- Test archive SHA256: `4353fdc1514238f3003ec575f7315a609d8d8b1d8e2af0326b7db5e350bcbbe9`
- Archive contains Dashboard/404 entrypoints and the official logo, and does
  not contain the obsolete shield asset
- GitHub `VIPTrue Dashboard CI` run `#11` passed on the implementation commit
- Draft PR `#3` is one commit ahead of `viptrue/v5.1.0`, zero commits behind,
  conflict-free and mergeable

Known upstream baseline: Monaco/Ace editor worker chunks above Vite's generic
`500 kB` warning remain unchanged from PasarGuard `v5.1.0`. The VIPTrue patch
does not add an editor dependency or eager-load those route-specific chunks.

## Remaining work

- Manually authenticate the browser as a Reseller and audit all Reseller
  routes plus owner-only update/version isolation
- Review and merge the Draft PR
- Publish and independently verify `v5.1.0-custom.3`
- Install the patch release and smoke-test all eight palettes in production

## Next exact step

Have the user log into the cloud browser with a Reseller account, then audit
all Reseller routes and owner-only update/version isolation before PR merge.
