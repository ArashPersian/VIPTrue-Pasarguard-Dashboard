# PROJECT_STATE

- Project: VIPTrue PasarGuard Dashboard
- Upstream compatibility target: PasarGuard `v5.2.1`
- Official upstream commit: `e81877c0df64e5f5235f4355b0490b6bb38e3adc`
- Compatibility branch: `viptrue/v5.2.1`
- Working branch: `agent/v5.2.1-compat`
- Tested compatibility merge commit: `d581ce186969460ff7a64fcc5568208b8715acf0`
- Draft compatibility PR: `#5`
- PR base: official `viptrue/v5.2.1` tree at `e81877c0df64e5f5235f4355b0490b6bb38e3adc`
- Previous release: `v5.1.0-custom.3`
- Planned release: `v5.2.1-custom.1` (not tagged or released yet)
- Production deployment: unchanged; no v5.2.1 deployment has been performed

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
- Updated static verification for the translation overlay and v5.2.1 WireGuard
  route invariants.
- Kept `scripts/port-viptrue-v5.2.1.sh` as the deterministic upgrade audit.
- Removed the temporary one-shot compatibility GitHub Actions workflow after the
  successful port.

## Upstream v5.2.1 functionality retained

The final PR diff against official v5.2.1 contains no `app/`, database migration,
backend, core or generated upstream API modifications. The upstream v5.2.x
Xray, WireGuard, Reality Scan, FinalMask/Salamander, database/API, and dashboard
feature set therefore remains intact. The 37-file PR diff is limited to the
VIPTrue Dashboard/branding/CI/docs/deploy/tooling layer.

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
  legitimate upstream feature growth; all per-bundle budgets remain unchanged
  and passed.

Draft PR `#5` verification:

- PR is conflict-free and GitHub reports `mergeable: true`.
- Final diff against official v5.2.1 was audited: no backend/API/migration/core
  files differ from upstream.
- `VIPTrue Dashboard CI` run `#18` (`32024873982`) passed every step:
  dependency install, branding/owner gates, focused lint, production build,
  performance budgets, build entrypoint checks, test packaging and artifact
  upload.

Known upstream baseline: Monaco/Ace editor worker chunks above Vite's generic
500 kB warning remain route-specific upstream editor assets; VIPTrue does not
make them eager or introduce a new editor dependency.

## Remaining work

- Perform Owner and Reseller browser/runtime smoke tests against a staged or
  non-production v5.2.1 panel, including Login/Owner setup, Dashboard, Users,
  Nodes/WireGuard, Hosts/FinalMask, Theme/Live Preview and reseller route/privacy
  restrictions.
- If runtime smoke tests pass, mark PR `#5` ready and merge it into
  `viptrue/v5.2.1`.
- Prepare `v5.2.1-custom.1` only after explicit Release approval.
- Before production deployment, back up panel/database/.env/Nginx/dashboard and
  use the staged install/rollback workflow.

## Next Exact Step

Run Owner and Reseller runtime smoke tests for PR `#5` on a non-production or
staged PasarGuard v5.2.1 instance. If all tests pass, request explicit approval
to merge PR `#5` and then separately request approval before tagging/releasing
`v5.2.1-custom.1` or deploying it to production.
