import { list } from '@keystone-6/core';
import { integer, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const FuelDeliveryConfig = list({
  access: allowAll,
  fields: {
    FuelDeliveryConfigID: integer({validation: { isRequired: true }, isIndexed: 'unique' }),
    FuelDeliveryTypeID: relationship({ ref: 'FuelDeliveryType', many: false }),
    FuelDeliverySubTypeID: relationship({ ref: 'FuelDeliverySubType', many: false }),
    FuelSystemControlTypeID: relationship({ ref: 'FuelSystemControlType', many: false }),
    FuelSystemDesignID: relationship({ ref: 'FuelSystemDesign', many: false }),
  },
});
