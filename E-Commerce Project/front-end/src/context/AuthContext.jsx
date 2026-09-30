import { createContext, useContext, useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

const AuthContext = createContext();

export function AuthProvider({ children }) {
  // Initialize state directly from localStorage so it's correct on the very first render
  const [isLoggedIn, setIsLoggedIn] = useState(() => {
    return !!localStorage.getItem('token');
  });
  const [firstName, setFirstName] = useState(() => {
    return localStorage.getItem('firstName') || '';
  });
  const [role, setRole] = useState(() => {
    return localStorage.getItem('role') || 'customer';
  });
  
  const navigate = useNavigate();

  const loginUser = (token, name, userRole) => {
    localStorage.setItem('token', token);
    localStorage.setItem('firstName', name);
    localStorage.setItem('role', userRole || 'customer');
    setIsLoggedIn(true);
    setFirstName(name);
    setRole(userRole || 'customer');
    triggerCartUpdate();
    triggerWishlistUpdate();
  };

  const logoutUser = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('firstName');
    localStorage.removeItem('role');
    setIsLoggedIn(false);
    setFirstName('');
    setRole('customer');
    navigate('/login');
  };

  // Global helper functions to notify the navbar to update in real time
  const triggerCartUpdate = () => {
    window.dispatchEvent(new Event('cartUpdated'));
  };

  const triggerWishlistUpdate = () => {
    window.dispatchEvent(new Event('wishlistUpdated'));
  };

  return (
    <AuthContext.Provider value={{ isLoggedIn, firstName, role, loginUser, logoutUser, triggerCartUpdate, triggerWishlistUpdate }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  return useContext(AuthContext);
}