import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const SteeringSystem = list({
  access: allowAll,
  fields: {
    SteeringSystemID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    SteeringSystemName: text({ validation: { isRequired: true }}),
    steeringConfigs: relationship({ ref: 'SteeringConfig.SteeringSystem', many: true }),
  },
});
