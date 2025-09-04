import { list } from '@keystone-6/core';
import { integer } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const Year = list({
  access: allowAll,
  fields: {
    YearID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
  },
});
