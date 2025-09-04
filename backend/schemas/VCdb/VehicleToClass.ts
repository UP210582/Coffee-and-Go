import { list } from '@keystone-6/core';
import { integer, relationship, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const VehicleToClass = list({
  access: allowAll,
  fields: {
    VehicleToClassID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    VehicleID: relationship({ ref: 'Vehicle'}),
    ClassID: relationship({ ref: 'Class' }),
    Source: text(),
  },
});
