import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const PartsDescription = list({
  access: allowAll,
  fields: {
    PartsDescriptionID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    PartsDescription: text({ validation: { isRequired: true, length: { max: 500 } } }),
    parts: relationship({ ref: 'Part.PartsDescriptionID', many: true }),
  },
});
