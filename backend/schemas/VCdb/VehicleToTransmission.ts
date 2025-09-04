import { list } from '@keystone-6/core';
import { integer, relationship, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const VehicleToTransmission = list({
  access: allowAll,
  fields: {
    VehicleToTransmissionID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    VehicleID: relationship({ ref: 'Vehicle'}),
    TransmissionID: relationship({ ref: 'Transmission' }),
    Source: text(),
  },
});
