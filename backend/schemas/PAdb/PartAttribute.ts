import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const PartAttribute = list({
  access: allowAll,
  fields: {
    paid: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    paName: text(),
    paDescr: text(),
  },
});
