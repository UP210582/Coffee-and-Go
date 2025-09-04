import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const Category = list({
  access: allowAll,
  fields: {
    CategoryID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    CategoryName: text({ validation: { isRequired: true, length: { max: 255 } } }),
    codeMasters: relationship({ ref: 'CodeMaster.CategoryID', many: true }),
  },
});
