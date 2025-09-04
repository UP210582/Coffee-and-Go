import { list } from '@keystone-6/core';
import { integer, relationship, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const QualifierTranslation = list({
  access: allowAll,
  fields: {
    QualifierTranslationID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    QualifierID: relationship({ ref: 'QQualifier.qualifierTranslations', many: false }),  
    LanguageID: relationship({ ref: 'QLanguage.qualifierTranslations', many: false }),    
    TranslationText: text({ validation: { isRequired: true } }),
  },
});
