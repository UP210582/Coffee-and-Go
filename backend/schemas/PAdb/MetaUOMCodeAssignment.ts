import { list } from '@keystone-6/core';
import { integer } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const MetaUOMCodeAssignment = list({
  access: allowAll,
  fields: {
    metaUOMCodeAssignmentID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    paptID: integer({ validation: { isRequired: true } }),
    metaUOMID: integer({ validation: { isRequired: true } }),
  },
});
