import { list } from '@keystone-6/core';
import { integer } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const EngineConfig2 = list({
  access: allowAll,
  fields: {
    EngineConfigID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    EngineBaseID: integer({ validation: { isRequired: false } }),
    EngineBlockConfigID: integer({ validation: { isRequired: false } }),
    BoreInches: integer({ validation: { isRequired: false } }),
    StrokeInches: integer({ validation: { isRequired: false } }),
  },
});
