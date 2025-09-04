import { list } from '@keystone-6/core';
import { integer, relationship, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const VehicleToEngineConfig = list({
  access: allowAll,
  fields: {
    VehicleToEngineConfigID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    VehicleID: relationship({ ref: 'Vehicle'}),
    EngineConfigID: relationship({ ref: 'EngineConfig2' }),
    Source: text(),
  },
});
