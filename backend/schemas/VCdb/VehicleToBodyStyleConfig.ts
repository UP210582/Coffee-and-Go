import { list } from '@keystone-6/core';
import { integer, relationship, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const VehicleToBodyStyleConfig = list({
  access: allowAll,
  fields: {
    VehicleToBodyStyleConfigID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    VehicleID: relationship({ ref: 'Vehicle'}),
    BodyStyleConfigID: relationship({ ref: 'BodyStyleConfig' }),
    Source: text(),
  },
});
