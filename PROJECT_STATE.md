# PROJECT_STATE

- Project: VIPTrue PasarGuard Dashboard
- Upstream compatibility target: PasarGuard `v5.2.1`
- Official upstream commit: `e81877c0df64e5f5235f4355b0490b6bb38e3adc`
- Compatibility branch: `viptrue/v5.2.1`
- Working branch: `agent/v5.2.1-compat`
- Tested compatibility commit: `d581ce186969460ff7a64fcc5568208b8715acf0`
- Previous release: `v5.1.0-custom.3`
- Planned release: `v5.2.1-custom.1` (not tagged or released yet)
- Production deployment: unchanged; no v5.2.1 deployment has been performed

## Compatibility policy

- PasarGuard upstream remains the source of truth for backend, API, database
  migrations, protocol support and new dashboard functionality.
- VIPTrue is maintained as a customization layer for branding, themes,
  owner-only update visibility, reseller privacy/RBAC presentation and safe
  release/install/rollback tooling.
- Sensitive files changed by both upstream and VIPTrue are reconstructed from an
  explicit source and then adapted deliberately instead of accepting blind
  automatic merges.
- Production must never run an upstream panel update before a matching tested
  VIPTrue compatibility release exists.

## v5.2.1 compatibility work completed

- Ported the VIPTrue customization layer onto the official PasarGuard v5.2.1
  commit without replacing the new upstream backend.
- Preserved v5.2.1 package/dependency versions, including
  `@pasarguard/core-kit@0.2.8` and `@pasarguard/xray-config-kit@0.3.6`.
- Preserved the new `/nodes/wireguard` dashboard navigation and removed the old
  `/bulk/wireguard` navigation that upstream removed.
- Preserved the v5.2.1 Host/FinalMask implementation and changed only the
  visible VIPTrue remark example.
- Preserved the complete v5.2.1 Login/Owner setup/authentication implementation
  and reapplied only VIPTrue logo/title presentation.
- Kept upstream locale JSON files pristine so future upstream translation keys
  arrive automatically; VIPTrue product strings now use
  `dashboard/src/brand/i18n-overrides.ts` at runtime.
- Kept the standard upstream translation key `nodes.addNewPasarGuardNode` and
  override only its displayed value, eliminating an avoidable future conflict.
- Retained VIPTrue owner-only update checks, reseller privacy guards, winged
  logo, custom Control Center/Reseller titles, support link and eight-palette
  theme system.
- Updated branding verification for the runtime translation overlay and added
  explicit v5.2.1 WireGuard navigation invariants.
- Added `scripts/port-viptrue-v5.2.1.sh` as the deterministic compatibility
  audit/port record for this upgrade.

## Upstream v5.2.1 functionality retained

The compatibility branch is based on the complete official v5.2.1 tree, so the
upstream backend/API/database work remains present, including the v5.2.x Xray,
WireGuard, Reality Scan, FinalMask/Salamander, generated API and dashboard
changes. In particular, the dashboard build contains the new WireGuard subnet
route and the new upstream Host/Core editor surfaces.

## Verification completed on 2026-08-17

GitHub Actions compatibility run `#5` (`32024680584`) passed all gates:

- deterministic VIPTrue port/merge: passed
- dependency installation with the v5.2.1 lockfile: passed
- VIPTrue branding and owner/reseller invariant verification: passed
- focused ESLint: zero errors; two existing Fast Refresh warnings only
- full production Vite build: passed, `5607` modules transformed
- build time in the measured run: about `5.34s`
- main JavaScript: `127156` bytes raw / `35754` bytes gzip
- main CSS: `241641` bytes raw / `32845` bytes gzip
- Theme route: `18771` bytes raw / `4376` bytes gzip
- official VIPTrue logo: `353196` bytes
- total dashboard build: `22307722` bytes across `325` static files
- v5.2.1 total-build budget calibrated from `22_250_000` to `22_500_000`
  bytes because the upstream feature set increased the complete build by about
  1.85% while the main VIPTrue-controlled bundles remained inside their existing
  limits; all performance gates then passed.
- tested merge was pushed successfully to `agent/v5.2.1-compat` at
  `d581ce186969460ff7a64fcc5568208b8715acf0`.

Known upstream baseline: Monaco/Ace editor worker chunks above Vite's generic
500 kB warning remain route-specific upstream editor assets; the VIPTrue layer
does not make them eager or add a new editor dependency.

## Remaining work

- Remove the temporary one-shot compatibility workflow before the final merge.
- Open a Draft PR from `agent/v5.2.1-compat` to `viptrue/v5.2.1` and run the
  repository PR checks, especially database migration/API checks where enabled.
- Review the final diff against official v5.2.1 for accidental backend changes.
- Perform Owner and Reseller browser smoke tests against a non-production or
  staged v5.2.1 instance before release.
- After all checks are green, prepare `v5.2.1-custom.1` for explicit release
  approval. Do not tag, release or deploy without approval.

## Next Exact Step

Delete `.github/workflows/viptrue-v521-port.yml`, open the Draft compatibility
PR against `viptrue/v5.2.1`, run and inspect all PR checks, then resolve any
remaining migration/API/dashboard failures before requesting approval for
`v5.2.1-custom.1`.
