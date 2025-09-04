import { list } from '@keystone-6/core';
import { integer, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const EquipmentBase = list({
  access: allowAll,
  fields: {
    EquipmentBaseID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    MfrID: relationship({ ref: 'Mfr', many: false }),
    EquipmentModelID: relationship({ ref: 'EquipmentModel', many: false }),
    VehicleTypeId: relationship({ ref: 'VehicleType', many: false }),
  },
  ui: {
    listView: {
      initialColumns: ['EquipmentBaseID', 'MfrID', 'EquipmentModelID', 'VehicleTypeId'],
    },
  },
});
