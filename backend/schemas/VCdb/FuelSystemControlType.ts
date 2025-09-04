import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const FuelSystemControlType = list({
  access: allowAll,
  fields: {
    FuelSystemControlTypeID: integer({validation: { isRequired: true }, isIndexed: 'unique' }),
    FuelSystemControlTypeName: text({ validation: { isRequired: true }}),
  },
});
