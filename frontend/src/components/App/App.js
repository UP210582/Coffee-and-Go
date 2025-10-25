import React, { useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import HomePage from '../HomePage';
import Login from '../Login';

function App() {
  return (
    <Router>
      <div className="App">
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/Login" element={<Login />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;