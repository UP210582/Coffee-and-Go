import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const ChangeAttributeState = list({
  access: allowAll,
  fields: {
    ChangeAttributeStateID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    ChangeAttributeState: text({ validation: { isRequired: true, length: { max: 255 } } }),
    changeDetails: relationship({ ref: 'VCChangeDetail.ChangeAttributeStateID', many: true }),
  },
});
