import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const Style = list({
  access: allowAll,
  fields: {
    styleID: integer(),
    styleName: text(),
  },
});
