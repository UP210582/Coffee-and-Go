import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const SteeringType = list({
  access: allowAll,
  fields: {
    SteeringTypeID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    SteeringTypeName: text({ validation: { isRequired: true }}),
    steeringConfigs: relationship({ ref: 'SteeringConfig.SteeringType', many: true }),
  },
});
