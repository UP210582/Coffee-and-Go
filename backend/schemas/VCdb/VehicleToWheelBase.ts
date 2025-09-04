import { list } from '@keystone-6/core';
import { integer, relationship, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const VehicleToWheelbase = list({
  access: allowAll,
  fields: {
    VehicleToWheelbaseID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    VehicleID: relationship({ ref: 'Vehicle'}),
    WheelbaseID: relationship({ ref: 'WheelBase' }),
    Source: text(),
  },
});
