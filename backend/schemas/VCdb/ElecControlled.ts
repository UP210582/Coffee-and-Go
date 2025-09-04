import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const ElecControlled = list({
  access: allowAll,
  fields: {
    ElecControlledID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    ElecControlledName: text({ validation: { isRequired: true }, isIndexed: true }),
    
    transmissions: relationship({ ref: 'Transmission.TransmissionElecControlled', many: true }),
  },
});
