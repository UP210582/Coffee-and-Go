import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const Mfr = list({
  access: allowAll,
  fields: {
    MfrID: integer({  validation: { isRequired: true }, isIndexed: 'unique' }),
    MfrName: text({ validation: { isRequired: true }}),
    transmissions: relationship({ ref: 'Transmission.TransmissionMfr', many: true }),
  },
});
