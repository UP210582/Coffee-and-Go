import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const MfrBodyCode = list({
  access: allowAll,
  fields: {
    MfrBodyCodeID: integer({  validation: { isRequired: true }, isIndexed: 'unique' }),
    MfrBodyCodeName: text({ validation: { isRequired: true }}),
  },
});
