import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const Model = list({
  access: allowAll,
  fields: {
    ModelID: integer({  validation: { isRequired: true }, isIndexed: 'unique' }),
    ModelName: text({ validation: { isRequired: false }}),
    VehicleTypeID: relationship({ ref: 'VehicleType'}),
  },
});
