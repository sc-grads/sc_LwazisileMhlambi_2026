import { useState, useEffect } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import CartLogo from '../assets/cart-icon.png';

function Cart() {
  const navigate = useNavigate()
  const [cartItems, setCartItems] = useState([])
  const [loading, setLoading] = useState(true)
  const [message, setMessage] = useState({ type: '', text: '' })

  useEffect(() => {
    document.title = 'My Cart | WeanerMart'
    checkAuthAndFetchCart()
  }, [])

  const checkAuthAndFetchCart = async () => {
    const token = localStorage.getItem('token')
    if (!token) {
      navigate('/login')
      return
    }

    try {
      const response = await fetch('http://127.0.0.1:5001/api/cart', {
        headers: { 'Authorization': `Bearer ${token}` }
      })
      const data = await response.json()
      if (!response.ok) throw new Error(data.error || 'Failed to fetch cart')
      setCartItems(data)
    } catch (err) {
      setMessage({ type: 'error', text: 'Could not load your cart items.' })
    } finally {
      setLoading(false)
    }
  }

  const handleQuantityChange = async (cartItemId, currentQty, delta) => {
    const newQty = currentQty + delta
    if (newQty < 1) return // Do not allow quantity below 1 via buttons (use remove instead)

    try {
      const token = localStorage.getItem('token')
      const response = await fetch(`http://127.0.0.1:5001/api/cart/${cartItemId}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        },
        body: JSON.stringify({ quantity: newQty })
      })

      const data = await response.json()
      if (!response.ok) throw new Error(data.error || 'Failed to update quantity')

      // Update local state smoothly
      setCartItems((prev) =>
        prev.map((item) => (item.id === cartItemId ? { ...item, quantity: newQty } : item))
      )
    } catch (err) {
      setMessage({ type: 'error', text: err.message || 'Error updating quantity.' })
    }
  }

  const handleRemoveItem = async (cartItemId) => {
    try {
      const token = localStorage.getItem('token')
      const response = await fetch(`http://127.0.0.1:5001/api/cart/${cartItemId}`, {
        method: 'DELETE',
        headers: { 'Authorization': `Bearer ${token}` }
      })
      const data = await response.json()
      if (!response.ok) throw new Error(data.error || 'Failed to remove item')

      setCartItems((prev) => prev.filter((item) => item.id !== cartItemId))
      setMessage({ type: 'success', text: 'Item removed from cart.' })
    } catch (err) {
      setMessage({ type: 'error', text: err.message || 'Error removing item.' })
    }
  }

  const calculateSubtotal = () => {
    return cartItems.reduce((acc, item) => acc + (item.current_price * item.quantity), 0)
  }

  if (loading) {
    return <div className="min-h-screen bg-gray-50 flex items-center justify-center text-gray-500">Loading cart...</div>
  }

  return (
    <div className="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-4xl mx-auto">
        
        {/* Header Section */}
        <div className="mb-8 pb-4 border-b border-gray-200">
          <h1 className="text-3xl font-bold text-gray-900 tracking-tight">Shopping Cart 
            <div className="relative">
                <img src={CartLogo} alt="Cart Logo" className="w-9 h-9 object-contain" />
                          
            </div>
            </h1>
          <p className="text-sm text-gray-500 mt-1">Review your items, update quantities, or proceed to checkout.</p>
        </div>

        {message.text && (
          <div className={`p-4 mb-6 rounded-md text-sm ${message.type === 'error' ? 'bg-red-50 text-red-700 border border-red-200' : 'bg-green-50 text-green-700 border border-green-200'}`}>
            {message.text}
          </div>
        )}

        {cartItems.length === 0 ? (
          <div className="bg-white shadow-sm rounded-lg border border-gray-200 p-12 text-center">
            <p className="text-gray-500 text-lg mb-4">Your cart is currently empty.</p>
            <Link
              to="/products"
              className="inline-block bg-gray-900 text-white font-medium text-sm py-2.5 px-6 rounded-md hover:bg-gray-800 transition"
            >
              Explore Products
            </Link>
          </div>
        ) : (
          <div className="space-y-6">
            {/* Items List */}
            <div className="space-y-4">
              {cartItems.map((item) => (
                <div 
                  key={item.id} 
                  className="bg-white shadow-sm rounded-lg border border-gray-200 p-6 flex flex-col sm:flex-row items-center justify-between gap-6 transition hover:shadow-md"
                >
                  {/* Product Image & Info */}
                  <div className="flex items-center space-x-4 w-full sm:w-auto">
                    <div className="w-20 h-20 bg-gray-100 rounded-md overflow-hidden flex-shrink-0 flex items-center justify-center p-2">
                      <img 
                        src={item.product_picture || 'https://via.placeholder.com/150'} 
                        alt={item.product_name} 
                        className="w-full h-full object-contain mix-blend-multiply"
                      />
                    </div>
                    <div>
                      <Link to={`/products/${item.product_id}`} className="text-lg font-medium text-gray-900 hover:text-[#ffac00] transition">
                        {item.product_name}
                      </Link>
                      <p className="text-green-600 font-semibold mt-1">
                        R{item.current_price?.toFixed(2)} each
                      </p>
                    </div>
                  </div>

                  {/* Quantity Controller & Total Price Calculation */}
                  <div className="flex items-center justify-between w-full sm:w-auto space-x-6 border-t sm:border-t-0 pt-4 sm:pt-0 border-gray-100">
                    <div className="flex items-center border border-gray-300 rounded-md bg-white">
                      <button
                        onClick={() => handleQuantityChange(item.id, item.quantity, -1)}
                        className="px-3 py-1.5 text-gray-600 hover:bg-gray-100 rounded-l-md transition"
                      >
                        -
                      </button>
                      <span className="px-4 py-1.5 text-gray-900 font-medium">{item.quantity}</span>
                      <button
                        onClick={() => handleQuantityChange(item.id, item.quantity, 1)}
                        className="px-3 py-1.5 text-gray-600 hover:bg-gray-100 rounded-r-md transition"
                      >
                        +
                      </button>
                    </div>

                    <div className="text-right">
                      <p className="text-sm text-gray-500">Total</p>
                      <p className="text-lg font-bold text-gray-900">
                        R{(item.current_price * item.quantity).toFixed(2)}
                      </p>
                    </div>

                    <button
                      onClick={() => handleRemoveItem(item.id)}
                      className="text-red-500 hover:text-red-700 text-sm font-medium transition"
                    >
                      Remove
                    </button>
                  </div>
                </div>
              ))}
            </div>

            {/* Cart Summary & Checkout Bar */}
            <div className="bg-white shadow-sm rounded-lg border border-gray-200 p-6 flex flex-col sm:flex-row items-center justify-between gap-4">
              <div>
                <p className="text-sm text-gray-500">Sub-Total</p>
                <p className="text-2xl font-extrabold text-gray-900">R{calculateSubtotal().toFixed(2)}</p>
              </div>

              <button
                onClick={() => navigate('/checkout')}
                className="w-full sm:w-auto bg-green-600 hover:bg-green-700 text-white font-medium text-base py-3 px-8 rounded-lg shadow transition text-center"
              >
                Proceed to Checkout
              </button>
            </div>
          </div>
        )}

      </div>
    </div>
  )
}

export default Cart