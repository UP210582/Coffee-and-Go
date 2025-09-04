import { list } from '@keystone-6/core';
import { text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const ACESCodedValue = list({
  access: allowAll,
  fields: {
    Element: text(),
    Attribute: text(),
    CodedValue: text(),
    CodeDescription: text(),
  },
});
