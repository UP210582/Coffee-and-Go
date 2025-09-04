import { list } from '@keystone-6/core';
import { integer, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const QualifierGroup = list({
  access: allowAll,
  fields: {
    QualifierGroupID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    GroupNumberID: relationship({ ref: 'GroupNumber.qualifierGroups', many: false }),
    QualifierID: relationship({ ref: 'QQualifier.qualifierGroups', many: false }),
  },
});