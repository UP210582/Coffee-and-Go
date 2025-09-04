import { list } from '@keystone-6/core';
import { relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const PartsRelationship = list({
  access: allowAll,
  fields: {
    PartTerminology: relationship({ ref: 'PCdbPartTerminology.partsRelationships', many: false }),
  },
});