# PROJECT_STATE

- Project: VIPTrue PasarGuard Dashboard
- Upstream compatibility: PasarGuard `v5.1.0`
- Compatibility branch: `viptrue/v5.1.0`
- Working branch: `agent/fix-dashboard-release-permissions`
- Draft PR: `#2`
- Installed release: `v5.1.0-custom.1`
- Next patch release: `v5.1.0-custom.2` after PR review and merge
- Implementation commit: `73af166af8680a64e670dba4d6f5ab8500fd749e`

## Current production state

- `v5.1.0-custom.1` is active at `https://panel.vip504.com/dashboard/`
- Dashboard and VIPTrue brand asset both return HTTP `200`
- Nginx is active and the Backend/API/database remain unchanged
- The installed release directory permission was manually corrected to `0755`

## Implemented in Draft PR #2

- Installer now changes the pending release root from `0700` to `0755`
  before atomic activation so Nginx can traverse it
- Full `VIPTrue Control Center` and `VIPTrue Reseller Panel` sidebar titles
  display without ellipsis clipping
- The current VIPTrue pink/rose palette remains the `Default` color theme
- Red, Rose, Orange, Green, Blue, Yellow and Violet selections now apply to
  primary controls, sidebar tokens, charts, card shadows and page background
- Selected color remains persisted in the existing `color-theme` browser
  preference for each collaborator's browser
- VIPTrue verification now guards the default swatch, runtime theme marker,
  sidebar theme tokens and unclipped title styling

## Verification completed

- `git diff --check`
- Focused Prettier check
- VIPTrue branding and owner-gate verification
- Focused ESLint with zero errors
- Production Vite build
- Built bundle checks for `color-theme`, `dataset.colorTheme`, the default pink
  token and the adaptive themed background
- Release archive layout and independent SHA256 verification

Known upstream baseline: the full `v5.1.0` TypeScript check has existing
generated API, core-kit and form typing failures. These are not caused by the
VIPTrue compatibility patches and are not used as a release gate.

## Remaining work

- Wait for GitHub CI on the latest Draft PR #2 head
- Review the final PR diff and merge it into `viptrue/v5.1.0`
- Publish and independently verify `v5.1.0-custom.2`
- Install the patch release with the versioned installer
- Visually smoke-test Owner and Reseller titles plus at least two non-default
  colors in Light and Dark mode

## Next exact step

Confirm GitHub CI passes for Draft PR #2, then merge the PR and create the
`v5.1.0-custom.2` release from the exact merge commit.
