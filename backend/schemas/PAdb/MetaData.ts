import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const MetaData = list({
  access: allowAll,
  graphql: {
    plural: 'MetaDatas',
  },
  fields: {
    metaID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    metaName: text(),
    metaDescr: text(),
    metaFormat: text(),
    dataType: text(),
    minLength: integer(),
    maxLength: integer(),
  },
});
