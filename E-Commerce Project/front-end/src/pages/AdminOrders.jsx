import { useState, useEffect } from 'react'

function AdminOrders() {
  const [orders, setOrders] = useState([])
  const [statuses, setStatuses] = useState([])
  const [loading, setLoading] = useState(true)
  const [message, setMessage] = useState({ type: '', text: '' })
  const [updatingId, setUpdatingId] = useState(null)

  useEffect(() => {
    document.title = 'Manage Orders | WeanerMart Admin'
    fetchOrdersAndStatuses()
  }, [])

  const fetchOrdersAndStatuses = async () => {
    try {
      const token = localStorage.getItem('token')
      const headers = { 'Authorization': `Bearer ${token}` }

      // Fetch orders and available statuses in parallel
      const [ordersRes, statusesRes] = await Promise.all([
        fetch('http://127.0.0.1:5001/api/admin/orders', { headers }),
        fetch('http://127.0.0.1:5001/api/admin/orders/statuses', { headers })
      ])

      const ordersData = await ordersRes.json()
      const statusesData = await statusesRes.json()

      if (!ordersRes.ok) throw new Error(ordersData.error || 'Failed to fetch orders')
      if (!statusesRes.ok) throw new Error(statusesRes.error || 'Failed to fetch statuses')

      setOrders(ordersData)
      setStatuses(statusesData)
    } catch (err) {
      setMessage({ type: 'error', text: err.message || 'Could not connect to server.' })
    } finally {
      setLoading(false)
    }
  }

  const handleStatusChange = async (orderId, newStatus) => {
    setUpdatingId(orderId)
    setMessage({ type: '', text: '' })

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
      if (!response.ok) throw new Error(data.error || 'Failed to update status')

      // Update local state to reflect the change immediately
      setOrders(orders.map(order => order.id === orderId ? { ...order, status: newStatus } : order))
      setMessage({ type: 'success', text: `Order #${orderId} status updated successfully!` })
    } catch (err) {
      setMessage({ type: 'error', text: err.message || 'Error updating order status.' })
    } finally {
      setUpdatingId(null)
    }
  }

  if (loading) {
    return <div className="min-h-screen bg-gray-50 flex items-center justify-center text-gray-500">Loading admin orders...</div>
  }

  return (
    <div className="min-h-screen bg-gray-50 py-10 px-4 sm:px-6 lg:px-8">
      <div className="max-w-7xl mx-auto">
        <div className="mb-6 flex justify-between items-center">
          <div>
            <h1 className="text-2xl font-bold text-gray-900">Manage Orders</h1>
            <p className="text-sm text-gray-500 mt-1">Review customer purchases, delivery details, and update fulfillment statuses.</p>
          </div>
        </div>

        {message.text && (
          <div className={`p-4 mb-6 rounded-md text-sm ${message.type === 'error' ? 'bg-red-50 text-red-700 border border-red-200' : 'bg-green-50 text-green-700 border border-green-200'}`}>
            {message.text}
          </div>
        )}

        <div className="bg-white shadow-sm rounded-lg border border-gray-200 overflow-hidden">
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Order ID</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Customer</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Product / Qty</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Total Price</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Delivery Address</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {orders.length === 0 ? (
                  <tr>
                    <td colSpan="6" className="px-6 py-8 text-center text-sm text-gray-500">No orders found.</td>
                  </tr>
                ) : (
                  orders.map((order) => (
                    <tr key={order.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                        #{order.id}
                        <div className="text-xs text-gray-400 font-normal">Ref: {order.payment_id.substring(0, 12)}...</div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                        <div className="font-medium text-gray-900">{order.customer_name}</div>
                        <div className="text-xs text-gray-500">{order.customer_email}</div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                        <div className="font-medium text-gray-900">{order.product_name}</div>
                        <div className="text-xs text-gray-500">Qty: {order.quantity}</div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-semibold text-gray-900">
                        R {order.price.toFixed(2)}
                      </td>
                      <td className="px-6 py-4 text-sm text-gray-600 max-w-xs">
                        {order.address_line1 ? (
                          <>
                            <div>{order.address_line1}{order.address_line2 ? `, ${order.address_line2}` : ''}</div>
                            <div className="text-xs text-gray-500">{order.city}, {order.province} {order.postal_code}</div>
                            <div className="text-xs text-gray-400">{order.country}</div>
                          </>
                        ) : (
                          <span className="text-gray-400 italic">No address provided</span>
                        )}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm">
                        <select
                          value={order.status}
                          onChange={(e) => handleStatusChange(order.id, e.target.value)}
                          disabled={updatingId === order.id}
                          className="px-3 py-1.5 text-xs font-semibold rounded-md border border-gray-300 bg-white shadow-sm focus:outline-none focus:ring-[#ffac00] focus:border-[#ffac00] disabled:opacity-50"
                        >
                          {statuses.map((st) => (
                            <option key={st} value={st}>
                              {st}
                            </option>
                          ))}
                        </select>
                        {updatingId === order.id && <span className="ml-2 text-xs text-gray-400 animate-pulse">Saving...</span>}
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  )
}

export default AdminOrders