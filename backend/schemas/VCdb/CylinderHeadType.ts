import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const CylinderHeadType = list({
  access: allowAll,
  fields: {
    CylinderHeadTypeID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    CylinderHeadTypeName: text({ validation: { isRequired: true }, isIndexed: true }),
  },
});
