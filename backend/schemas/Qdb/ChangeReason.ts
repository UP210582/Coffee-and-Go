import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const QChangeReason = list({
  access: allowAll,
  fields: {
    ChangeReasonID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    ChangeReason: text({ validation: { isRequired: true } }),
  },
});
