import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const SpringType = list({
  access: allowAll,
  fields: {
    SpringTypeID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    SpringTypeName: text({ validation: { isRequired: true }}),
    frontConfigs: relationship({ ref: 'SpringTypeConfig.FrontSpringTypeID' }),
    rearConfigs: relationship({ ref: 'SpringTypeConfig.RearSpringTypeID' }),
  },
});
