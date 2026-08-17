#!/usr/bin/env bash
set -euo pipefail

git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
git fetch origin viptrue/v5.1.0
grep -q 'version = "5.2.1"' pyproject.toml || { echo 'Expected PasarGuard v5.2.1 base'; exit 1; }

git merge --no-ff --no-commit origin/viptrue/v5.1.0

# Reconstruct sensitive overlap files from explicit sources.
git show HEAD:dashboard/package.json > dashboard/package.json
for f in en fa ru zh; do
  git show HEAD:"dashboard/public/statics/locales/${f}.json" > "dashboard/public/statics/locales/${f}.json"
done
git show origin/viptrue/v5.1.0:dashboard/src/components/layout/sidebar.tsx > dashboard/src/components/layout/sidebar.tsx
git show HEAD:dashboard/src/features/hosts/dialogs/host-modal.tsx > dashboard/src/features/hosts/dialogs/host-modal.tsx
git show HEAD:dashboard/src/pages/login.tsx > dashboard/src/pages/login.tsx

python3 <<'PY'
import json
from pathlib import Path

# Keep v5.2.1 dependencies; add only VIPTrue QA scripts.
p = Path('dashboard/package.json')
data = json.loads(p.read_text())
assert data['version'] == '5.2.1'
scripts = data.setdefault('scripts', {})
scripts.update({
    'lint': 'eslint .',
    'lint:viptrue': 'eslint src/app/providers/theme-provider.tsx src/brand/config.ts src/brand/i18n-overrides.ts src/components/brand/brand-logo.tsx src/components/layout/footer.tsx src/components/layout/sidebar.tsx src/components/layout/sidebar-trigger-with-badge.tsx src/components/layout/version-badge.tsx src/components/layout/version-update-banner.tsx src/constants/Project.ts src/features/dashboard/components/workers-health-card.tsx src/pages/_dashboard.settings.theme.tsx src/utils/docs-url.ts',
    'verify:viptrue': 'node ../scripts/verify-viptrue-branding.mjs',
    'verify:performance': 'node ../scripts/verify-dashboard-performance.mjs',
})
p.write_text(json.dumps(data, indent=2, ensure_ascii=False) + '\n')

# Start with the known-good VIPTrue sidebar and port functional v5.2.1 nav changes.
p = Path('dashboard/src/components/layout/sidebar.tsx')
s = p.read_text()
core = """          {
            title: 'settings.cores.title',
            url: '/nodes/cores',
            icon: Cpu,
            matchPrefix: true,
          },
"""
wireguard = """          {
            title: 'nodes.wireguard.title',
            url: '/nodes/wireguard',
            icon: Network,
          },
"""
if "url: '/nodes/wireguard'" not in s:
    if core not in s:
        raise SystemExit('Cores sidebar anchor changed')
    s = s.replace(core, core + wireguard, 1)
bulk = """                      {
                        title: 'bulk.wireguardPeerIps',
                        url: '/bulk/wireguard',
                        icon: Network,
                      },
"""
s = s.replace(bulk, '', 1)
if "url: '/bulk/wireguard'" in s:
    raise SystemExit('Legacy bulk WireGuard remains')
p.write_text(s)

# Keep v5.2.1 FinalMask host editor intact and brand only the visible example.
p = Path('dashboard/src/features/hosts/dialogs/host-modal.tsx')
s = p.read_text()
if 'Remark (e.g. PasarGuard-Host)' in s:
    s = s.replace('Remark (e.g. PasarGuard-Host)', 'Remark (e.g. VIPTrue-Host)', 1)
elif 'Remark (e.g. VIPTrue-Host)' not in s:
    raise SystemExit('Host remark anchor changed')
p.write_text(s)

# Keep v5.2.1 authentication and owner setup logic intact; port presentation only.
p = Path('dashboard/src/pages/login.tsx')
s = p.read_text()
s = s.replace("import { useTheme } from '@/app/providers/theme-provider'\n", '')
anchor = "import { ThemeToggle } from '@/components/common/theme-toggle'\n"
if "@/brand/config" not in s:
    if anchor not in s:
        raise SystemExit('Login import anchor changed')
    s = s.replace(anchor, anchor + "import { VIPTRUE_BRAND } from '@/brand/config'\nimport { BrandLogo } from '@/components/brand/brand-logo'\n", 1)
s = s.replace("  const { resolvedTheme } = useTheme()\n", '')
old = """              <img src={resolvedTheme === 'dark' ? '/statics/favicon/logo.png' : '/statics/favicon/logo-dark.png'} alt=\"PasarGuard Logo\" className=\"h-20 w-20 object-contain\" />
              <span className=\"text-2xl font-semibold\">{view === 'login' ? t('login.loginYourAccount') : t('setup.ownerAccess', { defaultValue: 'Owner access' })}</span>
"""
new = """              <BrandLogo />
              <span className=\"mt-2 bg-gradient-to-r from-pink-500 via-rose-500 to-pink-600 bg-clip-text text-2xl font-black tracking-tight text-transparent\">{VIPTRUE_BRAND.loginTitle}</span>
              <span className=\"text-xl font-semibold\">{view === 'login' ? t('login.loginYourAccount') : t('setup.ownerAccess', { defaultValue: 'Owner access' })}</span>
"""
if old not in s:
    raise SystemExit('Login visual anchor changed')
p.write_text(s.replace(old, new, 1))
PY

