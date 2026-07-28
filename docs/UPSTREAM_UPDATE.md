# Safe upstream update workflow

VIPTrue Dashboard is intentionally pinned to the stable version stored in
`.viptrue/upstream-version`. Production must not combine an untested upstream
backend with an older custom dashboard.

## When a new panel update appears

1. Do not run `pasarguard update` on production yet.
2. Record the new stable tag shown to the owner.
3. Create `upstream/<new-tag>` from the current VIPTrue release.
4. Fetch the official tag and merge or rebase it into that branch.
5. Resolve conflicts only after comparing API, routing, authentication, RBAC,
   generated client code, and dashboard build changes.
6. Update `.viptrue/upstream-version`.
7. Run the full VIPTrue CI:
   - branding verification;
   - owner-only update notice guards;
   - focused ESLint on the clean VIPTrue component set;
   - invariant scanning for modified upstream surfaces that already contain
     baseline lint failures;
   - production build;
   - release packaging.
8. Test two real roles against a non-production instance:
   - owner: update banner, current version, release link and update command are
     visible;
   - reseller: no update badge, release link, upstream branding, donation,
     advertisement, GitHub star or official community link is visible.
9. Publish a matching tag such as `v5.2.0-custom.1`.
10. Back up the production panel, database, `.env`, Nginx configuration and the
    active VIPTrue dashboard symlink.
11. Stage the matching dashboard release without switching production.
12. Update the panel backend during a maintenance window.
13. Atomically switch `/var/lib/viptrue/dashboard/current` to the matching
    dashboard release, validate Nginx and reload it.
14. Run owner login, reseller login, user creation, subscription, node and API
    smoke tests.

If any compatibility or smoke test fails, restore the backend backup and point
the dashboard symlink back to `previous`.

## Automation boundary

`check-upstream-release.yml` checks the latest stable upstream release each day
and opens one GitHub issue when compatibility work is needed. It does not
update production automatically. Human review remains required because an
upstream release can change API contracts, RBAC or dashboard routing.

The full upstream `v5.1.0` TypeScript check is not used as a release gate
because the official tag contains pre-existing generated API and form typing
errors. The production Vite build and focused lint remain mandatory. A future
upstream tag can restore full typecheck gating once its baseline is clean.
