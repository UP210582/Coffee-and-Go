import { list } from '@keystone-6/core';
import { integer, relationship, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const VehicleToSteeringConfig = list({
  access: allowAll,
  fields: {
    VehicleToSteeringConfigID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    VehicleID: relationship({ ref: 'Vehicle'}),
    SteeringConfigID: relationship({ ref: 'SteeringConfig' }),
    Source: text(),
  },
});
