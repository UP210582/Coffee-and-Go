import { list } from '@keystone-6/core';
import { integer, relationship, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const VehicleToBedConfig = list({
  access: allowAll,
  fields: {
    VehicleToBedConfigID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    VehicleID: relationship({ ref: 'Vehicle'}),
    BedConfigID: relationship({ ref: 'BedConfig' }),
    Source: text(),
  },
});
