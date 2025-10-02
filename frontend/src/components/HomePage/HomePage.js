import React from "react";
import AppHeader from '../AppHeader/AppHeader';
import InformationSection from './InformationSection';
import VehicleSelector from './VehicleSelector';
import Carousel from './Carousel';

export default function FullPage() {
  return (
    <> 
      <AppHeader />
      <Carousel />
      <InformationSection />
      <VehicleSelector />
      
    </>
  );
}
