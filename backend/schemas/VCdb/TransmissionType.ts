import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const TransmissionType = list({
  access: allowAll,
  fields: {
    TransmissionTypeID: integer({ isIndexed: 'unique', validation: { isRequired: true } }),
    TransmissionTypeName: text({ validation: { isRequired: true } }),
    transmissionBases: relationship({ ref: 'TransmissionBase.TransmissionType', many: true }),
  },
});