import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const Equipment = list({
  access: allowAll,
  graphql: {
    plural: 'Equipments',
  },
  fields: {
    EquipmentID: integer({validation: { isRequired: true }, isIndexed: 'unique' }),
    EquipmentBaseID: relationship({ ref: 'EquipmentBase', many: false }),
    RegionID: relationship({ ref: 'Region', many: false }),
    ProductionStart: text({ validation: { isRequired: false }}),
    ProductionEnd: text({ validation: { isRequired: false }}),
  },
  ui: {
    listView: {
      initialColumns: ['EquipmentID', 'EquipmentBaseID', 'RegionID'],
    },
  },
});
