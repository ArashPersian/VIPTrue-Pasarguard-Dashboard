import { VIPTRUE_BRAND } from '@/brand/config'
import { cn } from '@/lib/utils'

interface BrandLogoProps {
  className?: string
  compact?: boolean
}

export function BrandLogo({ className, compact = false }: BrandLogoProps) {
  return (
    <span className={cn('viptrue-brand-logo', compact && 'viptrue-brand-logo--compact', className)} aria-label={`${VIPTRUE_BRAND.name} logo`}>
      <span className="viptrue-brand-logo__glow" aria-hidden="true" />
      <img src={compact ? VIPTRUE_BRAND.markUrl : VIPTRUE_BRAND.logoUrl} alt={`${VIPTRUE_BRAND.name} Logo`} draggable={false} />
    </span>
  )
}
