import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const VCChangeReason = list({
  access: allowAll,
  fields: {
    ChangeReasonID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    ChangeReason: text({ validation: { isRequired: true, length: { max: 255 } } }),
    vcChanges: relationship({ ref: 'VCChange.ChangeReasonID', many: true }),
  },
});
