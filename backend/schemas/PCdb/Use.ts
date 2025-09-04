import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const Use = list({
  access: allowAll,
  fields: {
    UseID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    UseDescription: text({ validation: { isRequired: true, length: { max: 255 } } }),
    partsToUse: relationship({ ref: 'PartsToUse.Use', many: true }),
  },
});
