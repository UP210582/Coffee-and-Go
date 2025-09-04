import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const MetaUOMCode = list({
  access: allowAll,
  fields: {
    metaUOMID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    uomCode: text(),
    uomDescription: text(),
    uomLabel: text(),
    measurementGroupID: integer({ validation: { isRequired: true } }),
  },
});
