import { list } from '@keystone-6/core';
import { text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const PartType = list({
    access:allowAll,
  fields: {
    description: text({ validation: { isRequired: true } }),
  },
});
