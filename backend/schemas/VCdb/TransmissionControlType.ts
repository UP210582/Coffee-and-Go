import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const TransmissionControlType = list({
  access: allowAll,
  fields: {
    TransmissionControlTypeID: integer({ isIndexed: 'unique', validation: { isRequired: true } }),
    TransmissionControlTypeName: text({ validation: { isRequired: true } }),
    transmissionBases: relationship({ ref: 'TransmissionBase.TransmissionControlType', many: true }),
  },
});