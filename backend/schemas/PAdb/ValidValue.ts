import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const ValidValue = list({
  access: allowAll,
  fields: {
    validValueID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    validValue: text({ validation: { isRequired: true }, isIndexed: 'unique' }),
  },
});
