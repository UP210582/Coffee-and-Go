import { list } from '@keystone-6/core';
import { integer, relationship, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const VehicleToMfrBodyCode = list({
  access: allowAll,
  fields: {
    VehicleToMfrBodyCodeID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    VehicleID: relationship({ ref: 'Vehicle'}),
    MfrBodyCodeID: relationship({ ref: 'MfrBodyCode' }),
    Source: text(),
  },
});
