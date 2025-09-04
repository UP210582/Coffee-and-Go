import { list } from '@keystone-6/core';
import { integer, text, timestamp, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const QQualifier = list({
  access: allowAll,
  fields: {
    QualifierID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    QualifierText: text(),
    ExampleText: text(),
    QualifierTypeID: relationship({ ref: 'QualifierType.qualifiers', many: false }),
    NewQualifierID: integer(),
    WhenModified: timestamp({ validation: { isRequired: true } }),
    qualifierGroups: relationship({ ref: 'QualifierGroup.QualifierID', many: true }),
    qualifierTranslations: relationship({ ref: 'QualifierTranslation.QualifierID', many: true }),
  },
});
