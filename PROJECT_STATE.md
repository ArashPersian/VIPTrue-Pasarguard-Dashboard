# PROJECT_STATE

Last updated: 2026-09-18 Europe/Berlin
State version: `2026.09.18-documentation-recovery.1`
Status: **CUSTOM RELEASE PUBLISHED / PRODUCTION DEPLOYMENT RECORDED / DOCUMENTATION RECOVERED**

## 1. Authoritative repository state

- Project: VIPTrue PasarGuard Dashboard
- Authoritative VIPTrue branch: `viptrue/v5.2.1`
- Official upstream release: PasarGuard `v5.2.1`
- Official upstream base: `e81877c0df64e5f5235f4355b0490b6bb38e3adc`
- Compatibility working branch: `agent/v5.2.1-compat`
- Merged compatibility PR: `#5`
- VIPTrue code merge: `98e2054f6e40fcc5a0c5bb32f1c2e85625210cb3`
- Pre-repair documentation head: `827798d99fdf4e8a82a8abd0e6376ec35541efae`
- Previous release: `v5.1.0-custom.3`
- Current release: `v5.2.1-custom.1`
- Release archive SHA256: `e8e4bf96c5570396382f9559e3630d21512616f4f4c939533c3eb0507c23e6bc`

The default `main` branch is not the authoritative VIPTrue customized line.
Future work must start from `viptrue/v5.2.1` and verify its current remote HEAD.

## 2. Compatibility policy

- PasarGuard upstream remains the source of truth for backend, API, database
  migrations, protocol support, generated API, authentication behavior and new
  dashboard functionality.
- VIPTrue remains a portable customization layer for branding, themes,
  owner-only update visibility, reseller privacy/RBAC presentation, and safe
  release/install/rollback tooling.
- Production must never run an upstream panel update before a matching tested
  VIPTrue compatibility release exists.
- Do not install a separate WireGuard stack for panel-managed WireGuard. Preserve
  the PasarGuard Core/Node architecture and use the official panel paths.
- Never infer Production state from `main`, an old PR body, or README alone.

## 3. VIPTrue v5.2.1 customization retained

- VIPTrue winged logo and product naming.
- Control Center / Reseller presentation and support routing.
- Eight-palette theme system, light/dark mode and Live Preview.
- Owner-only version/update controls and reseller privacy guards.
- Runtime brand/i18n overrides in
  `dashboard/src/brand/i18n-overrides.ts`, while upstream locale JSON remains
  unchanged.
- VIPTrue release packaging, checksum validation, Nginx deployment template,
  performance/branding checks, upstream watcher and rollback tooling.
- The upstream `/nodes/wireguard` route is retained.
- The obsolete `/bulk/wireguard` route is not reintroduced.
- Upstream Login/Owner setup and authentication logic is retained; VIPTrue
  changes only its visible presentation.

The audited diff against official v5.2.1 contains no VIPTrue modification to
upstream backend, API, database migration, core or generated API files. The
upstream Xray, WireGuard, Reality Scan, FinalMask/Salamander and database/API
feature set remains intact.

## 4. Build, CI and release evidence

Compatibility and PR validation completed on 2026-08-17:

- deterministic compatibility run: `32024680584` — SUCCESS
- VIPTrue Dashboard CI: `32024873982` — SUCCESS
- final pre-merge head CI: `32024951064` — SUCCESS
- one-shot publisher tag run: `32026065472` — SUCCESS
- release publisher run: `32026114231` — SUCCESS
- focused ESLint: zero errors; two existing Fast Refresh warnings only
- production Vite build: 5607 modules
- main JavaScript: 127156 bytes raw / 35754 bytes gzip
- main CSS: 241641 bytes raw / 32845 bytes gzip
- Theme route: 18771 bytes raw / 4376 bytes gzip
- official VIPTrue logo: 353196 bytes
- total dashboard build: 22307722 bytes across 325 static files
- total-build budget: 22500000 bytes

Release `v5.2.1-custom.1` is published with archive and checksum assets:

- archive: `viptrue-dashboard-v5.2.1-custom.1.tar.gz`
- archive size: 6615560 bytes
- SHA256:
  `e8e4bf96c5570396382f9559e3630d21512616f4f4c939533c3eb0507c23e6bc`

Known upstream baseline: Monaco/Ace editor worker chunks above Vite's generic
500 kB warning are route-specific upstream editor assets. VIPTrue does not make
them eager or introduce a new editor dependency.

## 5. Deployment and rollback model

The VIPTrue installer must:

1. download the exact versioned release asset;
2. validate the expected SHA256;
3. reject unsafe archive paths and an existing destination;
4. stage the release without changing the active dashboard;
5. preserve the previous dashboard symlink as a rollback anchor;
6. atomically switch `/var/lib/viptrue/dashboard/current`;
7. validate Nginx before reload;
8. restore the previous symlink if validation fails.

The upstream watcher may open an issue for a new stable upstream release. It
must not automatically update or deploy Production.

## 6. Production record and current live evidence

Commit `827798d99fdf4e8a82a8abd0e6376ec35541efae` is explicitly titled
`docs: record successful v5.2.1 production deployment`. That commit
accidentally truncated this file instead of preserving the intended deployment
details.

The recoverable, non-secret evidence is:

- the release was already published and checksum-verified;
- the later branch commit records the Production deployment as successful;
- on 2026-09-18, `https://panel.vip504.com/dashboard/` returned HTTP 200;
- its served dashboard HTML reported `Last-Modified: Mon, 17 Aug 2026
  11:41:34 GMT`, aligned with the published release window;
- TLS negotiation passed with TLS 1.3.

The exact historical deployment command, server-side backup path, previous
symlink target, backend image/tag and full Owner/User/Node/API/subscription
acceptance output were lost from the truncated document and are therefore not
invented here. Before any future panel upgrade or rollback, re-read the live
server state and create a fresh preflight/backup checkpoint.

## 7. Documentation incident and recovery

The pre-repair `PROJECT_STATE.md` ended after the incomplete text
`Previous production`. Git history shows that commit `827798d...` removed
109 lines and inserted that single fragment.

This file restores the last complete compatibility/release evidence from
`06b3fce1`, replaces obsolete “deployment pending” instructions with the
recoverable Production record above, and explicitly marks the evidence that
must be re-captured live instead of guessed.

Documentation recovery does not redeploy the dashboard, change PasarGuard,
restart Nginx, alter the database or modify customer traffic.

## 8. Remaining documentation/operations work

- At the next authorized panel maintenance window, record the current backend
  image/tag, database type, Compose services, active dashboard symlink, backup
  path and rollback target from the live host.
- Re-run role-aware Owner/Reseller/User, Node/API and subscription smoke checks
  before any new compatibility release.
- Keep old release tags immutable.
- Treat Draft PR `#4` as historical/experimental; PR `#5` and the
  `viptrue/v5.2.1` code line supersede it.

## 9. Next Exact Step

No Production action is required for this documentation repair.

For the next panel change, first verify the live runtime and current remote
`viptrue/v5.2.1` HEAD read-only, create fresh backups and rollback anchors,
then stage a tested VIPTrue compatibility release. Do not update the upstream
backend or switch the dashboard symlink before those gates pass.
