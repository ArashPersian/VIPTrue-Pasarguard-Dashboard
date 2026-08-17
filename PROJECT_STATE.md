# PROJECT_STATE

- Project: VIPTrue PasarGuard Dashboard
- Upstream compatibility target: PasarGuard `v5.2.1`
- Official upstream commit: `e81877c0df64e5f5235f4355b0490b6bb38e3adc`
- Compatibility branch: `viptrue/v5.2.1`
- Working branch used for compatibility: `agent/v5.2.1-compat`
- Merged compatibility PR: `#5`
- Merge commit: `98e2054f6e40fcc5a0c5bb32f1c2e85625210cb3`
- Previous release: `v5.1.0-custom.3`
- Current release: `v5.2.1-custom.1`
- Release archive SHA256: `e8e4bf96c5570396382f9559e3630d21512616f4f4c939533c3eb0507c23e6bc`
- Production deployment: not performed yet

## Compatibility policy

- PasarGuard upstream remains the source of truth for backend, API, database
  migrations, protocol support, generated API and new dashboard functionality.
- VIPTrue remains a customization layer for branding, themes, owner-only update
  visibility, reseller privacy/RBAC presentation, and safe release/install/
  rollback tooling.
- Production must never run an upstream panel update before a matching tested
  VIPTrue compatibility release exists.

## v5.2.1 compatibility work completed

- Ported VIPTrue onto the complete official PasarGuard v5.2.1 tree without
  replacing or modifying the new upstream backend.
- Preserved v5.2.1 dependencies including `@pasarguard/core-kit@0.2.8` and
  `@pasarguard/xray-config-kit@0.3.6`.
- Preserved the new `/nodes/wireguard` navigation and removed the obsolete
  `/bulk/wireguard` navigation.
- Preserved the complete v5.2.1 Host/FinalMask implementation and changed only
  the visible VIPTrue remark example.
- Preserved the complete v5.2.1 Login/Owner setup/authentication logic and
  reapplied only VIPTrue logo/title presentation.
- Kept all upstream locale JSON files pristine. VIPTrue product strings now use
  `dashboard/src/brand/i18n-overrides.ts` at runtime, reducing future conflicts.
- Kept upstream translation key `nodes.addNewPasarGuardNode` and override only
  its displayed VIPTrue value.
- Retained VIPTrue winged logo, Control Center/Reseller titles, support link,
  owner-only update controls, reseller privacy guards, eight-palette theme
  system, Live Preview, and release/install/rollback tooling.
- Removed the temporary compatibility workflow from the final branch.

## Upstream v5.2.1 functionality retained

The final PR diff against official v5.2.1 contains no `app/`, database migration,
backend, core or generated upstream API modifications. The upstream v5.2.x
Xray, WireGuard, Reality Scan, FinalMask/Salamander, database/API, and dashboard
feature set therefore remains intact. The PR diff is limited to the VIPTrue
Dashboard/branding/CI/docs/deploy/tooling layer.

## Verification completed on 2026-08-17

Compatibility run `#5` (`32024680584`) passed:

- deterministic VIPTrue port/merge
- v5.2.1 dependency installation
- VIPTrue branding and Owner/Reseller invariant verification
- focused ESLint: zero errors; two existing Fast Refresh warnings only
- full production Vite build: `5607` modules, about `5.34s`
- main JavaScript: `127156` bytes raw / `35754` bytes gzip
- main CSS: `241641` bytes raw / `32845` bytes gzip
- Theme route: `18771` bytes raw / `4376` bytes gzip
- official VIPTrue logo: `353196` bytes
- total dashboard build: `22307722` bytes across `325` static files
- total-build budget calibrated from `22_250_000` to `22_500_000` bytes for the
  legitimate upstream feature growth; all per-bundle budgets remain unchanged.

PR verification:

- PR `#5` was conflict-free and GitHub reported `mergeable: true`.
- Final diff against official v5.2.1 was audited: no backend/API/migration/core
  files differ from upstream.
- `VIPTrue Dashboard CI` run `#18` (`32024873982`) passed all packaging gates.
- Final head CI run `#19` (`32024951064`) also completed successfully before
  merge.
- PR `#5` merged into `viptrue/v5.2.1` at
  `98e2054f6e40fcc5a0c5bb32f1c2e85625210cb3`.

Release verification:

- Tag `v5.2.1-custom.1` points to merge commit
  `98e2054f6e40fcc5a0c5bb32f1c2e85625210cb3`.
- One-shot publisher tag run `32026065472` passed.
- Release publisher run `32026114231` passed dependency install, VIPTrue
  invariants, lint, production build, performance budgets, packaging and
  GitHub release publication.
- Release `v5.2.1-custom.1` is published with archive and SHA256 assets.
- Release archive size: `6615560` bytes.
- Release archive SHA256:
  `e8e4bf96c5570396382f9559e3630d21512616f4f4c939533c3eb0507c23e6bc`.

Known upstream baseline: Monaco/Ace editor worker chunks above Vite's generic
500 kB warning remain route-specific upstream editor assets; VIPTrue does not
make them eager or introduce a new editor dependency.

## Remaining work

- On production, create a fresh PasarGuard database/application backup plus
  `.env`, Docker Compose, Nginx and current VIPTrue dashboard-link backup.
- Detect the currently installed database type, Docker image/tag, compose
  services and current dashboard symlink before changing anything.
- Stage `v5.2.1-custom.1` without switching the active dashboard.
- Upgrade the PasarGuard backend using the official update path only after the
  backup and preflight checks succeed.
- Atomically switch the VIPTrue dashboard to `v5.2.1-custom.1`, validate Nginx,
  and run production Owner/User/Node/API/subscription smoke checks.
- Roll back backend/database and dashboard symlink if any production smoke test
  fails.

## Next Exact Step

Run the production preflight/backup/staging command. Do not switch the active
Dashboard and do not run the PasarGuard backend update until the preflight
output confirms the current database/image/compose state and that the new
`v5.2.1-custom.1` archive has been downloaded and SHA256 verified.
