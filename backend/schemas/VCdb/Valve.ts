import { list } from '@keystone-6/core';
import { integer } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const Valve = list({
  access: allowAll,
  fields: {
    ValvesID: integer({ isIndexed: 'unique', validation: { isRequired: true } }),
    Valves: integer({ validation: { isRequired: true } }),
  },
});
