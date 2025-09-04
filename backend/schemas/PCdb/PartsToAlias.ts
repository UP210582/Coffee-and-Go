import { list } from '@keystone-6/core';
import { relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const PartsToAlias = list({
  access: allowAll,
  fields: {
    PartTerminology: relationship({ ref: 'PCdbPartTerminology.partsToAlias' }),  
    alias: relationship({ ref: 'Alias.partsToAlias' }),  
  },
});