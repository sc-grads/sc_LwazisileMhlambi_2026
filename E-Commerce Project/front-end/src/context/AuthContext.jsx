import { createContext, useContext, useState, useEffect } from 'react';

const AuthContext = createContext();

export function AuthProvider({ children }) {
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [firstName, setFirstName] = useState('');
  const [role, setRole] = useState('customer');

  useEffect(() => {
    const token = localStorage.getItem('token');
    const storedName = localStorage.getItem('firstName');
    const storedRole = localStorage.getItem('role');

    if (token) {
      setIsLoggedIn(true);
      if (storedName) setFirstName(storedName);
      if (storedRole) setRole(storedRole);
    }
  }, []);

  const loginUser = (token, name, userRole) => {
    localStorage.setItem('token', token);
    localStorage.setItem('firstName', name);
    localStorage.setItem('role', userRole || 'customer');
    setIsLoggedIn(true);
    setFirstName(name);
    setRole(userRole || 'customer');
  };

  const logoutUser = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('firstName');
    localStorage.removeItem('role');
    setIsLoggedIn(false);
    setFirstName('');
    setRole('customer');
  };

  return (
    <AuthContext.Provider value={{ isLoggedIn, firstName, role, loginUser, logoutUser }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  return useContext(AuthContext);
}