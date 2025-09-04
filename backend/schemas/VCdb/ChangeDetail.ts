import { list } from '@keystone-6/core';
import { integer, relationship, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const VCChangeDetail = list({
  access: allowAll,
  fields: {
    ChangeDetailID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    ChangeID: relationship({ ref: 'VCChange.changeDetails', ui: { displayMode: 'select' } }),
    ChangeAttributeStateID: relationship({ ref: 'ChangeAttributeState.changeDetails', ui: { displayMode: 'select' } }),
    TableNameID: relationship({ ref: 'VCChangeTableName.changeDetails', ui: { displayMode: 'select' } }),
    PrimaryKeyColumnName: text({ validation: { length: { max: 255 } } }),
    PrimaryKeyBefore: integer(),
    PrimaryKeyAfter: integer(),
    ColumnName: text({ validation: { length: { max: 255 } } }),
    ColumnValueBefore: text({ validation: { length: { max: 1000 } } }),
    ColumnValueAfter: text({ validation: { length: { max: 1000 } } }),
  },
});
