import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const AttachmentType = list({
  access: allowAll,
  fields: {
    AttachmentTypeID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    AttachmentTypeName: text({ validation: { isRequired: true, length: { max: 20 } } }),
  },
});
