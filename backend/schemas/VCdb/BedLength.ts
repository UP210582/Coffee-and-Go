import { list } from '@keystone-6/core';
import { integer, relationship, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const BedLength = list({
  access: allowAll,
  fields: {
    BedLengthID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    BedLength: text({ validation: { isRequired: true, length: { max: 10 } } }),
    BedLengthMetric: text({ validation: { isRequired: true, length: { max: 10 } } }),
    bedConfigs: relationship({ ref: 'BedConfig.BedLengthID', many: true })
  }
});