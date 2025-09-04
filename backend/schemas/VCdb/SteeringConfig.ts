// SteeringConfig.ts
import { list } from '@keystone-6/core';
import { integer, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const SteeringConfig = list({
  access: allowAll,
  fields: {
    SteeringConfigID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    SteeringType: relationship({ ref: 'SteeringType.steeringConfigs', many: false }),
    SteeringSystem: relationship({ ref: 'SteeringSystem.steeringConfigs', many: false }),
  },
});
