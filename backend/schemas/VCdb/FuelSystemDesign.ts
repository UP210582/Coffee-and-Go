import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const FuelSystemDesign = list({
  access: allowAll,
  fields: {
    FuelSystemDesignID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    FuelSystemDesignName: text({ validation: { isRequired: true }}),
  },
});
