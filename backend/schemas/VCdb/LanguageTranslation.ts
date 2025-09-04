import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const LanguageTranslation = list({
  access: allowAll,
  fields: {
    LanguageTranslationID: integer({  validation: { isRequired: true }, isIndexed: 'unique' }),
    EnglishPhraseID: relationship({ ref: 'EnglishPhrase.englishTranslations', many: false }),
    LanguageID: relationship({ ref: 'VCLanguage.languageTranslations', many: false }),
    Translation: text({ validation: { isRequired: true }}),
    attachments: relationship({ ref: 'LanguageTranslationAttachment.LanguageTranslationID', many: true }), 
  },
});