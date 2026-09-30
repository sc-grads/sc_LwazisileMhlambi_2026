import { useState, useEffect } from 'react'
import { Link, useNavigate } from 'react-router-dom'

// Import custom image assets
import farmerIcon from '../assets/farmer-avatar-icon.png'
import livestockIcon from '../assets/chicken-lamb-cow-livestock-icon-logo-design-template-vector.jpg'
import clipboardIcon from '../assets/101952-200.png'
import totalIcon from '../assets/18242162.png'

function AdminDashboard() {
  const navigate = useNavigate()
  const [metrics, setMetrics] = useState({
    totalOrders: 0,
    totalRevenue: 0,
    totalQuantity: 0,
    statusCounts: {
      Paid: 0,
      Processing: 0,
      Shipped: 0,
      Delivered: 0,
      Cancelled: 0,
    },
  })
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    document.title = 'Admin Dashboard | WeanerMart'

    const fetchAdminMetrics = async () => {
      const token = localStorage.getItem('token')
      if (!token) {
        navigate('/login')
        return
      }

      try {
        // Fetch all orders to compute KPIs across the platform
        const response = await fetch('http://127.0.0.1:5001/api/admin/orders', {
          headers: { Authorization: `Bearer ${token}` },
        })

        if (!response.ok) {
          throw new Error('Failed to load admin metrics')
        }

        const orders = await response.json()

        // Calculate KPI values dynamically
        let revenue = 0
        let quantity = 0
        const statuses = {
          Paid: 0,
          Processing: 0,
          Shipped: 0,
          Delivered: 0,
          Cancelled: 0,
        }

        orders.forEach((order) => {
          // Total Revenue calculation
          revenue += Number(order.total_price || 0)

          // Total Quantity of items sold across all orders
          if (order.items && Array.isArray(order.items)) {
            order.items.forEach((item) => {
              quantity += Number(item.quantity || 0)
            })
          }

          // Count orders by status
          const statusKey = order.status
            ? order.status.charAt(0).toUpperCase() + order.status.slice(1).toLowerCase()
            : ''

          if (statuses.hasOwnProperty(statusKey)) {
            statuses[statusKey] += 1
          }
        })

        setMetrics({
          totalOrders: orders.length,
          totalRevenue: revenue,
          totalQuantity: quantity,
          statusCounts: statuses,
        })
      } catch (err) {
        console.error('Error fetching dashboard data:', err)
        setError('Failed to load dashboard metrics. Please check your credentials or backend endpoint.')
      } finally {
        setLoading(false)
      }
    }

    fetchAdminMetrics()
  }, [navigate])

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center text-gray-500 font-medium">
        Loading admin dashboard...
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-50 py-10 px-4 sm:px-6 lg:px-8">
      <div className="max-w-7xl mx-auto space-y-8">
        
        {/* Header Section */}
        <div className="border-b border-gray-200 pb-5">
          <h1 className="text-3xl font-extrabold text-gray-900 tracking-tight">Welcome to the Barn (Dashboard)</h1>
          <p className="mt-1 text-sm text-gray-500">
            Overview of store performance, order breakdowns, and management controls.
          </p>
        </div>

        {error && (
          <div className="bg-red-50 border border-red-200 text-red-700 p-4 rounded-md text-sm">
            {error}
          </div>
        )}

        {/* --- Top Level KPI Summaries --- */}
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-6">
          
          {/* Total Orders */}
          <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm flex items-center justify-between">
            <div>
              <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider">Total Orders</p>
              <p className="text-3xl font-bold text-gray-900 mt-2">{metrics.totalOrders}</p>
            </div>
            <div className="w-12 h-12 bg-amber-50 rounded-full flex items-center justify-center p-2">
              <img src={clipboardIcon} alt="Orders Icon" className="w-full h-full object-contain" />
            </div>
          </div>

          {/* Total Revenue */}
          <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm flex items-center justify-between">
            <div>
              <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider">Total Revenue</p>
              <p className="text-3xl font-bold text-gray-900 mt-2">
                R{metrics.totalRevenue.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
              </p>
            </div>
            <div className="w-12 h-12 bg-emerald-50 rounded-full flex items-center justify-center p-2">
              <span className="text-2xl font-black text-emerald-600">R</span>
            </div>
          </div>

          {/* Total Quantity */}
          <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm flex items-center justify-between">
            <div>
              <p className="text-xs font-semibold text-gray-500 uppercase tracking-wider">Total Items Sold</p>
              <p className="text-3xl font-bold text-gray-900 mt-2">{metrics.totalQuantity}</p>
            </div>
            <div className="w-12 h-12 bg-blue-50 rounded-full flex items-center justify-center p-2 overflow-hidden">
              <img src={totalIcon} alt="Livestock Icon" className="w-full h-full object-contain" />
            </div>
          </div>

        </div>

        {/* --- Order Status Breakdown KPIs --- */}
        <div>
          <h2 className="text-lg font-bold text-gray-900 mb-4">Orders by Status</h2>
          <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-4">
            
            {/* Paid */}
            <div className="bg-white p-4 rounded-lg border border-gray-200 shadow-sm text-center">
              <span className="inline-block px-2.5 py-0.5 rounded-full text-xs font-semibold bg-emerald-100 text-emerald-800 mb-2">
                Paid
              </span>
              <p className="text-2xl font-bold text-gray-900">{metrics.statusCounts.Paid}</p>
            </div>

            {/* Processing */}
            <div className="bg-white p-4 rounded-lg border border-gray-200 shadow-sm text-center">
              <span className="inline-block px-2.5 py-0.5 rounded-full text-xs font-semibold bg-amber-100 text-amber-800 mb-2">
                Processing
              </span>
              <p className="text-2xl font-bold text-gray-900">{metrics.statusCounts.Processing}</p>
            </div>

            {/* Shipped */}
            <div className="bg-white p-4 rounded-lg border border-gray-200 shadow-sm text-center">
              <span className="inline-block px-2.5 py-0.5 rounded-full text-xs font-semibold bg-blue-100 text-blue-800 mb-2">
                Shipped
              </span>
              <p className="text-2xl font-bold text-gray-900">{metrics.statusCounts.Shipped}</p>
            </div>

            {/* Delivered */}
            <div className="bg-white p-4 rounded-lg border border-gray-200 shadow-sm text-center">
              <span className="inline-block px-2.5 py-0.5 rounded-full text-xs font-semibold bg-green-100 text-green-800 mb-2">
                Delivered
              </span>
              <p className="text-2xl font-bold text-gray-900">{metrics.statusCounts.Delivered}</p>
            </div>

            {/* Cancelled */}
            <div className="bg-white p-4 rounded-lg border border-gray-200 shadow-sm text-center col-span-2 sm:col-span-1">
              <span className="inline-block px-2.5 py-0.5 rounded-full text-xs font-semibold bg-rose-100 text-rose-800 mb-2">
                Cancelled
              </span>
              <p className="text-2xl font-bold text-gray-900">{metrics.statusCounts.Cancelled}</p>
            </div>

          </div>
        </div>

        {/* --- Quick Management Links --- */}
        <div>
          <h2 className="text-lg font-bold text-gray-900 mb-4">Quick Navigation & Management</h2>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-6">
            
            {/* Manage Orders */}
            <Link
              to="/admin/orders"
              className="group bg-white p-6 rounded-xl border border-gray-200 shadow-sm hover:shadow-md transition duration-200 flex flex-col justify-between"
            >
              <div>
                <div className="flex items-center space-x-3 mb-2">
                  <img src={clipboardIcon} alt="Manage Orders Icon" className="w-7 h-7 object-contain" />
                  <h3 className="text-lg font-bold text-gray-900 group-hover:text-[#ffac00] transition-colors">
                    Manage Orders
                  </h3>
                </div>
                <p className="text-sm text-gray-500">
                  View customer orders, filter transactions, and update fulfillment statuses.
                </p>
              </div>
              <span className="mt-4 text-xs font-semibold text-[#ffac00] group-hover:underline flex items-center space-x-1">
                <span>Go to Orders</span>
                <span>&rarr;</span>
              </span>
            </Link>

            {/* Manage Users */}
            <Link
              to="/admin/users"
              className="group bg-white p-6 rounded-xl border border-gray-200 shadow-sm hover:shadow-md transition duration-200 flex flex-col justify-between"
            >
              <div>
                <div className="flex items-center space-x-3 mb-2">
                  <img src={farmerIcon} alt="Manage Users Icon" className="w-7 h-7 object-contain" />
                  <h3 className="text-lg font-bold text-gray-900 group-hover:text-[#ffac00] transition-colors">
                    Manage Users
                  </h3>
                </div>
                <p className="text-sm text-gray-500">
                  Review registered user profiles, manage administrative roles, and user access.
                </p>
              </div>
              <span className="mt-4 text-xs font-semibold text-[#ffac00] group-hover:underline flex items-center space-x-1">
                <span>Go to Users</span>
                <span>&rarr;</span>
              </span>
            </Link>

            {/* Manage Products */}
            <Link
              to="/admin/products"
              className="group bg-white p-6 rounded-xl border border-gray-200 shadow-sm hover:shadow-md transition duration-200 flex flex-col justify-between"
            >
              <div>
                <div className="flex items-center space-x-3 mb-2">
                  <img src={livestockIcon} alt="Manage Products Icon" className="w-7 h-7 object-contain mix-blend-multiply" />
                  <h3 className="text-lg font-bold text-gray-900 group-hover:text-[#ffac00] transition-colors">
                    Manage Products
                  </h3>
                </div>
                <p className="text-sm text-gray-500">
                  Add new livestock listings, edit existing products, and adjust pricing or inventory.
                </p>
              </div>
              <span className="mt-4 text-xs font-semibold text-[#ffac00] group-hover:underline flex items-center space-x-1">
                <span>Go to Products</span>
                <span>&rarr;</span>
              </span>
            </Link>

          </div>
        </div>

      </div>
    </div>
  )
}

export default AdminDashboard