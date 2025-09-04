import { list } from '@keystone-6/core';
import { allowAll } from '@keystone-6/core/access';
import { integer, text, relationship } from '@keystone-6/core/fields';

export const Asset = list({
    access: allowAll,
  fields: {
    yearsFrom: integer(),
    yearsTo: integer(),
    make: relationship({ ref: 'Make' }),
    model: relationship({ ref: 'Model' }),
    submodelId: integer(),
    engineBaseId: integer(),
    note: text(),
    assetName: text(),
  },
});
