import { list } from '@keystone-6/core';
import { integer } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const PartAttributeStyle = list({
  access: allowAll,
  fields: {
    styleID: integer(),
    paptID: integer(),
  },
});
