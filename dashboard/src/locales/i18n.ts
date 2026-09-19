import i18n from 'i18next'
import LanguageDetector from 'i18next-browser-languagedetector'
import HttpApi from 'i18next-http-backend'
import { initReactI18next } from 'react-i18next'
import { joinURL } from 'ufo'
import { VIPTRUE_I18N_OVERRIDES } from '@/brand/i18n-overrides'


const applyVIPTrueTranslations = (language?: string) => {
  const normalized = (language || i18n.resolvedLanguage || i18n.language || 'en').split('-')[0] as keyof typeof VIPTRUE_I18N_OVERRIDES
  const overrides = VIPTRUE_I18N_OVERRIDES[normalized] || VIPTRUE_I18N_OVERRIDES.en
  for (const [key, value] of Object.entries(overrides)) {
    i18n.addResource(normalized, 'translation', key, value)
  }
}

i18n.on('loaded', () => applyVIPTrueTranslations())
i18n.on('languageChanged', language => applyVIPTrueTranslations(language))

i18n
  .use(LanguageDetector)
  .use(initReactI18next)
  .use(HttpApi)
  .init(
    {
      debug: import.meta.env.NODE_ENV === 'development',
      returnNull: false,
      fallbackLng: 'en',
      interpolation: {
        escapeValue: false,
      },
      react: {
        useSuspense: true,
      },
      load: 'languageOnly',
      detection: {
        caches: ['localStorage'],
      },
      backend: {
        loadPath: joinURL(import.meta.env.BASE_URL, `statics/locales/{{lng}}.json`),
      },
    },
    function (err) {
      if (err) {
        console.error('i18next initialization error:', err)
      }
      applyVIPTrueTranslations(i18n.language)
      const lang = i18n.language
      document.documentElement.lang = lang
      document.documentElement.setAttribute('dir', i18n.dir())
    },
  )

export default i18n
