import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const WheelBase = list({
  access: allowAll,
  fields: {
    WheelBaseID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    WheelBase: text({ validation: { isRequired: true, length: { max: 100 } } }),
    WheelBaseMetric: text({ validation: { isRequired: true, length: { max: 100 } } }),
  },
});
