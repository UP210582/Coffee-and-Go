import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const FuelType = list({
  access: allowAll,
  fields: {
    FuelTypeID: integer({validation: { isRequired: true }, isIndexed: 'unique' }),
    FuelTypeName: text({ validation: { isRequired: true }}),
  },
});
