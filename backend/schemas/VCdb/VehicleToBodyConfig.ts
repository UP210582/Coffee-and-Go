import { list } from '@keystone-6/core';
import { integer, relationship, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const VehicleToBodyConfig = list({
  access: allowAll,
  fields: {
    VehicleToBodyConfigID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    VehicleID: relationship({ ref: 'Vehicle'}),
    WheelBaseID: relationship({ ref: 'WheelBase' }),
    BedConfigID: relationship({ ref: 'BedConfig' }),
    BodyStyleConfigID: relationship({ ref: 'BodyStyleConfig' }),
    MfrBodyCodeID: relationship({ ref: 'MfrBodyCode' }),
    Source: text(),
  },
});
