# PROJECT_STATE

Last updated: 2026-09-19 Europe/Berlin
State version: `2026.09.19-v5.4.1-compatibility.2`
Status: **V5.4.1 CI AND ISOLATED PRODUCTION-CLONE MIGRATION PASS / RELEASE PENDING / PRODUCTION UNCHANGED**

## 1. Authoritative repository state

- Project: VIPTrue PasarGuard Dashboard
- Current Production branch: `viptrue/v5.2.1`
- Current Production branch head: `f20d0f0b8fce3b563b62d9df5e1990d3aac130bb`
- Current Production upstream base: PasarGuard `v5.2.1`
  (`e81877c0df64e5f5235f4355b0490b6bb38e3adc`)
- Compatibility candidate branch: `viptrue/v5.4.1`
- Compatibility candidate upstream base: PasarGuard `v5.4.1`
  (`b56ffe369f542152c52c69733205baeaf3f6e4cd`)
- Port method: three-way tree patch from official `v5.2.1` to the verified
  Production VIPTrue tree, applied onto official `v5.4.1`; five UI conflicts
  were resolved manually while retaining the new upstream architecture.
- Previous release: `v5.1.0-custom.3`
- Current Production release: `v5.2.1-custom.1`
- Planned candidate release after all gates: `v5.4.1-custom.1`
- Release archive SHA256: `e8e4bf96c5570396382f9559e3630d21512616f4f4c939533c3eb0507c23e6bc`

The default `main` branch is not the authoritative VIPTrue customized line.
Until the new release is published and live smoke gates pass,
`viptrue/v5.2.1` remains the Production source of truth.

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

## 3. VIPTrue v5.4.1 candidate customization retained

- VIPTrue winged logo and product naming.
- Control Center / Reseller presentation and support routing.
- Upstream v5.4.1 theme style/density/base/accent system, light/dark mode and a
  branded Live Preview. The VIPTrue default remains pink and all upstream
  selectable palettes remain available.
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

The audited candidate diff against official v5.4.1 contains no VIPTrue modification to
upstream backend, API, database migration, core or generated API files. The
upstream Xray, WireGuard, Reality Scan, FinalMask/Salamander and database/API
feature set remains intact.

## 4. Build, CI and release evidence

Local v5.4.1 candidate evidence recorded on 2026-09-19:

- exact upstream tag: `v5.4.1` / `b56ffe369f542152c52c69733205baeaf3f6e4cd`;
- dependency install: 577 packages from the upstream `bun.lock`;
- VIPTrue branding/owner/reseller invariant verifier: PASS;
- focused ESLint: zero errors and four upstream Fast Refresh warnings;
- full `tsc --noEmit`: zero errors for both pristine upstream and VIPTrue;
- Vite production build: 5582 modules, PASS;
- pristine upstream v5.4.1 baseline: 22220924 bytes / 313 static files;
- VIPTrue candidate including `404.html`: 22543594 bytes / 310 static files;
- main JavaScript: 118871 bytes raw / 34182 bytes gzip;
- main CSS: 205290 bytes raw / 30758 bytes gzip;
- Theme route: 15008 bytes raw / 4065 bytes gzip;
- official VIPTrue logo: 353196 bytes;
- calibrated total-build budget: 22600000 bytes, PASS.

Remote validation recorded on 2026-09-19:

- dashboard CI run `35443930085`: SUCCESS on candidate commit `8d91cd4b`;
- database workflow run `35444213946`: SUCCESS on corrective test commit
  `a1d986b7`; SQLite, PostgreSQL, TimescaleDB, MySQL and MariaDB all passed
  migrations, migration checks and their complete test suites;
- the only first-run failure was an upstream stale test mock that did not
  accept the new `force_start` keyword. The test-only repair now verifies
  normal create scheduling and forced modify scheduling; its focused local
  test also passed;
- the official backend image was pinned by digest and started against a
  physical clone of the live TimescaleDB cluster on an internal-only Docker
  network;
- the clone began at Alembic revision `fb32155473c1`, migrated to
  `48a6bcb8bba1`, exposed the backend socket and reported PasarGuard `5.4.1`;
- all staging containers, the isolated network, temporary volume and temporary
  files were removed after the successful check. Production remained at
  v5.2.1 and revision `fb32155473c1`.

The installed automatic backup archive passes ZIP integrity checks but its
plain-SQL TimescaleDB payload is not independently restorable into a fresh
2.27.1 cluster because it attempts to copy an upgraded internal catalog table
into the fresh-install view of the same name. It is therefore not accepted as
the database rollback source. A verified physical PostgreSQL recovery checkpoint
is required immediately before Production cutover; the automatic logical
backup/restore tooling must be repaired separately.

Existing v5.2.1 Production release evidence follows.

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

Fresh read-only Production checkpoint captured from UM1 on 2026-09-19:

- the backend is the expected official `v5.2.1` image;
- PostgreSQL/TimescaleDB is healthy and at the exact v5.2.1 migration head;
- all required panel, database, pooler and administration containers are up;
- the active dashboard is `v5.2.1-custom.1` and the previous versioned release
  remains available as a rollback anchor;
- Nginx, the panel listener and versioned dashboard include are active;
- the newest automatic archive passed a complete integrity test and contains
  the environment, Compose definition, SQL dump and required panel data;
- storage headroom is sufficient for a staged upgrade and retained rollback.

Exact server endpoints, host identity, image digest, database size, backup path
and checksum, certificate paths and SSH metadata are deliberately retained only
in the private UM1 inventory/operations context, not this public repository.

No backend image, database, Nginx configuration, dashboard symlink, container
or customer traffic was changed while collecting this checkpoint.

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

## 8. Remaining compatibility/operations work

- Build and publish `v5.4.1-custom.1` from the validated candidate.
- Immediately before the maintenance window, create and verify a physical
  PostgreSQL recovery checkpoint; record its SHA256 and retain the current
  backend image/digest and dashboard symlinks as rollback anchors.
- Repair and restore-test the installer-managed TimescaleDB logical backup
  format before treating those automatic archives as database recovery media.
- Re-run role-aware Owner/Reseller/User, Node/API, Host and subscription smoke
  checks before and after Production cutover.
- Keep old release tags immutable.
- Treat Draft PR `#4` as historical/experimental; PR `#5` and the
  `viptrue/v5.2.1` code line supersede it.

## 9. Next Exact Step

Publish `v5.4.1-custom.1`, verify its release archive and checksum, create the
physical pre-cutover database checkpoint, then perform the backend/dashboard
cutover with immediate post-deployment smoke tests. Keep v5.2.1 and the previous
dashboard symlink available until the new release has passed live validation.
