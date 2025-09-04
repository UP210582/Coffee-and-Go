import { list } from '@keystone-6/core';
import { integer } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const ValidValueAssignment = list({
  access: allowAll,
  fields: {
    validValueAssignmentID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    paptID: integer({ validation: { isRequired: true } }),
    validValueID: integer({ validation: { isRequired: true } }),
  },
});
