import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const EngineVIN = list({
  access: allowAll,
  fields: {
    EngineVINID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    EngineVIN: text({ validation: { isRequired: true }, isIndexed: true }),
  },
});
