import { list } from '@keystone-6/core';
import { integer, text, timestamp } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const VCdbChange = list({
  access: allowAll,
  fields: {
    ChangeID: integer({ isIndexed: 'unique', validation: { isRequired: true } }),
    ChangeRequestID: integer(),
    TableName: text({ validation: { isRequired: true } }),
    VCdbRecordID: integer(),
    ChangeType: text({ validation: { isRequired: true } }),
    ChangeDate: timestamp(),
  },
});
