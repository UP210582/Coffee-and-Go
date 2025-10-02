import React from "react";
import AppHeader from '../AppHeader/AppHeader';
import SelectLocation from './SelectLocation';
import LocationResult from './LocationResult';

export default function BranchLocation() {
  return (
    <> 
      <AppHeader />
      <SelectLocation />
      <LocationResult />
    </>
  );
}