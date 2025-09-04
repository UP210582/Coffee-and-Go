import { list } from '@keystone-6/core';
import { integer, float } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const EngineBoreStroke = list({
  access: allowAll,
  fields: {
    EngineBaseID: integer({ validation: { isRequired: true } }),
    BoreInches: float({ validation: { isRequired: false } }),
    StrokeInches: float({ validation: { isRequired: false } }),
  },
});
