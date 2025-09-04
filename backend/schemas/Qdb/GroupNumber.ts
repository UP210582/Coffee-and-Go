import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const GroupNumber = list({
  access: allowAll,
  fields: {
    GroupNumberID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    GroupDescription: text({ validation: { isRequired: true } }),
    qualifierGroups: relationship({ ref: 'QualifierGroup.GroupNumberID', many: true }),
  },
});
