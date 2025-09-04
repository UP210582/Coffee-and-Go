import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const PowerOutput = list({
  access: allowAll,
  fields: {
    PowerOutputID: integer({validation: { isRequired: true }, isIndexed: 'unique' }),
    HorsePower: text({ validation: { isRequired: true }}),
    KilowattPower: text({ validation: { isRequired: true }}),
  },
});
