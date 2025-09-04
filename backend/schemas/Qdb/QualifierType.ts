import { list } from '@keystone-6/core';
import { integer, text,relationship
 } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const QualifierType = list({
  access: allowAll,
  fields: {
    QualifierTypeID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    QualifierType: text(),
    qualifiers: relationship({ ref: 'QQualifier.QualifierTypeID', many: true }),
  },
});
