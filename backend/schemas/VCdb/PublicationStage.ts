import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const PublicationStage = list({
  access: allowAll,
  fields: {
    PublicationStageID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    PublicationStageName: text({ validation: { isRequired: true }}),
  },
});