# TimescaleDB logical-backup portability fix

An upgraded TimescaleDB cluster can retain
`_timescaledb_catalog.chunk_constraint` as a table while a fresh installation
of the same extension version exposes it as a view. A plain-SQL backup can then
pass archive integrity checks but fail during restore when it attempts to copy
rows into that view.

For a database with no TimescaleDB hypertables or chunks, this overlay excludes
extension-owned internal schemas from `pg_dump`; `CREATE EXTENSION timescaledb`
recreates them on the destination. Application schemas and data remain in the
dump. If any hypertables exist, the overlay preserves the upstream full-catalog
behavior rather than silently discarding TimescaleDB metadata.

The installer downloads the exact upstream `PasarGuard/scripts` commit
`1fce1b19aaa54449ec0abdc4098b49027a170705`, validates every file checksum,
applies the small patch and installs a self-contained checkout in the configured
managed directory. Because the libraries are next to the CLI, automatic library
refresh does not overwrite the overlay. The system CLI remains unchanged.

Validation completed before Production installation:

- upstream unit suite: 191 passed, 0 failed;
- filtered custom-format restore into a fresh same-image cluster: PASS;
- filtered plain-SQL restore matching the existing PasarGuard path: PASS;
- schema/table inventory restored;
- application migration revision restored;
- per-table row-count fingerprint matched the source;
- zero-hypertable and zero-chunk preconditions verified on both source and
  isolated destination.

Install from a trusted checkout:

```bash
sudo bash ops/pasarguard-backup-fix/install-managed-bundle.sh
```

After installation, point scheduled backups at the managed bundle. Keep an
independently verified physical checkpoint until a backup created by the bundle
has itself passed a fresh isolated restore test.
