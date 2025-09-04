import { list } from '@keystone-6/core';
import { integer, relationship, timestamp } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const CodeMaster = list({
  access: allowAll,
  fields: {
    CodeMasterID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    CategoryID: relationship({ ref: 'Category.codeMasters' }),
    SubCategoryID: relationship({ ref: 'Subcategory.codeMasters' }),
    PositionID: relationship({ ref: 'Position.codeMasters' }),
    RevDate: timestamp(),
  },
});