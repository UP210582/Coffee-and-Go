import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const DriveType = list({
  access: allowAll,
  fields: {
    DriveTypeID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    DriveTypeName: text({ validation: { isRequired: true }, isIndexed: true }),
  },
});
