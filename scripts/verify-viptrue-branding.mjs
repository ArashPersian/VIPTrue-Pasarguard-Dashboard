import { readFile, readdir, stat } from 'node:fs/promises'
import { resolve } from 'node:path'
import process from 'node:process'

const repoRoot = resolve(import.meta.dirname, '..')
const dashboardRoot = resolve(repoRoot, 'dashboard')

const read = relativePath => readFile(resolve(repoRoot, relativePath), 'utf8')
const failures = []

const requireText = (label, source, text) => {
  if (!source.includes(text)) failures.push(`${label}: missing ${JSON.stringify(text)}`)
}

const forbidText = (label, source, text) => {
  if (source.includes(text)) failures.push(`${label}: contains forbidden ${JSON.stringify(text)}`)
}

const layout = await read('dashboard/src/pages/_dashboard.tsx')
forbidText('dashboard layout', layout, 'DonationPopup')
forbidText('dashboard layout', layout, 'TopbarAd')
requireText('dashboard layout', layout, '<VersionUpdateBanner />')

const sidebar = await read('dashboard/src/components/layout/sidebar.tsx')
requireText('sidebar owner gate', sidebar, 'const ownerAdmin = isOwner(admin)')
requireText('sidebar update query gate', sidebar, 'useVersionCheck(normalizedVersion, { enabled: ownerAdmin })')
requireText('mobile update badge gate', sidebar, 'showUpdateBadge={ownerAdmin && hasUpdate}')
requireText('version badge explicit gate', sidebar, 'enabled={ownerAdmin}')
requireText('full sidebar title', sidebar, '[text-wrap:balance] whitespace-normal')
forbidText('reseller-visible sidebar', sidebar, 'DONATION_URL')
forbidText('reseller-visible sidebar', sidebar, 'DOCUMENTATION')
forbidText('reseller-visible sidebar', sidebar, 'DISCUSSION_GROUP')
forbidText('reseller-visible sidebar', sidebar, 'GithubStar')
forbidText('reseller-visible sidebar', sidebar, 'GoalProgress')

const themeProvider = await read('dashboard/src/app/providers/theme-provider.tsx')
requireText('theme runtime marker', themeProvider, 'root.dataset.colorTheme = colorThemeName')
requireText('theme sidebar primary', themeProvider, "'--sidebar-primary': themeVars['--sidebar-primary'] ?? themeVars['--primary']")
requireText('VIPTrue default theme', themeProvider, "'--primary': '342 100% 57%'")

const themeSettings = await read('dashboard/src/pages/_dashboard.settings.theme.tsx')
requireText('VIPTrue default theme swatch', themeSettings, "{ name: 'default', label: 'theme.default', dot: '#ff3d8d' }")

const brandStyles = await read('dashboard/src/brand.css')
forbidText('theme-switchable brand variables', brandStyles, '--primary: 342 100% 57% !important')
requireText('adaptive themed background', brandStyles, 'hsl(var(--primary) / 0.16)')

const banner = await read('dashboard/src/components/layout/version-update-banner.tsx')
requireText('owner update banner', banner, 'const isOwnerAdmin = isOwner(admin)')
requireText('owner update request gate', banner, 'useSystemVersion({ enabled: isOwnerAdmin })')
requireText('owner release request gate', banner, 'useVersionCheck(normalizedVersion, { enabled: isOwnerAdmin })')
requireText('owner banner render gate', banner, 'if (!isOwnerAdmin ||')

const versionBadge = await read('dashboard/src/components/layout/version-badge.tsx')
requireText('version badge API', versionBadge, 'enabled: boolean')
requireText('version badge request gate', versionBadge, 'useVersionCheck(currentVersion, { enabled })')
requireText('version badge render gate', versionBadge, 'if (!enabled ||')

const mobileTrigger = await read('dashboard/src/components/layout/sidebar-trigger-with-badge.tsx')
requireText('mobile badge safe default', mobileTrigger, 'showUpdateBadge = false')
requireText('mobile system version gate', mobileTrigger, 'useSystemVersion({ enabled: showUpdateBadge })')
requireText('mobile release request gate', mobileTrigger, 'useVersionCheck(normalizedVersion, { enabled: showUpdateBadge })')

const publicSurfaces = [
  'dashboard/index.html',
  'dashboard/src/pages/login.tsx',
  'dashboard/src/components/layout/sidebar.tsx',
  'dashboard/src/components/layout/footer.tsx',
  'dashboard/src/features/nodes/components/nodes-list.tsx',
  'dashboard/src/features/hosts/dialogs/host-modal.tsx',
]

for (const relativePath of publicSurfaces) {
  const source = await read(relativePath)
  forbidText(relativePath, source, 'PasarGuard')
  forbidText(relativePath, source, 'پاسارگارد')
}

const localeDir = resolve(dashboardRoot, 'public/statics/locales')
for (const fileName of await readdir(localeDir)) {
  if (!fileName.endsWith('.json')) continue
  const relativePath = `dashboard/public/statics/locales/${fileName}`
  const source = await read(relativePath)
  JSON.parse(source)
  requireText(relativePath, source, 'VIPTrue')
  forbidText(relativePath, source, 'PasarGuard')
  forbidText(relativePath, source, 'پاسارگارد')
}

for (const relativePath of [
  'dashboard/public/statics/brand/viptrue-logo.png',
  'dashboard/public/statics/brand/viptrue-mark.svg',
  'dashboard/public/statics/brand/site.webmanifest',
]) {
  const fileStat = await stat(resolve(repoRoot, relativePath))
  if (!fileStat.isFile() || fileStat.size === 0) failures.push(`${relativePath}: missing or empty`)
}

const manifest = JSON.parse(await read('dashboard/public/statics/brand/site.webmanifest'))
if (manifest.name !== 'VIPTrue Control Center' || manifest.short_name !== 'VIPTrue') {
  failures.push('VIPTrue web manifest has unexpected product names')
}

if (failures.length > 0) {
  console.error('VIPTrue branding verification failed:')
  for (const failure of failures) console.error(`- ${failure}`)
  process.exit(1)
}

console.log('VIPTrue branding verification passed.')
console.log('Owner-only update notice guards passed.')
