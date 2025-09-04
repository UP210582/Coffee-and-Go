import { list } from '@keystone-6/core';
import { integer, relationship, timestamp } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const VCChange = list({
  access: allowAll,
  fields: {
    ChangeID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    RequestID: integer({ validation: { isRequired: true } }),
    ChangeReasonID: relationship({ ref: 'VCChangeReason.vcChanges', ui: { displayMode: 'select' } }),
    RevDate: timestamp(),
    changeDetails: relationship({ ref: 'VCChangeDetail.ChangeID', many: true }),
  },
});
