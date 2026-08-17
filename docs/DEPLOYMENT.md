# Versioned dashboard deployment

The custom dashboard is stored outside the panel container:

```text
/var/lib/viptrue/dashboard/
├── current -> releases/<active-version>
├── previous -> releases/<previous-version>
└── releases/
    └── v5.1.0-custom.1/
        ├── dashboard/index.html
        └── statics/
```

The backend and API remain owned by the official panel. Nginx serves only the
versioned dashboard files and proxies API traffic as before.

## First installation

1. Include `deploy/nginx-viptrue-dashboard.conf` inside the existing
   `panel.vip504.com` HTTPS server block.
2. Validate with `sudo nginx -t`.
3. Install a verified release:

```bash
sudo ./scripts/install-dashboard-release.sh \
  v5.1.0-custom.1 \
  <sha256-from-the-release>
```

The installer never overwrites an existing release directory. It verifies the
exact SHA256, rejects unsafe archive paths, moves the new version into place,
updates the symlink atomically, validates Nginx and keeps the previous symlink.

## Rollback

```bash
sudo ./scripts/rollback-dashboard.sh
```

The rollback changes only the dashboard symlink and reloads Nginx after a
successful configuration test. It does not roll back a database or backend
upgrade; those must be restored from the matching panel backup.
