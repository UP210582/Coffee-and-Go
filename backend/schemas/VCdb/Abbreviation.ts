import { list } from '@keystone-6/core';
import { text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const Abbreviation = list({
  access: allowAll,
  fields: {
    Abbreviation: text({
      validation: { isRequired: true, length: { max: 3 } },
      isIndexed: 'unique'
    }),
    Description: text({
      validation: { isRequired: true, length: { max: 20 } }
    }),
    LongDescription: text({
      validation: { isRequired: true, length: { max: 200 } }
    }),
  },
});
