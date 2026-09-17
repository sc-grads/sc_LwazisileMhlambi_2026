import { Link } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'

function Profile() {
  const { firstName } = useAuth()

  return (
    <div className="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-3xl mx-auto">
        <div className="bg-white shadow-sm rounded-lg overflow-hidden border border-gray-200 p-8">
          <div className="border-b border-gray-200 pb-6 mb-6">
            <h1 className="text-2xl font-bold text-gray-900">Welcome back, {firstName || 'Customer'}!</h1>
            <p className="text-sm text-gray-500 mt-1">Here you can manage your account information and view past order activity.</p>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-6">
            {/* Personal Details Card */}
            <Link 
              to="/profile/details"
              className="block p-6 bg-gray-50 rounded-lg border border-gray-200 hover:border-[#ffac00] hover:shadow-md transition-all group"
            >
              <h2 className="text-lg font-semibold text-gray-900 group-hover:text-[#ffac00] transition-colors">
                Personal Details
              </h2>
              <p className="text-sm text-gray-500 mt-2">
                View and update your personal information, address, and contact details.
              </p>
            </Link>

            {/* Order History Card */}
            <Link 
              to="/profile/orders"
              className="block p-6 bg-gray-50 rounded-lg border border-gray-200 hover:border-[#ffac00] hover:shadow-md transition-all group"
            >
              <h2 className="text-lg font-semibold text-gray-900 group-hover:text-[#ffac00] transition-colors">
                Order History
              </h2>
              <p className="text-sm text-gray-500 mt-2">
                Track current orders and view details of your past purchases.
              </p>
            </Link>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Profile