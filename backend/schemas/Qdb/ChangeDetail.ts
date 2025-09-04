import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const QChangeDetail = list({
  access: allowAll,
  fields: {
    ChangeDetailID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    ChangeID: relationship({ ref: 'QChange.changeDetails', many: false }),  
    ChangeAttributeStateID: relationship({ ref: 'QChangeAttributeState.changeDetails', many: false }),
    TableNameID: relationship({ ref: 'QChangeTableName.changeDetails', many: false }),
    PrimaryKeyColumnName: text({ validation: { isRequired: false } }),
    PrimaryKeyBefore: integer(),
    PrimaryKeyAfter: integer(),
    ColumnName: text(),
    ColumnValueBefore: text({ }),
    ColumnValueAfter: text({ }),
  },
});