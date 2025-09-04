import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const EngineConfig = list({
  access: allowAll,
  fields: {
    EngineConfigID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    EngineConfigName: text({ validation: { isRequired: true }, isIndexed: true }),
  },
});
