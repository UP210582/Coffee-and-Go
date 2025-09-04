import { list } from '@keystone-6/core';
import { integer, text, relationship} from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const Position = list({
  access: allowAll,
  fields: {
    PositionID: integer({ validation: { isRequired: true }, isIndexed: 'unique' }),
    Position: text({ validation: { isRequired: true, length: { max: 255 } } }),
    codeMasters: relationship({ ref: 'CodeMaster.PositionID', many: true }),
  },
});
