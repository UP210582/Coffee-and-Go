import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const Subcategory = list({
  access: allowAll,
  fields: {
    SubCategoryID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    SubCategoryName: text({ validation: { isRequired: true, length: { max: 255 } } }),
    codeMasters: relationship({ ref: 'CodeMaster.SubCategoryID', many: true }),
  },
});
