import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const PIESCode = list({
  access: allowAll,
  fields: {
    PIESCodeId: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    CodeValue: text({ validation: { isRequired: true } }),
    CodeFormat: text({ validation: { isRequired: true } }),
    FieldFormat: text(),
    CodeDescription: text({ validation: { isRequired: true } }),
    Source: text(),
    piesReferenceFieldCodes: relationship({ ref: 'PIESReferenceFieldCode.PIESCodeId', many: true }),
  },
});
