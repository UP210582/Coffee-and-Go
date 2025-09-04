import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const BrakeABS = list({
  access: allowAll,
  graphql: {
    plural: 'BrakeABSList',
  },
  fields: {
    BrakeABSID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    BrakeABSName: text({ validation: { isRequired: true, length: { max: 30 } } }),
  },
});
