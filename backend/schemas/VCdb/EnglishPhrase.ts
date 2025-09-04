import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const EnglishPhrase = list({
  access: allowAll,
  fields: {
    EnglishPhraseID: integer({validation: { isRequired: true }, isIndexed: 'unique' }),
    EnglishPhrase: text({ validation: { isRequired: true }}),
    englishTranslations: relationship({ ref: 'LanguageTranslation.EnglishPhraseID', many: true }),
  },
});