import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const QChangeAttributeState = list({
  access: allowAll,
  fields: {
    ChangeAttributeStateID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    ChangeAttributeState: text({ validation: { isRequired: true } }),
    changeDetails: relationship({ ref: 'QChangeDetail.ChangeAttributeStateID', many: true }),
  },
});
