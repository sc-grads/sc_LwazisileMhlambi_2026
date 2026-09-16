import React, { useState } from 'react';
import { Link } from 'react-router-dom';

function Navbar() {
  const [isOpen, setIsOpen] = useState(false);
  
  // Example state: Replace with your actual Flask auth / cart context or redux store
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [cartCount, setCartCount] = useState(0); 

  return (
    <nav className="bg-white sticky top-0 z-50 shadow-sm">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">

          {/* Logo / Site Name */}
          <div className="flex-shrink-0">
            <Link to="/" className="text-xl font-bold text-[#ffac00]">
              WeanerMart
            </Link>
          </div>

          {/* Desktop Nav Links */}
          <div className="hidden md:flex items-center space-x-8">
            <Link to="/" className="text-gray-700 hover:text-[#ffac00] transition-colors">Home</Link>
            <Link to="/products" className="text-gray-700 hover:text-[#ffac00] transition-colors">Products</Link>
            <Link to="/wishlist" className="text-gray-700 hover:text-[#ffac00] transition-colors">Wishlist</Link>
            <Link to="/cart" className="text-gray-700 hover:text-[#ffac00] transition-colors relative">
              Cart
              {cartCount > 0 && (
                <span className="absolute -top-2 -right-3 bg-[#ffac00] text-white text-xs rounded-full h-5 w-5 flex items-center justify-center font-semibold">
                  {cartCount}
                </span>
              )}
            </Link>
          </div>

          {/* Auth buttons (Desktop) */}
          <div className="hidden md:flex items-center space-x-4">
            {!isLoggedIn ? (
              <>
                <Link to="/login" className="text-gray-700 hover:text-[#ffac00]">Log In</Link>
                <Link to="/sign-up" className="bg-[#ffac00] text-white px-4 py-2 rounded-md hover:bg-[#e09800] transition-colors">
                  Sign Up
                </Link>
              </>
            ) : (
              <button 
                onClick={() => setIsLoggedIn(false)}
                className="text-gray-700 hover:text-red-500 transition-colors"
              >
                Log Out
              </button>
            )}
          </div>

          {/* Mobile menu button */}
          <div className="md:hidden flex items-center">
            <button 
              onClick={() => setIsOpen(!isOpen)}
              className="text-gray-700 hover:text-[#ffac00] focus:outline-none"
              aria-label="Toggle Menu"
            >
              {isOpen ? (
                <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                </svg>
              ) : (
                <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
                </svg>
              )}
            </button>
          </div>

        </div>
      </div>

      {/* Mobile Menu Dropdown */}
      {isOpen && (
        <div className="md:hidden bg-white border-b border-gray-100 px-4 pt-2 pb-4 space-y-3">
          <Link to="/" onClick={() => setIsOpen(false)} className="block text-gray-700 hover:text-[#ffac00]">Home</Link>
          <Link to="/products" onClick={() => setIsOpen(false)} className="block text-gray-700 hover:text-[#ffac00]">Products</Link>
          <Link to="/wishlist" onClick={() => setIsOpen(false)} className="block text-gray-700 hover:text-[#ffac00]">Wishlist</Link>
          <Link to="/cart" onClick={() => setIsOpen(false)} className="block text-gray-700 hover:text-[#ffac00]">
            Cart {cartCount > 0 && `(${cartCount})`}
          </Link>
          <div className="pt-4 border-t border-gray-100 flex flex-col space-y-2">
            {!isLoggedIn ? (
              <>
                <Link to="/login" onClick={() => setIsOpen(false)} className="text-gray-700 hover:text-[#ffac00]">Log In</Link>
                <Link to="/sign-up" onClick={() => setIsOpen(false)} className="bg-[#ffac00] text-white text-center px-4 py-2 rounded-md hover:bg-[#e09800]">
                  Sign Up
                </Link>
              </>
            ) : (
              <button onClick={() => { setIsLoggedIn(false); setIsOpen(false); }} className="text-left text-gray-700 hover:text-red-500">
                Log Out
              </button>
            )}
          </div>
        </div>
      )}
    </nav>
  );
}

export default Navbar;