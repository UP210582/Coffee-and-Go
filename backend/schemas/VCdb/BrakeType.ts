import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const BrakeType = list({
  access: allowAll,
  fields: {
    BrakeTypeID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    BrakeTypeName: text({ validation: { isRequired: true, length: { max: 30 } } }),
  },
});
