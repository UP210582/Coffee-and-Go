import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const EngineVersion = list({
  access: allowAll,
  fields: {
    EngineVersionID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    EngineVersion: text({ validation: { isRequired: true }, isIndexed: true }),
  },
});
