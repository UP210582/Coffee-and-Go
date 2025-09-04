import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const VehicleTypeGroup = list({
  access: allowAll,
  fields: {
    VehicleTypeGroupID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    VehicleTypeGroupName: text({ validation: { isRequired: true, length: { max: 30 } } }),
  },
});
