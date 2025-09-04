import { list } from '@keystone-6/core';
import { integer, text, relationship } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const PIESSegment = list({
  access: allowAll,
  fields: {
    PIESSegmentId: integer({ validation : { isRequired: true }, isIndexed: 'unique' }),
    SegmentAbb: text({ validation: { isRequired: true } }),
    SegmentName: text({ validation: { isRequired: true } }),
    SegmentDescription: text({ validation: { isRequired: true } }),
    piesFields: relationship({ ref: 'PIESField.PIESSegmentId', many: true }),
  },
});
