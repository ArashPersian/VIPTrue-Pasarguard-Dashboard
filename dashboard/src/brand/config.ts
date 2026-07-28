export const VIPTRUE_BRAND = {
  name: 'VIPTrue',
  ownerTitle: 'VIPTrue Control Center',
  resellerTitle: 'VIPTrue Reseller Panel',
  loginTitle: 'VIPTrue Secure Access',
  logoUrl: '/statics/brand/viptrue-logo.png',
  markUrl: '/statics/brand/viptrue-mark.svg',
} as const

export const getDashboardTitle = (owner: boolean) => (owner ? VIPTRUE_BRAND.ownerTitle : VIPTRUE_BRAND.resellerTitle)
