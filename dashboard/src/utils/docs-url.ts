import { SUPPORT_URL } from '@/constants/Project'

/**
 * Returns the VIPTrue support destination used by contextual help buttons.
 *
 * The route argument is retained for upstream API compatibility. Keeping this
 * adapter stable avoids touching every PageHeader when rebasing the dashboard.
 */
export function getDocsUrl(pagePath: string): string {
  void pagePath
  return SUPPORT_URL
}
