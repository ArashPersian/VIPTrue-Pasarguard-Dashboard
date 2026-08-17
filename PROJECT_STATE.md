# PROJECT_STATE

- Project: VIPTrue PasarGuard Dashboard
- Production compatibility: PasarGuard `v5.1.0`
- Production compatibility branch: `viptrue/v5.1.0`
- Production custom release: `v5.1.0-custom.3`
- Upgrade target: PasarGuard `v5.2.1`
- Upgrade audit branch: `upstream/v5.2.1`
- Official upstream baseline branch: `upstream-base/v5.2.1`
- Upgrade audit PR: `#4` (draft; intentionally not mergeable yet)
- Official upstream tag commit: `e81877c0df64e5f5235f4355b0490b6bb38e3adc`
- Current VIPTrue branch head before upgrade: `dfa3392e2e18935491859b612dd5c001196667c9`
- Previous merge and release commit: `86f52b8671975a564017c23888b1076ef7945dd6`
- Theme implementation commit: `8937415fa2ff017a501e02258d067f6992b7adbc`
- Reseller hardening commit: `7cd02ae004ae83839dd480ce0fbd91b59ddb64b5`

## Current production state

- Last recorded production dashboard is `v5.1.0-custom.2` at `https://panel.vip504.com/dashboard/`.
- `v5.1.0-custom.3` was successfully built and released but its production installation was not recorded as completed in the previous project state.
- Nginx was active and Dashboard plus brand endpoints returned HTTP `200` in the last production audit.
- Backend/API/database/subscription behavior were unchanged by the VIPTrue dashboard-only patch.
- Owner session was manually authenticated for the previous browser audit.
- All 27 major Owner routes loaded their expected page heading without an application alert or visible PasarGuard branding.
- Reseller session was manually authenticated for the previous browser audit.
- Reseller navigation exposed only Dashboard, Users, API Keys and Settings.
- Direct navigation to Owner-only routes was redirected to the Reseller Dashboard.
- No version/update notice or visible PasarGuard branding appeared for Reseller.

## Preserved VIPTrue customization baseline

- Official winged VIPTrue logo for sidebar, favicon, Apple touch icon and manifest.
- VIPTrue title/branding and support surfaces.
- Owner-only upstream version/update notices.
- Reseller privacy guards: no upstream branding, donation, advertisement, GitHub/community/update surfaces.
- Route and navigation restrictions aligned with RBAC for Reseller.
- Palette-specific Light/Dark themes for Default, Red, Rose, Orange, Green, Blue, Yellow and Violet.
- Live Preview using the real themed background, compact brand, sidebar, cards, chart colors, input and primary action.
- Hidden Cores editor preference for roles without Cores read permission.
- Release packaging, install/rollback scripts, performance budgets and branding verification.

## v5.2.1 upstream compatibility audit — 2026-08-17

- Official latest stable upstream release verified as PasarGuard `v5.2.1`.
- Upstream `v5.1.0 -> v5.2.1` contains 72 commits and substantial backend/dashboard changes.
- The VIPTrue `v5.1.0` compatibility branch contains 13 commits on top of the common `v5.1.0` base.
- Draft PR `#4` compares the VIPTrue custom branch against the exact official `v5.2.1` commit.
- GitHub reports the compatibility PR as `mergeable: false`; therefore direct update/merge is explicitly unsafe.
- Primary overlapping VIPTrue/upstream dashboard surfaces identified so far:
  - `dashboard/package.json`
  - `dashboard/public/statics/locales/en.json`
  - `dashboard/public/statics/locales/fa.json`
  - `dashboard/public/statics/locales/ru.json`
  - `dashboard/public/statics/locales/zh.json`
  - `dashboard/src/components/layout/sidebar.tsx`
  - `dashboard/src/features/hosts/dialogs/host-modal.tsx`
  - `dashboard/src/pages/login.tsx`
- Most VIPTrue brand/theme/release tooling files do not overlap upstream `v5.2.1` and can be ported without replacing new upstream functionality.
- Important upstream areas that must be retained during the upgrade include Xray duplicate inbound changes, FinalMask/Hysteria changes, Reality Scan work, WireGuard pool changes, dashboard fixes, generated API changes and database migrations.
- Production must NOT run `pasarguard update` until the v5.2.1 custom compatibility build passes CI and role smoke tests.

## Verification completed for previous custom release

- `git diff --check`
- VIPTrue branding, owner-gate, theme-surface and obsolete-logo verification
- Focused ESLint: zero errors; two pre-existing Fast Refresh warnings
- Clean production Vite build
- Release-equivalent build with `VITE_BASE_API=/`
- Performance budgets passed
- GitHub `VIPTrue Dashboard CI` passed before `v5.1.0-custom.3`
- Release tag `v5.1.0-custom.3` and release archive were independently hash-verified

## Remaining upgrade work

- Build a clean `v5.2.1` compatibility tree from official upstream `v5.2.1`, not from the stale fork `main` branch.
- Port all non-overlapping VIPTrue customization unchanged.
- Manually merge the eight overlapping dashboard surfaces while preserving both upstream 5.2.1 behavior and VIPTrue privacy/branding/RBAC invariants.
- Update `.viptrue/upstream-version` to `v5.2.1` only after the compatibility tree is complete.
- Run VIPTrue branding verification, focused lint, production dashboard build and performance budget gate.
- Run upstream/API/database migration tests applicable to v5.2.1.
- Verify generated API compatibility and RBAC/route guards.
- Test Owner and Reseller roles on a non-production instance.
- Only after all gates pass, prepare `v5.2.1-custom.1` for explicit Release approval.
- Before production backend update, back up database, `/opt/pasarguard/.env`, `/var/lib/pasarguard`, Nginx configuration and active VIPTrue dashboard symlink.

## Next exact step

Create the clean v5.2.1 compatibility implementation from official upstream commit `e81877c0df64e5f5235f4355b0490b6bb38e3adc`, port the non-overlapping VIPTrue files, then manually resolve `package.json`, the four locale files, `sidebar.tsx`, `host-modal.tsx` and `login.tsx`. Run CI/build gates before changing any production component or publishing a release.
