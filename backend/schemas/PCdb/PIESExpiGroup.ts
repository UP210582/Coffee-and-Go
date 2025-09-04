import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const PIESExpiGroup = list({
  access: allowAll,
  fields: {
    PIESExpiGroupId: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    ExpiGroupCode: text({ validation: { isRequired: true } }),
    ExpiGroupDescription: text({ validation: { isRequired: true } }),
    expiCodes: relationship({ ref: 'PIESExpiCode.PIESExpiGroupId', many: true }),
  },
});
