import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const VCLanguage = list({
  access: allowAll,
  fields: {
    LanguageID: integer({  validation: { isRequired: true }, isIndexed: 'unique', isOrderable: true }),
    LanguageName: text({ validation: { isRequired: true }}),
    DialectName: text({ validation: { isRequired: false }}),
    languageTranslations: relationship({ ref: 'LanguageTranslation.LanguageID', many: true }),
  },
});