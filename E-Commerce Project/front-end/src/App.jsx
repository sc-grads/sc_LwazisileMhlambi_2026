import { Routes, Route, Navigate } from 'react-router-dom'
import { AuthProvider, useAuth } from './context/AuthContext'
import Footer from './components/Footer'
import Navbar from './components/Navbar'
import SignUp from './pages/SignUp'
import Login from './pages/Login'
import Products from './pages/Products'
import AdminDashboard from './pages/AdminDashboard'
import AdminProducts from './pages/AdminProducts'
import AdminCategories from './pages/AdminCategories'
import AdminUsers from './pages/AdminUsers'
import AdminOrders from './pages/AdminOrders'
import Profile from './pages/Profile'
import ProfileDetails from './pages/ProfileDetails'
import ProductDetail from './pages/ProductDetail'
import Wishlist from './pages/Wishlist'
import Cart from './pages/Cart'
import CheckoutCart from './pages/CheckoutCart'
import CheckoutWishlist from './pages/CheckoutWishlist'
import Orders from './pages/Orders'
import Home from './pages/Home'

// Informational & Policy Pages
import DeliverForUs from './pages/DeliverForUs'
import PrivacyPolicy from './pages/PrivacyPolicy'
import ReturnsPolicy from './pages/ReturnsPolicy'
import About from './pages/About'
import SuggestProduct from './pages/SuggestProduct'
import ShippingDelivery from './pages/ShippingDelivery'

// Protected Route for Authenticated Users
function AuthRoute({ children }) {
  const { isLoggedIn } = useAuth()
  if (!isLoggedIn) {
    return <Navigate to="/login" replace />
  }
  return children
}

// Protected Route for Admin Users
function AdminRoute({ children }) {
  const { isLoggedIn, role } = useAuth()
  if (!isLoggedIn || role !== 'admin') {
    return <Navigate to="/login" replace />
  }
  return children
}

function AppContent() {
  return (
    <div className="flex flex-col min-h-screen">
      <Navbar />
      <main className="flex-grow">
        <Routes>
          {/* Public Store Pages */}
          <Route path="/" element={<Home />} />
          <Route path="/sign-up" element={<SignUp />} />
          <Route path="/login" element={<Login />} />
          <Route path="/products" element={<Products />} />
          <Route path="/products/:id" element={<ProductDetail />} />
          <Route path="/wishlist" element={<Wishlist />} />
          <Route path="/cart" element={<Cart />} />
          <Route path="/checkout/cart" element={<CheckoutCart />} />
          <Route path="/checkout/wishlist" element={<CheckoutWishlist />} />

          {/* Information & Policy Routes */}
          <Route path="/about" element={<About />} />
          <Route path="/suggest-product" element={<SuggestProduct />} />
          <Route path="/shipping-delivery" element={<ShippingDelivery />} />
          <Route path="/deliver-for-us" element={<DeliverForUs />} />
          <Route path="/privacy-policy" element={<PrivacyPolicy />} />
          <Route path="/returns-policy" element={<ReturnsPolicy />} />

          {/* Protected User Routes */}
          <Route 
            path="/profile" 
            element={
              <AuthRoute>
                <Profile />
              </AuthRoute>
            } 
          />
          <Route 
            path="/profile/details" 
            element={
              <AuthRoute>
                <ProfileDetails />
              </AuthRoute>
            } 
          />
          <Route 
            path="/profile/orders" 
            element={
              <AuthRoute>
                <Orders />
              </AuthRoute>
            } 
          />
          <Route 
            path="/orders" 
            element={
              <AuthRoute>
                <Orders />
              </AuthRoute>
            } 
          />

          {/* Protected Admin Routes */}
          <Route 
            path="/admin" 
            element={
              <AdminRoute>
                <AdminDashboard />
              </AdminRoute>
            } 
          />
          <Route 
            path="/admin/dashboard" 
            element={
              <AdminRoute>
                <AdminDashboard />
              </AdminRoute>
            } 
          />
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
          <Route 
            path="/admin/orders" 
            element={
              <AdminRoute>
                <AdminOrders />
              </AdminRoute>
            } 
          />

          {/* Fallback Catch-All Route */}
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </main>
      <Footer />
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