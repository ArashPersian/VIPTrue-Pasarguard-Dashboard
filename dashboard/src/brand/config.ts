export const VIPTRUE_BRAND = {
  name: 'VIPTrue',
  ownerTitle: 'VIPTrue Control Center',
  resellerTitle: 'VIPTrue Reseller Panel',
  loginTitle: 'VIPTrue Secure Access',
  logoUrl: '/statics/brand/viptrue-logo.png?v=3',
  markUrl: '/statics/brand/viptrue-logo.png?v=3',
} as const

export const getDashboardTitle = (owner: boolean) => (owner ? VIPTRUE_BRAND.ownerTitle : VIPTRUE_BRAND.resellerTitle)
