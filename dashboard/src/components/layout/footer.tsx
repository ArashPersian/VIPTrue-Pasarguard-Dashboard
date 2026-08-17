import { VIPTRUE_BRAND } from '@/brand/config'
import { FC } from 'react'

const FooterContent = () => {
  return (
    <p className="text-muted-foreground/70 inline-block flex-grow text-center text-xs">{VIPTRUE_BRAND.name} Secure Network</p>
  )
}

export const Footer: FC = ({ ...props }) => {
  return (
    <div className="relative flex w-full pt-1 pb-3" {...props}>
      <FooterContent />
    </div>
  )
}
