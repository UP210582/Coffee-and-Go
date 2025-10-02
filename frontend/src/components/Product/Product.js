import React from "react";
import ProductDetail from "./ProductDetail";
import AppHeader from '../AppHeader/AppHeader';
import RelatedProduct from './RelatedProduct';

export default function Product() {
  return (
    <> 
      <AppHeader />
      <ProductDetail />
      <RelatedProduct />
    </>
  );
}