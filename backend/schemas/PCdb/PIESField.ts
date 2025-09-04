import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const PIESField = list({
  access: allowAll,
  fields: {
    PIESFieldId: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    FieldName: text({ validation: { isRequired: true } }),
    ReferenceFieldNumber: text({ validation: { isRequired: true } }),
    PIESSegmentId: relationship({ ref: 'PIESSegment.piesFields' }), 
    piesReferenceFieldCodes: relationship({ ref: 'PIESReferenceFieldCode.PIESFieldId', many: true }),
  },
});
