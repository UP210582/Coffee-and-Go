import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const QChangeTableName = list({
  access: allowAll,
  fields: {
    TableNameID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    TableName: text({ validation: { isRequired: true } }),
    TableDescription: text(),
    changeDetails: relationship({ ref: 'QChangeDetail.TableNameID', many: true }),
  },
});
