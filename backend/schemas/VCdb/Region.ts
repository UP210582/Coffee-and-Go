import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const Region = list({
  access: allowAll,
  fields: {
    RegionID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    ParentID: relationship({ ref: 'Region', many: false}),
    RegionAbbr: text({ validation: { isRequired: false }}),
    RegionName: text({ validation: { isRequired: false }}),
  },
});
