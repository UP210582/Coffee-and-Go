import { list } from '@keystone-6/core';
import { integer } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const PartAttributeAssignment = list({
  access: allowAll,
  fields: {
    paptID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    partTerminologyID: integer({ validation: { isRequired: true } }),
    paid: integer({ validation: { isRequired: true } }),
    metaID: integer({ validation: { isRequired: true } }),
  },
});
