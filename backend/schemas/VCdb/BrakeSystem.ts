import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const BrakeSystem = list({
  access: allowAll,
  fields: {
    BrakeSystemID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    BrakeSystemName: text({ validation: { isRequired: true, length: { max: 30 } } }),
  },
});
