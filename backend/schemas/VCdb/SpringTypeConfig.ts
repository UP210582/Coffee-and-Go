import { list } from '@keystone-6/core';
import { integer, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const SpringTypeConfig = list({
  access: allowAll,
  fields: {
    SpringTypeConfigID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    FrontSpringTypeID: relationship({ ref: 'SpringType.frontConfigs', many: false }),
    RearSpringTypeID: relationship({ ref: 'SpringType.rearConfigs', many: false }),
  },
});
