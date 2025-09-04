import { list } from '@keystone-6/core';
import { integer, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const BodyStyleConfig = list({
  access: allowAll,
  fields: {
    BodyStyleConfigID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    BodyNumDoorsID: relationship({ ref: 'BodyNumDoors.bodyStyleConfigs', ui: { displayMode: 'select' } }),
    BodyTypeID: relationship({ ref: 'BodyType.bodyStyleConfigs', ui: { displayMode: 'select' } }),
  },
});
