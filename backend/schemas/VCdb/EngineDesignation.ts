import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const EngineDesignation = list({
  access: allowAll,
  fields: {
    EngineDesignationID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    EngineDesignationName: text({ validation: { isRequired: true }, isIndexed: true }),
  },
});
