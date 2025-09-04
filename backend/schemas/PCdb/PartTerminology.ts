import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const PCdbPartTerminology = list({
  access: allowAll,
  fields: {
    partTerminologyID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    description: text({ validation: { isRequired: true } }),
    aaiaid: text({ isIndexed: true }),
    partsRelationships: relationship({ ref: 'PartsRelationship.PartTerminology', many: true }),
    partsToAlias: relationship({ ref: 'PartsToAlias.PartTerminology', many: true }),  
    partsToUse: relationship({ ref: 'PartsToUse.PartTerminology', many: true }),
  },
});