cat > dashboard/src/brand/i18n-overrides.ts <<'EOF'
export const VIPTRUE_I18N_OVERRIDES = {
  en: {
    pasarguard: 'VIPTrue',
    dashboardDescription: 'VIPTrue Management Dashboard',
    supportUs: 'VIPTrue Support',
    'nodes.addNewPasarGuardNode': 'Create New VIPTrue Node',
    'nodes.title': 'Using VIPTrue-Node, you are able to scale up your connection quality by creating different nodes on different servers.',
    'donation.title': 'Support VIPTrue',
    'donation.message': 'Your support helps us improve VIPTrue and build better features for everyone!',
  },
  fa: {
    pasarguard: 'VIPTrue',
    dashboardDescription: 'داشبورد مدیریت VIPTrue',
    supportUs: 'پشتیبانی VIPTrue',
    'nodes.addNewPasarGuardNode': 'افزودن گره VIPTrue',
    'donation.title': 'حمایت از VIPTrue',
    'donation.message': 'حمایت شما به ما کمک می‌کند تا VIPTrue را بهبود بخشیم و ویژگی‌های بهتری برای همه بسازیم!',
  },
  ru: {
    pasarguard: 'VIPTrue',
    dashboardDescription: 'Панель управления VIPTrue',
    supportUs: 'Поддержка VIPTrue',
    'nodes.addNewPasarGuardNode': 'Добавить новый узел VIPTrue',
    'donation.title': 'Поддержать VIPTrue',
    'donation.message': 'Ваша поддержка помогает нам улучшать VIPTrue и создавать новые возможности.',
  },
  zh: {
    pasarguard: 'VIPTrue',
    dashboardDescription: 'VIPTrue 管理仪表板',
    supportUs: 'VIPTrue 支持',
    'nodes.addNewPasarGuardNode': '添加新的 VIPTrue 节点',
    'donation.title': '支持 VIPTrue',
    'donation.message': '您的支持将帮助我们改进 VIPTrue，并为所有人打造更好的功能！',
  },
} as const
EOF

python3 <<'PY'
from pathlib import Path

p = Path('dashboard/src/locales/i18n.ts')
s = p.read_text()
anchor = "import { joinURL } from 'ufo'\n"
if 'VIPTRUE_I18N_OVERRIDES' not in s:
    if anchor not in s:
        raise SystemExit('i18n import anchor changed')
    s = s.replace(anchor, anchor + "import { VIPTRUE_I18N_OVERRIDES } from '@/brand/i18n-overrides'\n", 1)
init = "\ni18n\n  .use(LanguageDetector)"
helper = """

const applyVIPTrueTranslations = (language?: string) => {
  const normalized = (language || i18n.resolvedLanguage || i18n.language || 'en').split('-')[0] as keyof typeof VIPTRUE_I18N_OVERRIDES
  const overrides = VIPTRUE_I18N_OVERRIDES[normalized] || VIPTRUE_I18N_OVERRIDES.en
  for (const [key, value] of Object.entries(overrides)) {
    i18n.addResource(normalized, 'translation', key, value)
  }
}

i18n.on('loaded', () => applyVIPTrueTranslations())
i18n.on('languageChanged', language => applyVIPTrueTranslations(language))
"""
if 'const applyVIPTrueTranslations' not in s:
    if init not in s:
        raise SystemExit('i18n init anchor changed')
    s = s.replace(init, helper + init, 1)
callback = "      const lang = i18n.language\n"
if '      applyVIPTrueTranslations(i18n.language)\n' not in s:
    if callback not in s:
        raise SystemExit('i18n callback anchor changed')
    s = s.replace(callback, '      applyVIPTrueTranslations(i18n.language)\n' + callback, 1)
p.write_text(s)

# Adapt branding verifier for pristine upstream locale files + runtime overlay.
v = Path('scripts/verify-viptrue-branding.mjs')
t = v.read_text()
start = "const localeDir = resolve(dashboardRoot, 'public/statics/locales')\n"
end = "\nfor (const relativePath of ['dashboard/public/statics/brand/viptrue-logo.png', 'dashboard/public/statics/brand/site.webmanifest']) {"
a = t.find(start)
b = t.find(end)
if a < 0 or b < 0 or b <= a:
    raise SystemExit('Verifier locale block changed')
replacement = """const localeDir = resolve(dashboardRoot, 'public/statics/locales')
for (const fileName of await readdir(localeDir)) {
  if (!fileName.endsWith('.json')) continue
  JSON.parse(await read(`dashboard/public/statics/locales/${fileName}`))
}
const brandI18n = await read('dashboard/src/brand/i18n-overrides.ts')
requireText('brand translation overlay', brandI18n, "'nodes.addNewPasarGuardNode': 'Create New VIPTrue Node'")
requireText('brand translation overlay', brandI18n, "dashboardDescription: 'VIPTrue Management Dashboard'")
const i18nRuntime = await read('dashboard/src/locales/i18n.ts')
requireText('runtime brand translation loader', i18nRuntime, 'i18n.addResource(normalized')
requireText('v5.2.1 WireGuard node route', sidebar, "url: '/nodes/wireguard'")
forbidText('removed legacy WireGuard bulk route', sidebar, "url: '/bulk/wireguard'")
"""
v.write_text(t[:a] + replacement + t[b:])
PY

printf 'v5.2.1\n' > .viptrue/upstream-version
git add -A
test -z "$(git diff --name-only --diff-filter=U)"
git diff --cached --check
git commit -m "chore: port VIPTrue customizations onto PasarGuard v5.2.1"
