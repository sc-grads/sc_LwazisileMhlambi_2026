import { useState, useEffect } from 'react'
import { useNavigate, Link } from 'react-router-dom'

// ADDED: allowed status transitions (keys are lowercase).
// Cancelled is allowed from any active step. Delivered and Cancelled are final.
const STATUS_FLOW = {
  paid: ['Processing', 'Cancelled'],
  processing: ['Shipped', 'Cancelled'],
  shipped: ['Delivered', 'Cancelled'],
  delivered: ['Cancelled'],
  cancelled: ['Paid']
}

const getAllowedStatuses = (currentStatus) => STATUS_FLOW[currentStatus?.toLowerCase()] || []

function AdminOrders() {
  const navigate = useNavigate()
  const [orders, setOrders] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [successMessage, setSuccessMessage] = useState('')

  // ADDED: holds the status change waiting for admin confirmation
  const [pendingChange, setPendingChange] = useState(null)

  // Filter & Pagination States
  const [dateFilter, setDateFilter] = useState('all')
  const [amountSort, setAmountSort] = useState('')
  const [statusFilter, setStatusFilter] = useState('all')
  const [searchQuery, setSearchQuery] = useState('')
  const [currentPage, setCurrentPage] = useState(1)
  const [itemsPerPage, setItemsPerPage] = useState(10)

  useEffect(() => {
    document.title = 'Manage Orders (Admin) | WeanerMart'
    fetchAdminOrders()
  }, [])

  const fetchAdminOrders = async () => {
    try {
      const token = localStorage.getItem('token')
      if (!token) {
        navigate('/login')
        return
      }

      const response = await fetch('http://127.0.0.1:5001/api/admin/orders', {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      })

      const data = await response.json()
      if (!response.ok) throw new Error(data.error || 'Failed to load orders')

      setOrders(data)
    } catch (err) {
      setError('Could not fetch admin orders. Please check your permissions.')
    } finally {
      setLoading(false)
    }
  }

  // ADDED: opens the confirmation modal instead of updating straight away
  const requestStatusChange = (order, newStatus) => {
    if (!getAllowedStatuses(order.status).includes(newStatus)) return
    setPendingChange({
      orderId: order.id,
      currentStatus: order.status,
      newStatus
    })
  }

  // ADDED: runs when the admin clicks "Confirm" in the modal
  const confirmStatusChange = () => {
    if (!pendingChange) return
    const { orderId, newStatus } = pendingChange
    setPendingChange(null)
    handleStatusChange(orderId, newStatus)
  }

  const handleStatusChange = async (orderId, newStatus) => {
    try {
      const token = localStorage.getItem('token')
      const response = await fetch(`http://127.0.0.1:5001/api/admin/orders/${orderId}/status`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        },
        body: JSON.stringify({ status: newStatus })
      })

      const data = await response.json()
      if (!response.ok) throw new Error(data.error || 'Failed to update order status')

      setOrders(prev => prev.map(o => o.id === orderId ? { ...o, status: newStatus } : o))
      setSuccessMessage(`Order #${orderId} status updated to ${newStatus}`)
      setTimeout(() => setSuccessMessage(''), 4000)
    } catch (err) {
      setError(err.message || 'Failed to update order status')
      setTimeout(() => setError(''), 4000)
    }
  }

  // Filtering Logic
  const filteredOrders = orders.filter(order => {
    if (statusFilter !== 'all' && order.status.toLowerCase() !== statusFilter.toLowerCase()) {
      return false
    }

    if (searchQuery.trim() !== '') {
      const query = searchQuery.toLowerCase()
      const customerName = (order.customer_name || '').toLowerCase()
      const email = (order.customer_email || '').toLowerCase()
      const orderIdStr = String(order.id)
      const address = (order.shipping_address || '').toLowerCase()
      const city = (order.city || '').toLowerCase()

      if (!customerName.includes(query) && 
          !email.includes(query) && 
          !orderIdStr.includes(query) &&
          !address.includes(query) &&
          !city.includes(query)) {
        return false
      }
    }

    if (dateFilter !== 'all' && order.date_created) {
      const orderDate = new Date(order.date_created)
      const today = new Date()

      if (dateFilter === 'today') {
        if (orderDate.toDateString() !== today.toDateString()) return false
      } else if (dateFilter === 'last7days') {
        const sevenDaysAgo = new Date()
        sevenDaysAgo.setDate(today.getDate() - 7)
        if (orderDate < sevenDaysAgo) return false
      } else if (dateFilter === 'thisMonth') {
        if (orderDate.getMonth() !== today.getMonth() || orderDate.getFullYear() !== today.getFullYear()) return false
      }
    }

    return true
  })

  // Sorting Logic (Amount)
  const sortedOrders = [...filteredOrders].sort((a, b) => {
    const totalA = Number(a.total_price)
    const totalB = Number(b.total_price)

    if (amountSort === 'asc') {
      return totalA - totalB
    } else if (amountSort === 'desc') {
      return totalB - totalA
    }
    return b.id - a.id
  })

  // Pagination Logic
  const totalPages = Math.ceil(sortedOrders.length / itemsPerPage) || 1
  const indexOfLastItem = currentPage * itemsPerPage
  const indexOfFirstItem = indexOfLastItem - itemsPerPage
  const currentOrders = sortedOrders.slice(indexOfFirstItem, indexOfLastItem)

  useEffect(() => {
    setCurrentPage(1)
  }, [searchQuery, dateFilter, statusFilter, amountSort, itemsPerPage])

  if (loading) {
    return <div className="min-h-screen bg-gray-50 flex items-center justify-center text-gray-500">Loading admin order records...</div>
  }

  return (
    <div className="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="mb-8 pb-4 border-b border-gray-200 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
          <div>
            <h1 className="text-3xl font-bold text-gray-900 tracking-tight">Customer Order Management</h1>
            <p className="text-sm text-gray-500 mt-1">Review orders placed across all customer accounts, update fulfillment statuses, and filter records.</p>
          </div>
          <Link to="/admin/dashboard" className="text-sm font-medium text-[#ffac00] hover:underline">
            &larr; Back to Dashboard
          </Link>
        </div>

        {/* Alerts */}
        {error && <div className="mb-6 p-4 bg-red-50 border border-red-200 text-red-700 rounded-md text-sm">{error}</div>}
        {successMessage && <div className="mb-6 p-4 bg-green-50 border border-green-200 text-green-700 rounded-md text-sm">{successMessage}</div>}

        {/* Filters & Controls Bar */}
        <div className="bg-white p-4 sm:p-6 rounded-lg shadow-sm border border-gray-200 mb-6 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
          <div className="sm:col-span-2">
            <label className="block text-xs font-semibold text-gray-600 uppercase mb-1">Search Customer / Address / Order ID</label>
            <input
              type="text"
              placeholder="Filter by name, email, address, or order #"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full border border-gray-300 rounded-md p-2 text-sm focus:ring-[#ffac00] focus:border-[#ffac00]"
            />
          </div>

          <div>
            <label className="block text-xs font-semibold text-gray-600 uppercase mb-1">Status</label>
            <select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
              className="w-full border border-gray-300 rounded-md p-2 text-sm bg-white"
            >
              <option value="all">All Statuses</option>
              <option value="paid">Paid</option>
              <option value="processing">Processing</option>
              <option value="shipped">Shipped</option>
              <option value="delivered">Delivered</option>
              <option value="cancelled">Cancelled</option>
            </select>
          </div>

          <div>
            <label className="block text-xs font-semibold text-gray-600 uppercase mb-1">Date Range</label>
            <select
              value={dateFilter}
              onChange={(e) => setDateFilter(e.target.value)}
              className="w-full border border-gray-300 rounded-md p-2 text-sm bg-white"
            >
              <option value="all">All Time</option>
              <option value="today">Today</option>
              <option value="last7days">Last 7 Days</option>
              <option value="thisMonth">This Month</option>
            </select>
          </div>

          <div>
            <label className="block text-xs font-semibold text-gray-600 uppercase mb-1">Sort by Amount</label>
            <select
              value={amountSort}
              onChange={(e) => setAmountSort(e.target.value)}
              className="w-full border border-gray-300 rounded-md p-2 text-sm bg-white"
            >
              <option value="">Newest First (Default)</option>
              <option value="asc">Price: Low to High</option>
              <option value="desc">Price: High to Low</option>
            </select>
          </div>
        </div>

        {/* Results Counter & Pagination Selector */}
        <div className="flex flex-col sm:flex-row justify-between items-center mb-4 text-sm text-gray-500">
          <p>Showing <span className="font-semibold text-gray-700">{sortedOrders.length === 0 ? 0 : indexOfFirstItem + 1}</span> - <span className="font-semibold text-gray-700">{Math.min(indexOfLastItem, sortedOrders.length)}</span> of <span className="font-semibold text-gray-700">{sortedOrders.length}</span> filtered orders</p>
          <div className="flex items-center space-x-2 mt-2 sm:mt-0">
            <span>Show:</span>
            <select
              value={itemsPerPage}
              onChange={(e) => setItemsPerPage(Number(e.target.value))}
              className="border border-gray-300 rounded-md px-2 py-1 text-sm bg-white"
            >
              <option value={10}>10 per page</option>
              <option value={20}>20 per page</option>
            </select>
          </div>
        </div>

        {/* Orders List */}
        {currentOrders.length === 0 ? (
          <div className="bg-white shadow-sm rounded-lg border border-gray-200 p-12 text-center">
            <p className="text-gray-500 text-lg mb-2">No matching orders found.</p>
            <p className="text-xs text-gray-400">Try adjusting your search filters or date parameters.</p>
          </div>
        ) : (
          <div className="space-y-4">
            {currentOrders.map((order) => (
              <div key={order.id} className="bg-white shadow-sm rounded-lg border border-gray-200 p-6 flex flex-col lg:flex-row lg:items-center lg:justify-between gap-6">
                {/* Order & Products Info */}
                <div className="space-y-2 flex-1">
                  <div className="flex items-center space-x-3">
                    <span className="text-base font-bold text-gray-900">Order #{order.id}</span>
                    {/* CHANGED: only shows the current status plus the next allowed steps,
                        asks for confirmation, and is disabled once the order is final */}
                    <select
                      value={order.status}
                      onChange={(e) => requestStatusChange(order, e.target.value)}
                      disabled={getAllowedStatuses(order.status).length === 0}
                      className="text-xs font-semibold uppercase px-2.5 py-1 rounded-md border border-gray-300 bg-white text-gray-800 shadow-sm focus:ring-[#ffac00] disabled:opacity-60 disabled:cursor-not-allowed"
                    >
                      {['Paid', 'Processing', 'Shipped', 'Delivered', 'Cancelled'].map((s) => {
                      const isCurrent = s.toLowerCase() === order.status?.toLowerCase()
                      const allowed = getAllowedStatuses(order.status).includes(s)
                      return (
                        <option key={s} value={isCurrent ? order.status : s} disabled={!isCurrent && !allowed}>
                          {s}
                        </option>
                      )
                    })}
                    </select>
                  </div>
                  <div className="text-xs text-gray-500">
                    Placed on: <span className="font-medium text-gray-700">{order.date_created}</span>
                  </div>

                  {/* Render Nested Items */}
                  <div className="divide-y divide-gray-100 border-t border-b border-gray-100 py-2 my-2">
                    {order.items.map((item, idx) => (
                      <div key={idx} className="py-1.5 flex justify-between items-center text-sm">
                        <div>
                          <span className="font-medium text-gray-800">{item.product_name}</span>
                          <span className="text-xs text-gray-500 ml-2">(Qty: {item.quantity})</span>
                        </div>
                        <div className="text-gray-600 font-medium">
                          R{Number(item.price).toFixed(2)}
                        </div>
                      </div>
                    ))}
                  </div>
                </div>

                {/* Customer, Shipping Address & Total */}
                <div className="flex flex-col sm:flex-row items-start sm:items-center gap-6 border-t lg:border-t-0 pt-4 lg:pt-0 border-gray-200">
                  {/* Customer Info */}
                  <div>
                    <p className="text-xs text-gray-500 uppercase">Customer</p>
                    <p className="text-sm font-semibold text-gray-900">{order.customer_name}</p>
                    <p className="text-xs text-gray-500">{order.customer_email}</p>
                  </div>

                  {/* Delivery Address Section (Matching Customer Layout with Vertical Divider) */}
                  <div className="border-l pl-6 border-gray-200">
                    <p className="text-xs text-gray-500 uppercase">Delivery Address</p>
                    {order.shipping_address || order.city || order.province ? (
                      <>
                        <p className="text-sm font-semibold text-gray-900">{order.shipping_address}</p>
                        <p className="text-xs text-gray-500">
                          {[order.city, order.province, order.postal_code].filter(Boolean).join(', ')}
                        </p>
                        {order.phone && <p className="text-xs text-gray-500 mt-0.5">{order.phone}</p>}
                      </>
                    ) : (
                      <p className="text-xs text-gray-400 italic">No address recorded</p>
                    )}
                  </div>

                  {/* Total Amount */}
                  <div className="text-right border-l pl-6 border-gray-200 min-w-[120px]">
                    <p className="text-xs text-gray-500">Total Amount</p>
                    <p className="text-base font-extrabold text-green-600">
                      R{Number(order.total_price).toFixed(2)}
                    </p>
                    <span className="text-[10px] text-gray-400 font-mono">Ref: {order.payment_id}</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}

        {/* Pagination Controls */}
        {totalPages > 1 && (
          <div className="flex justify-center items-center space-x-2 mt-8">
            <button
              onClick={() => setCurrentPage(prev => Math.max(prev - 1, 1))}
              disabled={currentPage === 1}
              className="px-4 py-2 border border-gray-300 rounded-md text-sm font-medium bg-white text-gray-700 hover:bg-gray-50 disabled:opacity-50"
            >
              Previous
            </button>
            <span className="text-sm text-gray-600 px-3">
              Page <strong className="text-gray-900">{currentPage}</strong> of <strong className="text-gray-900">{totalPages}</strong>
            </span>
            <button
              onClick={() => setCurrentPage(prev => Math.min(prev + 1, totalPages))}
              disabled={currentPage === totalPages}
              className="px-4 py-2 border border-gray-300 rounded-md text-sm font-medium bg-white text-gray-700 hover:bg-gray-50 disabled:opacity-50"
            >
              Next
            </button>
          </div>
        )}
      </div>

      {/* ADDED: Confirmation Modal */}
      {pendingChange && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 px-4"
          onClick={() => setPendingChange(null)}
        >
          <div
            className="bg-white rounded-lg shadow-xl border border-gray-200 w-full max-w-md p-6"
            onClick={(e) => e.stopPropagation()}
          >
            <h3 className="text-lg font-bold text-gray-900 mb-2">Confirm Status Change</h3>
            <p className="text-sm text-gray-600">
              Change <span className="font-semibold text-gray-900">Order #{pendingChange.orderId}</span> from{' '}
              <span className="font-semibold uppercase">{pendingChange.currentStatus}</span> to{' '}
              <span className="font-semibold uppercase">{pendingChange.newStatus}</span>?
            </p>
            {pendingChange.newStatus === 'Cancelled' && (
              <p className="mt-3 text-xs text-red-600 bg-red-50 border border-red-200 rounded-md p-2">
                Cancelling is final. This order cannot be moved to another status afterwards.
              </p>
            )}
            <div className="mt-6 flex justify-end gap-3">
              <button
                onClick={() => setPendingChange(null)}
                className="px-4 py-2 text-sm font-medium border border-gray-300 rounded-md bg-white text-gray-700 hover:bg-gray-50"
              >
                Cancel
              </button>
              <button
                onClick={confirmStatusChange}
                className={`px-4 py-2 text-sm font-medium rounded-md text-white ${
                  pendingChange.newStatus === 'Cancelled'
                    ? 'bg-red-600 hover:bg-red-700'
                    : 'bg-[#ffac00] hover:bg-[#e09800]'
                }`}
              >
                Confirm
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

export default AdminOrders