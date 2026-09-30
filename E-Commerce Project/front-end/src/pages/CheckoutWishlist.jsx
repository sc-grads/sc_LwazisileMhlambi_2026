import { useState, useEffect } from 'react'
import { useNavigate, Link } from 'react-router-dom'

function CheckoutWishlist() {
  const navigate = useNavigate()
  
  const [wishlistItems, setWishlistItems] = useState([])
  const [loading, setLoading] = useState(true)
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState('')

  const [formData, setFormData] = useState({
    fullName: '',
    email: '',
    phone: '',
    address: '',
    city: '',
    province: '',
    postalCode: ''
  })

  useEffect(() => {
    document.title = 'Wishlist Checkout | WeanerMart'
    loadWishlistCheckoutData()
  }, [])

  const loadWishlistCheckoutData = async () => {
    try {
      const token = localStorage.getItem('token')
      if (!token) {
        navigate('/login')
        return
      }

      const [wishlistRes, userRes] = await Promise.all([
        fetch('http://127.0.0.1:5001/api/wishlist', {
          headers: { 'Authorization': `Bearer ${token}` }
        }),
        fetch('http://127.0.0.1:5001/api/auth/me', {
          headers: { 'Authorization': `Bearer ${token}` }
        })
      ])

      const wishlistData = await wishlistRes.json()
      if (!wishlistRes.ok) throw new Error(wishlistData.error || 'Failed to load wishlist')
      setWishlistItems(wishlistData)

      if (userRes.ok) {
        const userData = await userRes.json()
        setFormData({
          fullName: `${userData.first_name || ''} ${userData.last_name || ''}`.trim(),
          email: userData.email || '',
          phone: userData.phone || '',
          address: userData.address_line1 || '',
          city: userData.city || '',
          province: userData.province || '',
          postalCode: userData.postal_code || ''
        })
      }
    } catch (err) {
      setError('Could not load wishlist checkout details.')
    } finally {
      setLoading(false)
    }
  }

  const handleInputChange = (e) => {
    const { name, value } = e.target
    setFormData(prev => ({ ...prev, [name]: value }))
  }

  const subtotal = wishlistItems.reduce((acc, item) => {
    const product = item.product || {}
    const price = product.current_price ?? product.price ?? item.price ?? 0
    return acc + Number(price)
  }, 0)

  const shippingFee = 150.00
  const grandTotal = subtotal + (subtotal > 0 ? shippingFee : 0)

  const handlePlaceOrder = async (e) => {
    e.preventDefault()
    setSubmitting(true)
    setError('')

    try {
      const token = localStorage.getItem('token')
      const payload = {
        shipping_details: formData,
        items: wishlistItems,
        total_amount: grandTotal
      }

      const response = await fetch('http://127.0.0.1:5001/api/checkout/wishlist', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        },
        body: JSON.stringify(payload)
      })

      const data = await response.json()
      if (!response.ok) throw new Error(data.error || 'Failed to place order from wishlist')

      navigate('/orders')
    } catch (err) {
      setError(err.message || 'An error occurred while placing your order.')
    } finally {
      setSubmitting(false)
    }
  }

  if (loading) {
    return <div className="min-h-screen bg-gray-50 flex items-center justify-center text-gray-500">Loading wishlist checkout...</div>
  }

  if (wishlistItems.length === 0) {
    return (
      <div className="min-h-screen bg-gray-50 py-20 px-4 text-center">
        <h2 className="text-2xl font-bold text-gray-800 mb-4">Your wishlist is empty</h2>
        <Link to="/products" className="bg-[#ffac00] text-white font-medium px-6 py-3 rounded-md hover:bg-[#e09800] transition">
          Browse Products
        </Link>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-7xl mx-auto">
        <h1 className="text-3xl font-extrabold text-gray-900 mb-8">Wishlist Checkout</h1>

        {error && <div className="mb-6 p-4 bg-red-50 border border-red-200 text-red-700 rounded-md text-sm">{error}</div>}

        <form onSubmit={handlePlaceOrder} className="grid grid-cols-1 lg:grid-cols-12 gap-12">
          <div className="lg:col-span-7 space-y-8">
            <div className="bg-white p-6 sm:p-8 rounded-lg shadow-sm border border-gray-200">
              <h2 className="text-xl font-bold text-gray-900 mb-4">Shipping Information</h2>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div className="sm:col-span-2">
                  <label className="block text-sm font-medium text-gray-700">Full Name</label>
                  <input type="text" name="fullName" required value={formData.fullName} onChange={handleInputChange} className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2.5 text-sm" />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">Email Address</label>
                  <input type="email" name="email" required value={formData.email} onChange={handleInputChange} className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2.5 text-sm" />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">Phone Number</label>
                  <input type="tel" name="phone" required value={formData.phone} onChange={handleInputChange} className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2.5 text-sm" />
                </div>
                <div className="sm:col-span-2">
                  <label className="block text-sm font-medium text-gray-700">Street Address</label>
                  <input type="text" name="address" required value={formData.address} onChange={handleInputChange} className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2.5 text-sm" />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">City</label>
                  <input type="text" name="city" required value={formData.city} onChange={handleInputChange} className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2.5 text-sm" />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">Province / State</label>
                  <input type="text" name="province" required value={formData.province} onChange={handleInputChange} className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2.5 text-sm" />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">Postal Code</label>
                  <input type="text" name="postalCode" required value={formData.postalCode} onChange={handleInputChange} className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2.5 text-sm" />
                </div>
              </div>
            </div>
          </div>

          <div className="lg:col-span-5">
            <div className="bg-white p-6 sm:p-8 rounded-lg shadow-sm border border-gray-200 sticky top-6">
              <h2 className="text-xl font-bold text-gray-900 mb-6">Wishlist Order Summary</h2>
              <div className="divide-y divide-gray-200 max-h-96 overflow-y-auto mb-6 pr-2">
                {wishlistItems.map((item) => {
                  const product = item.product || {}
                  const itemPrice = product.current_price ?? product.price ?? item.price ?? 0
                  return (
                    <div key={item.id} className="py-3 flex items-center justify-between">
                      <div className="flex items-center space-x-3 min-w-0">
                        <img src={product.product_picture || 'https://via.placeholder.com/100'} alt={product.product_name} className="w-12 h-12 object-contain rounded border border-gray-100 flex-shrink-0" />
                        <div className="min-w-0">
                          <p className="text-sm font-medium text-gray-900 truncate">{product.product_name}</p>
                          <p className="text-xs text-gray-500">Wishlist Item</p>
                        </div>
                      </div>
                      <div className="text-sm font-semibold text-gray-900 flex-shrink-0 pl-4">
                        R{Number(itemPrice).toLocaleString('en-US', { minimumFractionDigits: 2 })}
                      </div>
                    </div>
                  )
                })}
              </div>

              <div className="space-y-3 border-t border-gray-200 pt-4 text-sm">
                <div className="flex justify-between text-gray-600"><span>Subtotal</span><span>R{subtotal.toLocaleString('en-US', { minimumFractionDigits: 2 })}</span></div>
                <div className="flex justify-between text-gray-600"><span>Estimated Shipping</span><span>R{shippingFee.toLocaleString('en-US', { minimumFractionDigits: 2 })}</span></div>
                <div className="flex justify-between text-base font-bold text-gray-900 border-t border-gray-200 pt-3"><span>Total</span><span>R{grandTotal.toLocaleString('en-US', { minimumFractionDigits: 2 })}</span></div>
              </div>

              <button type="submit" disabled={submitting} className="w-full mt-6 bg-[#ffac00] hover:bg-[#e09800] text-white font-medium py-3 px-4 rounded-lg shadow transition text-center disabled:opacity-50">
                {submitting ? 'Processing Order...' : 'Place Order from Wishlist'}
              </button>
            </div>
          </div>
        </form>
      </div>
    </div>
  )
}

export default CheckoutWishlist