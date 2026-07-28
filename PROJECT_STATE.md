# PROJECT_STATE

- Project: VIPTrue PasarGuard Dashboard
- Upstream compatibility: PasarGuard `v5.1.0`
- Working branch: `agent/viptrue-branding-v5.1.0`
- Target first release: `v5.1.0-custom.1`
- Production deployment: not started

## Implemented in the current branch

- VIPTrue rose/neon visual layer aligned with the subscription page
- VIPTrue login, sidebar, browser title, footer, favicon and PWA identity
- Owner title: `VIPTrue Control Center`
- Reseller title: `VIPTrue Reseller Panel`
- PasarGuard names removed from all four dashboard locale files
- Official donation popup, top-bar advertisements, GitHub star, donation and
  community navigation removed from the rendered dashboard
- Contextual help redirected to VIPTrue support
- Panel update banner and sidebar version status restricted to
  `admin.role.is_owner === true`
- Automated branding/owner-gate verification
- CI build, release packaging and stable-upstream watch workflows
- Versioned install and rollback scripts

## Verification completed

- Dependency install completed with the upstream lockfile's
  `@pasarguard/core-kit@0.2.5`
- VIPTrue branding and owner-gate verification passed
- Focused ESLint plus invariant scanning passed
- Production dashboard build passed
- Package layout and SHA256 verification passed
- Built asset, favicon, manifest and HTML smoke checks passed

## Required before production activation

- Owner and reseller visual/runtime smoke test on a non-production instance
- Release archive and SHA256 verification from GitHub
- Nginx configuration validation and a recoverable first-install switch

Known upstream baseline: the full `v5.1.0` TypeScript check has existing
generated API, core-kit and form typing failures. These are not caused by the
VIPTrue branch and are not used as a release gate for this compatibility tag.

## Next exact step

Commit the verified source, push the exact commit to GitHub and open a Draft
PR for `v5.1.0-custom.1`. Do not publish a release or change production until
the PR is reviewed.
