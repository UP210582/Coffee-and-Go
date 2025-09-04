import { list } from '@keystone-6/core';
import { integer, relationship, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const VehicleToSpringTypeConfig = list({
  access: allowAll,
  fields: {
    VehicleToSpringTypeConfigID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    VehicleID: relationship({ ref: 'Vehicle'}),
    SpringTypeConfigID: relationship({ ref: 'SpringTypeConfig' }),
    Source: text(),
  },
});
