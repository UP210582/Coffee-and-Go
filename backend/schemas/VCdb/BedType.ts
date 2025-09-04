import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const BedType = list({
  access: allowAll,
  fields: {
    BedTypeID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    BedTypeName: text({ validation: { isRequired: true, length: { max: 30 } } }),
    bedConfigs: relationship({ ref: 'BedConfig.BedTypeID', many: true }) // relación inversa
  },
});
