import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const VehicleType = list({
  access: allowAll,
  fields: {
    VehicleTypeID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    VehicleTypeName: text({ validation: { isRequired: true, length: { max: 30 } } }),
    VehicleTypeGroupID: relationship({ ref: 'VehicleTypeGroup' }),
  },
});
