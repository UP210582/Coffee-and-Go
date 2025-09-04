import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const BodyType = list({
  access: allowAll,
  fields: {
    BodyTypeID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    BodyTypeName: text({ validation: { isRequired: true, length: { max: 30 } } }),
    bodyStyleConfigs: relationship({ ref: 'BodyStyleConfig.BodyTypeID', many: true }) 
  },
});
