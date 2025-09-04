import { list } from '@keystone-6/core';
import { integer, text, timestamp } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const PartsSupersession = list({
  access: allowAll,
  fields: {
    OldPartTerminologyID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    OldPartTerminologyName: text({ validation: { isRequired: true, length: { max: 200 } } }),
    NewPartTerminologyID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    NewPartTerminologyName: text({ validation: { isRequired: true, length: { max: 200 } } }),
    RevDate: timestamp(),
  },
});
