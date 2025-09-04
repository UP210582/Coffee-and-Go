import { list } from '@keystone-6/core';
import { integer, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const MeasurementGroup = list({
  access: allowAll,
  fields: {
    measurementGroupID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    measurementGroupName: text(),
  },
});
