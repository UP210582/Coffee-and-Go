import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const QLanguage = list({
  access: allowAll,
  fields: {
    LanguageID: integer(),
    LanguageName: text(),
    DialectName: text(),
    qualifierTranslations: relationship({ ref: 'QualifierTranslation.LanguageID', many: true }),
  },
});
