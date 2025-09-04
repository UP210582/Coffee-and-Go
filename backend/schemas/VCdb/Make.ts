import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const Make = list({
  access: allowAll,
  fields: {
    MakeID: integer({  validation: { isRequired: true }, isIndexed: 'unique' }),
    MakeName: text({ validation: { isRequired: true }}),
  },
});
