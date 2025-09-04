import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const BodyNumDoors = list({
  access: allowAll,
  graphql: {
    plural: 'BodyNumDoorsList', 
  },
  fields: {
    BodyNumDoorsID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    NumDoors: text({ validation: { isRequired: true, length: { max: 3 } } }),
    bodyStyleConfigs: relationship({ ref: 'BodyStyleConfig.BodyNumDoorsID', many: true })
  },
});
