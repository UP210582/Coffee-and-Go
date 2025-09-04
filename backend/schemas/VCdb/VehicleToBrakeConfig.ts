import { list } from '@keystone-6/core';
import { integer, relationship, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const VehicleToBrakeConfig = list({
  access: allowAll,
  fields: {
    VehicleToBrakeConfigID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    VehicleID: relationship({ ref: 'Vehicle'}),
    BrakeConfigID: relationship({ ref: 'BrakeConfig' }),
    Source: text(),
  },
});
