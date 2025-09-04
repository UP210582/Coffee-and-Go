import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const IgnitionSystemType = list({
  access: allowAll,
  fields: {
    IgnitionSystemTypeID: integer({  validation: { isRequired: true }, isIndexed: 'unique' }),
    IgnitionSystemTypeName: text({ validation: { isRequired: true }}),
  },
});
