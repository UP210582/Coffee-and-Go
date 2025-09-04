import { list } from '@keystone-6/core';
import { integer, relationship, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const PCChangeDetail = list({
  access: allowAll,
  fields: {
    ChangeDetailID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    ChangeID: relationship({ ref: 'PCChange.changeDetails', many: false }),  
    ChangeAttributeStateID: relationship({ ref: 'PCChangeAttributeState.changeDetails', many: false }),
    TableNameID: relationship({ ref: 'PCChangeTableName.changeDetails', many: false }),
    PrimaryKeyColumnName: text(),
    PrimaryKeyBefore: integer(),
    PrimaryKeyAfter: integer(),
    ColumnName: text(),
    ColumnValueBefore: text(),
    ColumnValueAfter: text(),
  },
});