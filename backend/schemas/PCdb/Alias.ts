import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const Alias = list({
  access: allowAll,
  fields: {
    AliasID: integer({ validation : { isRequired: true }, isIndexed: 'unique' }),
    AliasName: text({ validation: { isRequired: true, length: { max: 255 } } }),
    partsToAlias: relationship({ ref: 'PartsToAlias.alias', many: true }),  // <- Aquí, 'alias' debe coincidir con campo en PartsToAlias
  },
});