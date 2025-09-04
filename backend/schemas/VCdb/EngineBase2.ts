import { list } from '@keystone-6/core';
import { integer, text, float } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const EngineBase2 = list({
  access: allowAll,
  fields: {
    EngineBaseID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    Cylinders: integer({ validation: { isRequired: false } }),
    DisplacementLiters: float({ validation: { isRequired: false } }),
    DisplacementCC: integer({ validation: { isRequired: false } }),
    DisplacementCI: integer({ validation: { isRequired: false } }),
  },
});
