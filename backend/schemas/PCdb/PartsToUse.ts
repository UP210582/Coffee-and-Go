import { list } from '@keystone-6/core';
import { relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const PartsToUse = list({
  access: allowAll,
  fields: {
    PartTerminology: relationship({ ref: 'PCdbPartTerminology.partsToUse' }),
    Use: relationship({ ref: 'Use.partsToUse' }),
  },
});