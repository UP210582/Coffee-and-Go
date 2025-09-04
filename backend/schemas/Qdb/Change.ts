import { list } from '@keystone-6/core';
import { integer, timestamp, text, relationship} from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const QChange = list({
  access: allowAll,
  fields: {
    ChangeID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),  
    effectiveDate: timestamp(),
    reason: text(),
    changeDetails: relationship({ ref: 'QChangeDetail.ChangeID', many: true }),  
  },
});
 