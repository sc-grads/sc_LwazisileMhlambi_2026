import { useState, useEffect, useRef, useMemo } from 'react'
import { Link, useNavigate, useSearchParams } from 'react-router-dom'

function Orders() {
  const navigate = useNavigate()
  const [searchParams] = useSearchParams()
  const [orders, setOrders] = useState([])
  const [loading, setLoading] = useState(true)
  const [message, setMessage] = useState({ type: '', text: '' })

  // Filter States
  const [statusFilter, setStatusFilter] = useState('ALL')
  const [searchTerm, setSearchTerm] = useState('')
  const [minAmount, setMinAmount] = useState('')
  const [maxAmount, setMaxAmount] = useState('')

  // Pagination States
  const [currentPage, setCurrentPage] = useState(1)
  const itemsPerPage = 5

  const hasProcessed = useRef(false)

  useEffect(() => {
    document.title = 'My Orders | WeanerMart'

    const handlePaymentReturns = async () => {
      const isStripeSuccess = searchParams.get('success') === 'true'
      const isPaystackSuccess = searchParams.get('paystack_success') === 'true'
      const isPayfastSuccess = searchParams.get('payfast_success') === 'true'

      if (!isStripeSuccess && !isPaystackSuccess && !isPayfastSuccess) {
        fetchOrders()
        return
      }

      if (hasProcessed.current) return
      hasProcessed.current = true

      const token = localStorage.getItem('token')

      const shipping_details = JSON.parse(localStorage.getItem('pending_shipping') || '{}')

      if (isStripeSuccess) {
        try {
          const response = await fetch('http://127.0.0.1:5001/api/checkout/stripe-success', {
            method: 'POST',
            headers: {
              'Authorization': `Bearer ${token}`,
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({ shipping_details })
          })
          if (response.ok) {
            setMessage({ type: 'success', text: 'Payment successful via Stripe! Your order has been placed.' })
            window.dispatchEvent(new Event('cartUpdated'))
          }
        } catch (err) {
          console.error('Error finalizing Stripe order:', err)
        }
      } else if (isPaystackSuccess) {
        try {
          const response = await fetch('http://127.0.0.1:5001/api/checkout/paystack-success', {
            method: 'POST',
            headers: {
              'Authorization': `Bearer ${token}`,
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({ shipping_details })
          })
          if (response.ok) {
            setMessage({ type: 'success', text: 'Payment successful via PayStack! Your order has been placed.' })
            window.dispatchEvent(new Event('cartUpdated'))
          }
        } catch (err) {
          console.error('Error finalizing PayStack order:', err)
        }
      } else if (isPayfastSuccess) {
        try {
          const response = await fetch('http://127.0.0.1:5001/api/checkout/payfast-success', {
            method: 'POST',
            headers: {
              'Authorization': `Bearer ${token}`,
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({ shipping_details })
          })
          if (response.ok) {
            setMessage({ type: 'success', text: 'Payment successful via PayFast! Your order has been placed.' })
            window.dispatchEvent(new Event('cartUpdated'))
          }
        } catch (err) {
          console.error('Error finalizing PayFast order:', err)
        }
      }

      navigate('/profile/orders', { replace: true })
      fetchOrders()
    }

    handlePaymentReturns()
  }, [searchParams])

  const fetchOrders = async () => {
    const token = localStorage.getItem('token')
    if (!token) {
      navigate('/login')
      return
    }

    try {
      const response = await fetch('http://127.0.0.1:5001/api/orders', {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      })
      const data = await response.json()
      if (!response.ok) throw new Error(data.error || 'Failed to fetch order history')
      console.log('Fetched Orders API Payload:', data) // Helpful for inspecting structure
      setOrders(data)
    } catch (err) {
      setMessage({ type: 'error', text: 'Could not load your order history.' })
    } finally {
      setLoading(false)
    }
  }

  // Helper function to render status badges
  const getStatusBadgeClass = (status) => {
    switch (status?.toLowerCase()) {
      case 'paid':
        return 'bg-emerald-100 text-emerald-800'
      case 'processing':
        return 'bg-amber-100 text-amber-800'
      case 'shipped':
        return 'bg-blue-100 text-blue-800'
      case 'delivered':
        return 'bg-green-100 text-green-800'
      case 'cancelled':
        return 'bg-rose-100 text-rose-800'
      default:
        return 'bg-gray-100 text-gray-800'
    }
  }

  // Filter Orders Logic
  const filteredOrders = useMemo(() => {
    return orders.filter((order) => {
      if (statusFilter !== 'ALL' && order.status?.toUpperCase() !== statusFilter) {
        return false
      }

      if (searchTerm.trim() !== '') {
        const query = searchTerm.toLowerCase()
        const matchesId = String(order.id).toLowerCase().includes(query)
        const matchesDate = order.date_created?.toLowerCase().includes(query)
        const matchesItem = order.items?.some(item => item.product_name?.toLowerCase().includes(query))
        const street = order.shipping_address || order.address || order.street_address || ''
        const city = order.city || ''
        const matchesAddress = street.toLowerCase().includes(query) || city.toLowerCase().includes(query)

        if (!matchesId && !matchesDate && !matchesItem && !matchesAddress) {
          return false
        }
      }

      const total = Number(order.total_price)
      if (minAmount !== '' && total < Number(minAmount)) {
        return false
      }
      if (maxAmount !== '' && total > Number(maxAmount)) {
        return false
      }

      return true
    })
  }, [orders, statusFilter, searchTerm, minAmount, maxAmount])

  // Pagination Logic
  const totalPages = Math.ceil(filteredOrders.length / itemsPerPage)
  const currentOrders = useMemo(() => {
    const start = (currentPage - 1) * itemsPerPage
    return filteredOrders.slice(start, start + itemsPerPage)
  }, [filteredOrders, currentPage])

  useEffect(() => {
    setCurrentPage(1)
  }, [statusFilter, searchTerm, minAmount, maxAmount])

  const clearFilters = () => {
    setStatusFilter('ALL')
    setSearchTerm('')
    setMinAmount('')
    setMaxAmount('')
  }

  if (loading) {
    return <div className="min-h-screen bg-gray-50 flex items-center justify-center text-gray-500">Loading orders...</div>
  }

  return (
    <div className="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-4xl mx-auto">
        <div className="mb-8 pb-4 border-b border-gray-200">
          <h1 className="text-3xl font-bold text-gray-900 tracking-tight">Order History</h1>
          <p className="text-sm text-gray-500 mt-1">View your past transactions, delivery statuses, and purchased items.</p>
        </div>

        {message.text && (
          <div className={`p-4 mb-6 rounded-md text-sm ${message.type === 'error' ? 'bg-red-50 text-red-700 border border-red-200' : 'bg-green-50 text-green-700 border border-green-200'}`}>
            {message.text}
          </div>
        )}

        {/* Filters Section */}
        <div className="bg-white p-5 rounded-lg border border-gray-200 shadow-sm mb-6 space-y-4">
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            <div>
              <label className="block text-xs font-semibold text-gray-700 uppercase mb-1">Search / Date</label>
              <input
                type="text"
                placeholder="Order #, product, city..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full text-sm border-gray-300 rounded-md shadow-sm focus:ring-[#ffac00] focus:border-[#ffac00] p-2 border"
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-gray-700 uppercase mb-1">Status</label>
              <select
                value={statusFilter}
                onChange={(e) => setStatusFilter(e.target.value)}
                className="w-full text-sm border-gray-300 rounded-md shadow-sm focus:ring-[#ffac00] focus:border-[#ffac00] p-2 border bg-white"
              >
                <option value="ALL">All Statuses</option>
                <option value="PAID">Paid</option>
                <option value="PROCESSING">Processing</option>
                <option value="SHIPPED">Shipped</option>
                <option value="DELIVERED">Delivered</option>
                <option value="CANCELLED">Cancelled</option>
              </select>
            </div>

            <div>
              <label className="block text-xs font-semibold text-gray-700 uppercase mb-1">Min Amount (R)</label>
              <input
                type="number"
                placeholder="0"
                value={minAmount}
                onChange={(e) => setMinAmount(e.target.value)}
                className="w-full text-sm border-gray-300 rounded-md shadow-sm focus:ring-[#ffac00] focus:border-[#ffac00] p-2 border"
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-gray-700 uppercase mb-1">Max Amount (R)</label>
              <input
                type="number"
                placeholder="10000"
                value={maxAmount}
                onChange={(e) => setMaxAmount(e.target.value)}
                className="w-full text-sm border-gray-300 rounded-md shadow-sm focus:ring-[#ffac00] focus:border-[#ffac00] p-2 border"
              />
            </div>
          </div>

          {(searchTerm || statusFilter !== 'ALL' || minAmount || maxAmount) && (
            <div className="flex justify-between items-center pt-2 border-t border-gray-100 text-xs">
              <span className="text-gray-500">Showing {filteredOrders.length} matching result(s)</span>
              <button onClick={clearFilters} className="text-red-600 hover:underline font-medium">
                Clear Filters
              </button>
            </div>
          )}
        </div>

        {orders.length === 0 ? (
          <div className="bg-white shadow-sm rounded-lg border border-gray-200 p-12 text-center">
            <p className="text-gray-500 text-lg mb-4">You haven't placed any orders yet.</p>
            <Link
              to="/products"
              className="inline-block bg-[#ffac00] text-white font-medium text-sm py-2.5 px-6 rounded-md hover:bg-[#e09800] transition"
            >
              Start Shopping
            </Link>
          </div>
        ) : filteredOrders.length === 0 ? (
          <div className="bg-white shadow-sm rounded-lg border border-gray-200 p-8 text-center">
            <p className="text-gray-500 text-base mb-2">No orders match your filter criteria.</p>
            <button onClick={clearFilters} className="text-[#ffac00] hover:underline text-sm font-semibold">
              Reset Filters
            </button>
          </div>
        ) : (
          <div className="space-y-6">
            {currentOrders.map((order) => {
              // Address extraction with fallbacks
              const street = order.shipping_address || order.address || order.street_address
              const city = order.city
              const province = order.province || order.state
              const postalCode = order.postal_code || order.zip_code || order.postalCode
              const phone = order.phone || order.phone_number

              const hasAddress = street || city || province || phone

              return (
                <div
                  key={order.id}
                  className="bg-white shadow-sm rounded-lg border border-gray-200 overflow-hidden transition hover:shadow-md"
                >
                  {/* Order Meta Header */}
                  <div className="bg-gray-50 px-6 py-4 border-b border-gray-200 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                    <div className="flex flex-wrap items-center gap-6">
                      <div>
                        <div className="flex items-center space-x-3">
                          <span className="text-sm font-bold text-gray-900">Order #{order.id}</span>
                          <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-semibold uppercase ${getStatusBadgeClass(order.status)}`}>
                            {order.status}
                          </span>
                        </div>
                        <p className="text-xs text-gray-500 mt-1">
                          Placed on: <span className="font-medium text-gray-700">{order.date_created}</span>
                        </p>
                      </div>

                      {/* Delivery Address Block */}
                      {hasAddress ? (
                        <div className="border-l pl-6 border-gray-200">
                          <p className="text-xs text-gray-500 uppercase font-medium">Delivery Address</p>
                          {street && <p className="text-sm font-semibold text-gray-900">{street}</p>}
                          <p className="text-xs text-gray-500">
                            {[city, province, postalCode].filter(Boolean).join(', ')}
                          </p>
                          {phone && <p className="text-xs text-gray-500 mt-0.5">{phone}</p>}
                        </div>
                      ) : (
                        <div className="border-l pl-6 border-gray-200">
                          <p className="text-xs text-gray-500 uppercase font-medium">Delivery Address</p>
                          <p className="text-xs text-gray-400 italic">No address provided</p>
                        </div>
                      )}
                    </div>

                    {/* Total Amount Block */}
                    <div className="text-left sm:text-right border-t sm:border-t-0 sm:border-l pt-3 sm:pt-0 sm:pl-6 border-gray-200 min-w-[120px]">
                      <p className="text-xs text-gray-500">Total Amount</p>
                      <p className="text-base font-extrabold text-green-600">
                        R{Number(order.total_price).toFixed(2)}
                      </p>
                    </div>
                  </div>

                  {/* Items List */}
                  <div className="divide-y divide-gray-100 px-6">
                    {order.items?.map((item, index) => (
                      <div key={index} className="py-4 flex items-center justify-between gap-4">
                        <div className="flex items-center space-x-4">
                          <div className="w-16 h-16 bg-gray-100 rounded-md overflow-hidden flex-shrink-0 flex items-center justify-center p-1">
                            <img
                              src={item.product_picture || 'https://via.placeholder.com/150'}
                              alt={item.product_name}
                              className="w-full h-full object-contain mix-blend-multiply"
                            />
                          </div>
                          <div>
                            <Link
                              to={`/products/${item.product_id}`}
                              className="text-sm font-medium text-gray-900 hover:text-[#ffac00] transition"
                            >
                              {item.product_name}
                            </Link>
                            <p className="text-xs text-gray-500 mt-0.5">
                              Quantity: <span className="font-semibold text-gray-700">{item.quantity}</span>
                            </p>
                          </div>
                        </div>
                        <div className="text-right">
                          <p className="text-sm font-bold text-gray-900">
                            R{Number(item.price).toFixed(2)}
                          </p>
                        </div>
                      </div>
                    ))}
                  </div>

                  {/* Order Footer Info */}
                  <div className="bg-gray-50/50 px-6 py-3 border-t border-gray-100 flex justify-between items-center text-xs text-gray-500">
                    <span>Payment Ref: <code className="bg-gray-100 px-1.5 py-0.5 rounded text-gray-700">{order.payment_id}</code></span>
                  </div>
                </div>
              )
            })}

            {/* Pagination Controls */}
            {totalPages > 1 && (
              <div className="flex items-center justify-between border-t border-gray-200 bg-white px-4 py-3 sm:px-6 rounded-lg">
                <div className="flex flex-1 justify-between sm:hidden">
                  <button
                    onClick={() => setCurrentPage((prev) => Math.max(prev - 1, 1))}
                    disabled={currentPage === 1}
                    className="relative inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 disabled:opacity-50"
                  >
                    Previous
                  </button>
                  <button
                    onClick={() => setCurrentPage((prev) => Math.min(prev + 1, totalPages))}
                    disabled={currentPage === totalPages}
                    className="relative ml-3 inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 disabled:opacity-50"
                  >
                    Next
                  </button>
                </div>
                <div className="hidden sm:flex sm:flex-1 sm:items-center sm:justify-between">
                  <div>
                    <p className="text-sm text-gray-700">
                      Showing page <span className="font-medium">{currentPage}</span> of{' '}
                      <span className="font-medium">{totalPages}</span>
                    </p>
                  </div>
                  <div>
                    <nav className="isolate inline-flex -space-x-px rounded-md shadow-sm" aria-label="Pagination">
                      <button
                        onClick={() => setCurrentPage((prev) => Math.max(prev - 1, 1))}
                        disabled={currentPage === 1}
                        className="relative inline-flex items-center rounded-l-md px-3 py-2 text-gray-400 ring-1 ring-inset ring-gray-300 hover:bg-gray-50 focus:z-20 focus:outline-offset-0 disabled:opacity-50"
                      >
                        Previous
                      </button>
                      {[...Array(totalPages)].map((_, idx) => {
                        const pageNum = idx + 1
                        return (
                          <button
                            key={pageNum}
                            onClick={() => setCurrentPage(pageNum)}
                            className={`relative inline-flex items-center px-4 py-2 text-sm font-semibold ${
                              currentPage === pageNum
                                ? 'z-10 bg-[#ffac00] text-white focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2'
                                : 'text-gray-900 ring-1 ring-inset ring-gray-300 hover:bg-gray-50'
                            }`}
                          >
                            {pageNum}
                          </button>
                        )
                      })}
                      <button
                        onClick={() => setCurrentPage((prev) => Math.min(prev + 1, totalPages))}
                        disabled={currentPage === totalPages}
                        className="relative inline-flex items-center rounded-r-md px-3 py-2 text-gray-400 ring-1 ring-inset ring-gray-300 hover:bg-gray-50 focus:z-20 focus:outline-offset-0 disabled:opacity-50"
                      >
                        Next
                      </button>
                    </nav>
                  </div>
                </div>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  )
}

export default Orders