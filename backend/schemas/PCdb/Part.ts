import { list } from '@keystone-6/core';
import { integer, text, relationship, timestamp } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const Part = list({
  access: allowAll,
  fields: {
    PartTerminologyID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    PartTerminologyName: text({ validation: { isRequired: true, length: { max: 100 } } }),
    PartsDescriptionID: relationship({ ref: 'PartsDescription.parts' }),  
    RevDate: timestamp(),
  },
});
