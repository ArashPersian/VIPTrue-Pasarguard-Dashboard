# PROJECT_STATE

- Project: VIPTrue PasarGuard Dashboard
- Upstream compatibility: PasarGuard `v5.1.0`
- Compatibility branch: `viptrue/v5.1.0`
- Merged PR: `#2`
- Merge and release target commit: `17d698b7c91c7719c680fe9d9cc75bf19716dacf`
- Published release: `v5.1.0-custom.2`
- Production release pending upgrade: `v5.1.0-custom.1`
- Release archive SHA256: `1714e9f70afa74b6af07aa73a7d41c96c665457d923073ed2d66a92151d2e46b`
- Versioned installer SHA256: `7080bebd7b3faa3e7659704e73d43eeb6796a388a3d776a4961bb6b18bc3719d`

## Current production state

- `v5.1.0-custom.1` remains active at `https://panel.vip504.com/dashboard/`
- Dashboard and VIPTrue brand asset both return HTTP `200`
- Nginx is active and the Backend/API/database remain unchanged
- The installed `v5.1.0-custom.1` release directory permission was manually
  corrected to `0755`
- `v5.1.0-custom.2` is published and verified but not yet installed on the
  production server

## Included in v5.1.0-custom.2

- Installer changes the pending release root from `0700` to `0755` before
  atomic activation so Nginx can traverse every fresh release
- Full `VIPTrue Control Center` and `VIPTrue Reseller Panel` sidebar titles
  display without ellipsis clipping
- The current VIPTrue pink/rose palette remains the `Default` color theme
- Red, Rose, Orange, Green, Blue, Yellow and Violet selections apply to primary
  controls, sidebar tokens, charts, card shadows and page background
- Selected color remains persisted in the existing `color-theme` browser
  preference for each collaborator's browser
- VIPTrue verification guards the default swatch, runtime theme marker, sidebar
  theme tokens and unclipped title styling

## Verification completed

- `git diff --check`
- Focused Prettier check
- VIPTrue branding and owner-gate verification
- Focused ESLint with zero errors
- Production Vite build
- Built bundle checks for `color-theme`, `dataset.colorTheme`, the default pink
  token and the adaptive themed background
- Release archive layout and SHA256 verification
- GitHub `VIPTrue Dashboard CI` run `#8` passed on PR head `4a9a086`
- PR `#2` merged successfully into `viptrue/v5.1.0`
- One-shot release workflow run `30400568255` passed every step, including
  target-SHA verification, build, package, checksum, tag/release creation and
  release-branch cleanup
- Release tag `v5.1.0-custom.2` points to verified commit `17d698b`
- GitHub release asset digest confirms the dashboard archive SHA256 shown above

Known upstream baseline: the full `v5.1.0` TypeScript check has existing
generated API, core-kit and form typing failures. These are not caused by the
VIPTrue compatibility patches and are not used as a release gate.

## Remaining work

- Install `v5.1.0-custom.2` with the versioned installer
- Confirm the active `current` symlink and Nginx health
- Confirm Dashboard and brand asset return HTTP `200`
- Visually smoke-test Owner and Reseller titles plus at least two non-default
  colors in Light and Dark mode

## Next exact step

Download and SHA256-verify the installer from tag `v5.1.0-custom.2`, run it with
the verified release archive SHA256, then perform HTTP and visual smoke tests on
the production dashboard.
