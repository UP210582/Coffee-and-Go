import React, { useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, useNavigate } from 'react-router-dom';
import HomePage from '../HomePage';
import Product from '../Product';
import BranchLocation from '../BranchLocation';
import Login from '../Login';
import Register from '../Login/Register';
import UserType from '../Login/UserType';
//import CatalogScreen from '../Catalog/CatalogScreen';

function App() {
  return (
    <Router>
      <div className="App">
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/product" element={<Product />} />
          <Route path="/location" element={<BranchLocation />} />
          <Route path="/login" element={<Login />} />
          <Route path="/register" element={<Register />} />
          <Route path="/usertype" element={<UserType />} />
          {/*<Route path="/catalog" element={<CatalogScreen />} />*/}
        </Routes>
      </div>
    </Router>
  );
}

export default App;