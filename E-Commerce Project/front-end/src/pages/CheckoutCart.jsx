import { useState, useEffect } from 'react'
import { useNavigate, Link } from 'react-router-dom'
import CartLogo from '../assets/cart-icon.png'

function CheckoutCart() {
  const navigate = useNavigate()
  const [cartItems, setCartItems] = useState([])
  const [loading, setLoading] = useState(true)
  const [submitting, setSubmitting] = useState(false)
  const [paymentGateway, setPaymentGateway] = useState('payfast') // Default: payfast
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
    document.title = 'Cart Checkout | WeanerMart'
    loadCartCheckoutData()
  }, [])

  const loadCartCheckoutData = async () => {
    try {
      const token = localStorage.getItem('token')
      if (!token) {
        navigate('/login')
        return
      }

      const [cartRes, userRes] = await Promise.all([
        fetch('http://127.0.0.1:5001/api/cart', {
          headers: { 'Authorization': `Bearer ${token}` }
        }),
        fetch('http://127.0.0.1:5001/api/auth/me', {
          headers: { 'Authorization': `Bearer ${token}` }
        })
      ])

      const cartData = await cartRes.json()
      if (!cartRes.ok) throw new Error(cartData.error || 'Failed to load cart')
      setCartItems(cartData)

      if (userRes.ok) {
        const userData = await userRes.json()
        setFormData({
          fullName: `${userData.first_name || ''} ${userData.last_name || ''}`.trim(),
          email: userData.email || '',
          phone: userData.phone_number || '',
          address: userData.address_line1 || '',
          city: userData.city || '',
          province: userData.province || '',
          postalCode: userData.postal_code || ''
        })
      }
    } catch (err) {
      setError('Could not load cart checkout details.')
    } finally {
      setLoading(false)
    }
  }

  const handleInputChange = (e) => {
    const { name, value } = e.target
    setFormData(prev => ({ ...prev, [name]: value }))
  }

  const subtotal = cartItems.reduce((acc, item) => {
    const product = item.product || {}
    const price = product.current_price ?? product.price ?? item.current_price ?? item.price ?? 0
    return acc + (Number(price) * Number(item.quantity || 1))
  }, 0)

  const shippingFee = 250.00
  const grandTotal = subtotal + (subtotal > 0 ? shippingFee : 0)

  const handleCheckoutSubmit = async (e) => {
    e.preventDefault()
    setSubmitting(true)
    setError('')

    const token = localStorage.getItem('token')

    const payload = {
      shipping_details: {
        fullName: formData.fullName,
        email: formData.email,
        phone: formData.phone,
        address: formData.address,
        city: formData.city,
        province: formData.province,
        postalCode: formData.postalCode,
        postal_code: formData.postalCode
      },
      items: cartItems,
      total_amount: grandTotal
    }

    localStorage.setItem('pending_shipping', JSON.stringify(payload.shipping_details))

    try {
      if (paymentGateway === 'stripe') {
        const response = await fetch('http://127.0.0.1:5001/api/create-stripe-checkout', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`
          },
          body: JSON.stringify(payload)
        })

        const data = await response.json()
        if (!response.ok) throw new Error(data.error || 'Stripe initialization failed')

        if (data.checkout_url) {
          window.location.href = data.checkout_url
        } else {
          throw new Error('No checkout URL received from Stripe endpoint.')
        }

      } else if (paymentGateway === 'paystack') {
        const response = await fetch('http://127.0.0.1:5001/api/create-paystack-payment', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`
          },
          body: JSON.stringify(payload)
        })

        const data = await response.json()
        if (!response.ok) throw new Error(data.error || 'Paystack initialization failed')

        const paystackUrl = data.authorization_url || (data.data && data.data.authorization_url)
        if (paystackUrl) {
          window.location.href = paystackUrl
        } else {
          throw new Error('No authorization URL received from Paystack endpoint.')
        }

      } else {
        const response = await fetch('http://127.0.0.1:5001/api/create-payfast-payment', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`
          },
          body: JSON.stringify(payload)
        })

        const data = await response.json()
        if (!response.ok) throw new Error(data.error || 'PayFast initialization failed')

        if (!data.payfast_url || !data.payload) {
          throw new Error('Invalid PayFast payload received from server.')
        }

        const form = document.createElement('form')
        form.method = 'POST'
        form.action = data.payfast_url

        Object.keys(data.payload).forEach((key) => {
          const input = document.createElement('input')
          input.type = 'hidden'
          input.name = key
          input.value = data.payload[key]
          form.appendChild(input)
        })

        document.body.appendChild(form)
        form.submit()
      }
    } catch (err) {
      setError(err.message || 'An error occurred while processing your payment.')
      setSubmitting(false)
    }
  }

  if (loading) {
    return <div className="min-h-screen bg-gray-50 flex items-center justify-center text-gray-500">Loading cart checkout...</div>
  }

  if (cartItems.length === 0) {
    return (
      <div className="min-h-screen bg-gray-50 py-20 px-4 text-center">
        <h2 className="text-2xl font-bold text-gray-800 mb-4">Your cart is empty</h2>
        <Link to="/products" className="bg-[#ffac00] text-white font-medium px-6 py-3 rounded-md hover:bg-[#e09800] transition">
          Browse Products
        </Link>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-7xl mx-auto">
        <div className="mb-8 pb-4 border-b border-gray-200">
          <h1 className="text-3xl font-bold text-gray-900 tracking-tight flex items-center gap-3">
            <span>Cart Checkout</span>
            <img src={CartLogo} alt="Cart Logo" className="w-9 h-9 object-contain" />
          </h1>
          <p className="text-sm text-gray-500 mt-1">Complete your delivery details and select a payment gateway to finalize your order.</p>
        </div>

        {error && (
          <div className="mb-6 p-4 bg-red-50 border border-red-200 text-red-700 rounded-md text-sm flex justify-between items-center">
            <span>{error}</span>
            <button onClick={() => setError('')} className="font-bold ml-4">✕</button>
          </div>
        )}

        <form onSubmit={handleCheckoutSubmit} className="grid grid-cols-1 lg:grid-cols-12 gap-12">
          {/* Delivery Details Form */}
          <div className="lg:col-span-7 space-y-8">
            <div className="bg-white p-6 sm:p-8 rounded-lg shadow-sm border border-gray-200">
              <h2 className="text-xl font-bold text-gray-900 mb-4">Delivery Information</h2>
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

            {/* Payment Method Selector */}
            <div className="bg-white p-6 sm:p-8 rounded-lg shadow-sm border border-gray-200">
              <h2 className="text-xl font-bold text-gray-900 mb-4">Payment Method</h2>
              <div className="space-y-3">
                <label className={`flex items-center p-4 border rounded-lg cursor-pointer transition ${paymentGateway === 'payfast' ? 'border-red-600 bg-red-50/10' : 'border-gray-200 hover:bg-gray-50'}`}>
                  <input type="radio" name="paymentGateway" value="payfast" checked={paymentGateway === 'payfast'} onChange={(e) => setPaymentGateway(e.target.value)} className="h-4 w-4 text-red-600 focus:ring-red-500 border-gray-300" />
                  <div className="ml-3">
                    <span className="block text-sm font-semibold text-gray-900">PayFast (Instant EFT, Credit Cards & SA Options)</span>
                    <span className="block text-xs text-gray-500">Secure South African payment gateway supporting local payment methods.</span>
                  </div>
                </label>

                <label className={`flex items-center p-4 border rounded-lg cursor-pointer transition ${paymentGateway === 'paystack' ? 'border-teal-600 bg-teal-50/10' : 'border-gray-200 hover:bg-gray-50'}`}>
                  <input type="radio" name="paymentGateway" value="paystack" checked={paymentGateway === 'paystack'} onChange={(e) => setPaymentGateway(e.target.value)} className="h-4 w-4 text-teal-600 focus:ring-teal-500 border-gray-300" />
                  <div className="ml-3">
                    <span className="block text-sm font-semibold text-gray-900">Paystack (Cards, EFT & Mobile Money)</span>
                    <span className="block text-xs text-gray-500">Fast and secure payment processing across Africa.</span>
                  </div>
                </label>

                <label className={`flex items-center p-4 border rounded-lg cursor-pointer transition ${paymentGateway === 'stripe' ? 'border-indigo-600 bg-indigo-50/10' : 'border-gray-200 hover:bg-gray-50'}`}>
                  <input type="radio" name="paymentGateway" value="stripe" checked={paymentGateway === 'stripe'} onChange={(e) => setPaymentGateway(e.target.value)} className="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300" />
                  <div className="ml-3">
                    <span className="block text-sm font-semibold text-gray-900">Stripe (International & Local Credit/Debit Cards)</span>
                    <span className="block text-xs text-gray-500">Secure global card processing via Stripe hosted checkout.</span>
                  </div>
                </label>
              </div>
            </div>
          </div>

          {/* Cart Items Summary Section */}
          <div className="lg:col-span-5">
            <div className="bg-white p-6 sm:p-8 rounded-lg shadow-sm border border-gray-200 sticky top-6">
              <h2 className="text-xl font-bold text-gray-900 mb-6">Cart Items Summary</h2>
              <div className="space-y-4 max-h-96 overflow-y-auto mb-6 pr-2">
                {cartItems.map((item) => {
                  const product = item.product || {}
                  const itemPrice = product.current_price ?? product.price ?? item.current_price ?? item.price ?? 0
                  const imageUrl = product.product_picture || item.product_picture || 'https://via.placeholder.com/150'
                  const productName = product.product_name || item.product_name || 'Product'

                  return (
                    <div key={item.id} className="bg-gray-50 border border-gray-100 rounded-lg p-4 flex items-center justify-between gap-4">
                      <div className="flex items-center space-x-3 min-w-0">
                        <div className="w-16 h-16 bg-white rounded-md overflow-hidden flex-shrink-0 flex items-center justify-center p-1 border border-gray-200">
                          <img src={imageUrl} alt={productName} className="w-full h-full object-contain mix-blend-multiply" />
                        </div>
                        <div className="min-w-0">
                          <p className="text-sm font-medium text-gray-900 truncate">{productName}</p>
                          <p className="text-xs text-gray-500 mt-0.5">Quantity: <span className="font-semibold text-gray-700">{item.quantity}</span></p>
                          <p className="text-xs text-green-600 font-semibold mt-1">R{Number(itemPrice).toFixed(2)} each</p>
                        </div>
                      </div>
                      <div className="text-right flex-shrink-0">
                        <p className="text-sm font-bold text-gray-900">
                          R{(Number(itemPrice) * Number(item.quantity)).toFixed(2)}
                        </p>
                      </div>
                    </div>
                  )
                })}
              </div>

              <div className="space-y-3 border-t border-gray-200 pt-4 text-sm">
                <div className="flex justify-between text-gray-600">
                  <span>Sub-total</span>
                  <span className="font-medium text-gray-900">R{subtotal.toFixed(2)}</span>
                </div>
                <div className="flex justify-between text-gray-600">
                  <span>Flat Delivery Fee</span>
                  <span className="font-medium text-gray-900">R{shippingFee.toFixed(2)}</span>
                </div>
                <div className="flex justify-between text-base font-extrabold text-gray-900 border-t border-gray-200 pt-3">
                  <span>Total Amount</span>
                  <span className="text-green-600">R{grandTotal.toFixed(2)}</span>
                </div>
              </div>

              <button
                type="submit"
                disabled={submitting}
                className={`w-full mt-6 text-white font-medium py-3 px-4 rounded-lg shadow transition text-center disabled:opacity-50 ${
                  paymentGateway === 'stripe' 
                    ? 'bg-indigo-600 hover:bg-indigo-700' 
                    : paymentGateway === 'paystack' 
                    ? 'bg-teal-600 hover:bg-teal-700' 
                    : 'bg-red-500 hover:bg-red-600'
                }`}
              >
                {submitting ? 'Redirecting to Payment...' : `Proceed with ${
                  paymentGateway === 'stripe' ? 'Stripe' : paymentGateway === 'paystack' ? 'Paystack' : 'PayFast'
                }`}
              </button>
            </div>
          </div>
        </form>
      </div>
    </div>
  )
}

export default CheckoutCart