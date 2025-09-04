import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const PIESExpiCode = list({
  access: allowAll,
  fields: {
    PIESExpiCodeId: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    ExpiCode: text({ validation: { isRequired: true } }),
    ExpiCodeDescription: text({ validation: { isRequired: true } }),
    PIESExpiGroupId: relationship({ ref: 'PIESExpiGroup.expiCodes' }),
    piesReferenceFieldCodes: relationship({ ref: 'PIESReferenceFieldCode.PIESExpiCodeId', many: true }),
  },
});
