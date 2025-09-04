import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const EngineBase = list({
  access: allowAll,
  fields: {
    EngineBaseID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    MfrEngineCode: text({ validation: { isRequired: false }, isIndexed: undefined }),
    EngineDesignation: text({ validation: { isRequired: false }, isIndexed: undefined }),
  },
});
