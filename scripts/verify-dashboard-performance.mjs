import { gzipSync } from 'node:zlib'
import { readFile, readdir, stat } from 'node:fs/promises'
import { resolve } from 'node:path'
import process from 'node:process'

const repoRoot = resolve(import.meta.dirname, '..')
const buildRoot = resolve(repoRoot, 'dashboard/build')
const failures = []

const budgets = {
  totalBuild: 22_250_000,
  mainJavaScript: 140_000,
  mainCss: 260_000,
  themeRoute: 25_000,
  brandLogo: 400_000,
  indexHtml: 5_000,
  staticFiles: 340,
}

const files = []

const collectFiles = async directory => {
  for (const entry of await readdir(directory, { withFileTypes: true })) {
    const absolutePath = resolve(directory, entry.name)
    if (entry.isDirectory()) {
      await collectFiles(absolutePath)
      continue
    }

    const fileStat = await stat(absolutePath)
    files.push({
      absolutePath,
      relativePath: absolutePath.slice(buildRoot.length + 1),
      size: fileStat.size,
    })
  }
}

await collectFiles(buildRoot)

const requireSingleFile = (label, pattern) => {
  const matches = files.filter(file => pattern.test(file.relativePath))
  if (matches.length !== 1) {
    failures.push(`${label}: expected exactly one file, found ${matches.length}`)
    return undefined
  }
  return matches[0]
}

const checkBudget = (label, file, budget) => {
  if (!file) return
  if (file.size > budget) {
    failures.push(`${label}: ${file.size} bytes exceeds ${budget}-byte budget`)
  }
}

const totalBuildSize = files.reduce((total, file) => total + file.size, 0)
const mainJavaScript = requireSingleFile('main JavaScript bundle', /^statics\/index-[\w-]+\.js$/)
const mainCss = requireSingleFile('main CSS bundle', /^statics\/index-[\w-]+\.css$/)
const themeRoute = requireSingleFile('theme settings route', /^statics\/_dashboard\.settings\.theme-[\w-]+\.js$/)
const brandLogo = requireSingleFile('VIPTrue brand logo', /^statics\/brand\/viptrue-logo\.png$/)
const indexHtml = requireSingleFile('dashboard index', /^index\.html$/)
const staticFileCount = files.filter(file => file.relativePath.startsWith('statics/')).length

if (totalBuildSize > budgets.totalBuild) {
  failures.push(`total dashboard build: ${totalBuildSize} bytes exceeds ${budgets.totalBuild}-byte budget`)
}
if (staticFileCount > budgets.staticFiles) {
  failures.push(`static file count: ${staticFileCount} exceeds ${budgets.staticFiles}-file budget`)
}

checkBudget('main JavaScript bundle', mainJavaScript, budgets.mainJavaScript)
checkBudget('main CSS bundle', mainCss, budgets.mainCss)
checkBudget('theme settings route', themeRoute, budgets.themeRoute)
checkBudget('VIPTrue brand logo', brandLogo, budgets.brandLogo)
checkBudget('dashboard index', indexHtml, budgets.indexHtml)

const formatMeasurement = async (label, file) => {
  if (!file) return undefined
  const compressedSize = gzipSync(await readFile(file.absolutePath), {
    level: 9,
  }).byteLength
  return `${label}: ${file.size} bytes raw, ${compressedSize} bytes gzip`
}

const measurements = (await Promise.all([formatMeasurement('Main JavaScript', mainJavaScript), formatMeasurement('Main CSS', mainCss), formatMeasurement('Theme route', themeRoute)])).filter(Boolean)

console.log(`Dashboard build: ${totalBuildSize} bytes across ${staticFileCount} static files`)
for (const measurement of measurements) console.log(measurement)
if (brandLogo) console.log(`Brand logo: ${brandLogo.size} bytes`)

if (failures.length > 0) {
  console.error('Dashboard performance verification failed:')
  for (const failure of failures) console.error(`- ${failure}`)
  process.exit(1)
}

console.log('Dashboard performance budgets passed.')
