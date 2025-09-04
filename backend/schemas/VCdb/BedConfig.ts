import { list } from '@keystone-6/core';
import { integer, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const BedConfig = list({
  access: allowAll,
  fields: {
    BedConfigID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    BedLengthID: relationship({ ref: 'BedLength.bedConfigs', ui: { displayMode: 'select' } }),
    BedTypeID: relationship({ ref: 'BedType.bedConfigs', ui: { displayMode: 'select' } }), // <- apuntamos al campo de relación
  },
});
