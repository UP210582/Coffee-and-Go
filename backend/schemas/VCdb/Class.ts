import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const Class = list({
  access: allowAll,
  fields: {
    ClassID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    ClassName: text({ validation: { isRequired: true }, isIndexed: true }),
  },
});
