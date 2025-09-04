import { list } from '@keystone-6/core';
import { integer, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const BaseVehicle = list({
  access: allowAll,
  fields: {
    BaseVehicleID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    YearID: relationship({ ref: 'Year', ui: { displayMode: 'select' } }),
    MakeID: relationship({ ref: 'Make', ui: { displayMode: 'select' } }),
    ModelID: relationship({ ref: 'Model', ui: { displayMode: 'select' } }),
  },
});
