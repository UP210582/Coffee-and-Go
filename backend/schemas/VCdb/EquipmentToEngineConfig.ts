import { list } from '@keystone-6/core';
import { integer, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const EquipmentToEngineConfig = list({
  access: allowAll,
  fields: {
    EquipmentToEngineConfigID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    EquipmentID: relationship({ ref: 'Equipment', many: false }),
    EngineConfigID: relationship({ ref: 'EngineConfig2', many: false }),
  },
});
