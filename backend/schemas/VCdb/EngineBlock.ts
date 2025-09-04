import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const EngineBlock = list({
  access: allowAll,
  fields: {
    EngineBlockConfigID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    EngineBlockConfigName: text({ validation: { isRequired: true }, isIndexed: true }),
  },
});
