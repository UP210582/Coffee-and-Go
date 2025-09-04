import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const Aspiration = list({
  access: allowAll,
  fields: {
    AspirationID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    AspirationName: text({ validation: { isRequired: true, length: { max: 30 } } }),
  },
});
