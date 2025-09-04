import { list } from '@keystone-6/core';
import { integer, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const LanguageTranslationAttachment = list({
  access: allowAll,
  fields: {
    LanguageTranslationAttachmentID: integer({  validation: { isRequired: true }, isIndexed: 'unique' }),
    LanguageTranslationID: relationship({ ref: 'LanguageTranslation.attachments', many: false }),
    AttachmentID: integer({ validation: { isRequired: true } }),  // No foreign key given, so integer only
  },
});
