import { parseHsl } from '@/lib/theme-color'

export function getVIPTrueThemeSurface(themeVars: Record<string, string>, mode: 'light' | 'dark'): Record<string, string> {
  const primary = parseHsl(themeVars['--primary'] ?? '')
  const hue = primary?.h ?? 342
  const neonHue = (hue + 208) % 360

  if (mode === 'dark') {
    return {
      '--viptrue-neon': `${neonHue} 92% 62%`,
      '--viptrue-bg-start': `${hue} 32% 12%`,
      '--viptrue-bg-end': `${hue} 34% 5%`,
    }
  }

  return {
    '--viptrue-neon': `${neonHue} 88% 48%`,
    '--viptrue-bg-start': `${hue} 56% 99%`,
    '--viptrue-bg-end': `${hue} 42% 89%`,
  }
}
