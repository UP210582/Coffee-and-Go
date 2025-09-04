import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const TransmissionMfrCode = list({
  access: allowAll,
  fields: {
    TransmissionMfrCodeID: integer({ isIndexed: 'unique', validation: { isRequired: true } }),
    TransmissionMfrCode: text({ validation: { isRequired: true } }),
    transmissions: relationship({ ref: 'Transmission.TransmissionMfrCode', many: true }),
      },
});

