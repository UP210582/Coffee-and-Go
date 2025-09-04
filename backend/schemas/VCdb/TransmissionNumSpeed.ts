import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const TransmissionNumSpeed = list({
  access: allowAll,
  fields: {
    TransmissionNumSpeedsID: integer({ isIndexed: 'unique', validation: { isRequired: true } }),
    TransmissionNumSpeeds: text({ validation: { isRequired: true }, isIndexed: true }),
    transmissionBases: relationship({ ref: 'TransmissionBase.TransmissionNumSpeeds', many: true }),
  },
});