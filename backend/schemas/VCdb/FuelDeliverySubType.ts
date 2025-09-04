import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const FuelDeliverySubType = list({
  access: allowAll,
  fields: {
    FuelDeliverySubTypeID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    FuelDeliverySubTypeName: text({ validation: { isRequired: true }}),
  },
});
