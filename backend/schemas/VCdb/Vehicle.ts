import { list } from '@keystone-6/core';
import { integer, relationship, text } from '@keystone-6/core/fields';
import { allowAll } from '@keystone-6/core/access';

export const Vehicle = list({
  access: allowAll,
  fields: {
    VehicleID: integer({ isIndexed: 'unique', validation: { isRequired: true } }),
    BaseVehicleID: relationship({ ref: 'BaseVehicle'}),
    TransmissionID: relationship({ ref: 'Transmission' }),
    DriveTypeID: relationship({ ref: 'DriveType' }),
    BodyNumDoorsID: relationship({ ref: 'BodyNumDoors' }),
    BodyTypeID: relationship({ ref: 'BodyType' }),
    BrakeSystemID: relationship({ ref: 'BrakeSystem' }),
    RegionID: relationship({ ref: 'Region' }),
    BedLengthID: relationship({ ref: 'BedLength' }),
    BedTypeID: relationship({ ref: 'BedType' }),
    WheelBaseID: relationship({ ref: 'WheelBase' }),
    MfrBodyCodeID: relationship({ ref: 'MfrBodyCode' }),
    SteeringSystemID: relationship({ ref: 'SteeringSystem' }),
    SteeringTypeID: relationship({ ref: 'SteeringType' }),
    BrakeTypeID: relationship({ ref: 'BrakeType' }),
    SpringTypeID: relationship({ ref: 'SpringType' }),
    FuelTypeID: relationship({ ref: 'FuelType' }),
    EngineBaseID: relationship({ ref: 'EngineBase' }),
    TransmissionBaseID: relationship({ ref: 'TransmissionBase' }),
    Note: text(),
  },
});
