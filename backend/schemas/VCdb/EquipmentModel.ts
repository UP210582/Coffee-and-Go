import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const EquipmentModel = list({
  access: allowAll,
  fields: {
    EquipmentModelID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    EquipmentModelName: text({ validation: { isRequired: true }}),
  },
});
