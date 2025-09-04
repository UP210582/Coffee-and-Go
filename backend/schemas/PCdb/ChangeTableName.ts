import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const PCChangeTableName = list({
  access: allowAll,
  fields: {
    TableNameID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    TableName: text({ validation: { isRequired: true, length: { max: 255 } } }),
    TableDescription: text(),
    changeDetails: relationship({ ref: 'PCChangeDetail.TableNameID', many: true }),
  },
});
