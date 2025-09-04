import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const PIESReferenceFieldCode = list({
  access: allowAll,
  fields: {
    PIESReferenceFieldCodeId: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    PIESFieldId: relationship({ ref: 'PIESField.piesReferenceFieldCodes' }),
    PIESCodeId: relationship({ ref: 'PIESCode.piesReferenceFieldCodes' }),
    PIESExpiCodeId: relationship({ ref: 'PIESExpiCode.piesReferenceFieldCodes' }),
    ReferenceNotes: text(),
  },
});
