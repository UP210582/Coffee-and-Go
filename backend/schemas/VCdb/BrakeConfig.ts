import { list } from '@keystone-6/core';
import { integer, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const BrakeConfig = list({
  access: allowAll,
  fields: {
    BrakeConfigID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    FrontBrakeTypeID: relationship({ ref: 'BrakeType', ui: { displayMode: 'select' } }),
    RearBrakeTypeID: relationship({ ref: 'BrakeType', ui: { displayMode: 'select' } }),
    BrakeABSID: relationship({ ref: 'BrakeABS', ui: { displayMode: 'select' } }),
    BrakeSystemID: relationship({ ref: 'BrakeSystem', ui: { displayMode: 'select' } }),
  },
});
