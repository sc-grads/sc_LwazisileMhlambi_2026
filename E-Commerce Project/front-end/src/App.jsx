import { Routes, Route, Navigate } from 'react-router-dom'
import { AuthProvider, useAuth } from './context/AuthContext'
import Navbar from './components/Navbar'
import SignUp from './pages/SignUp'
import Login from './pages/Login'
import Products from './pages/Products'
import AdminProducts from './pages/AdminProducts'
import AdminCategories from './pages/AdminCategories'
import AdminUsers from './pages/AdminUsers'
import Profile from './pages/Profile'
import ProfileDetails from './pages/ProfileDetails'
import ProductDetail from './pages/ProductDetail'
import Wishlist from './pages/Wishlist'
import Cart from './pages/Cart'

function AdminRoute({ children }) {
  const { isLoggedIn, role } = useAuth()
  if (!isLoggedIn || role !== 'admin') {
    return <Navigate to="/login" replace />
  }
  return children
}

function AppContent() {
  return (
    <div>
      <Navbar />
      <Routes>
        <Route path="/sign-up" element={<SignUp />} />
        <Route path="/login" element={<Login />} />
        <Route path="/products" element={<Products />} />
        <Route path="/profile" element={<Profile />} />
        <Route path="/profile/details" element={<ProfileDetails />} />
        <Route path="/products/:id" element={<ProductDetail />} />
        <Route path="/wishlist" element={<Wishlist />} />
        <Route path="/cart" element={<Cart />} />

        {/* Protected Admin Products Route */}
        <Route 
          path="/admin/products" 
          element={
            <AdminRoute>
              <AdminProducts />
            </AdminRoute>
          } 
        />
        <Route 
          path="/admin/categories" 
          element={
            <AdminRoute>
              <AdminCategories />
            </AdminRoute>
          } 
        />
        <Route 
          path="/admin/users" 
          element={
            <AdminRoute>
              <AdminUsers />
            </AdminRoute>
          } 
        />
       {/* <Route path="*" element={<Navigate to="/products" replace />} /> */}
      </Routes>
    </div>
  )
}

function App() {
  return (
    <AuthProvider>
      <AppContent />
    </AuthProvider>
  )
}

export default App