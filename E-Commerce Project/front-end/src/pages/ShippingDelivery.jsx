import { Link } from 'react-router-dom'

function ShippingDelivery() {
  return (
    <div className="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-3xl mx-auto bg-white p-8 rounded-lg shadow-sm border border-gray-200">
        <h1 className="text-3xl font-bold text-gray-900 mb-4">Shipping & Delivery Logistics</h1>
        <div className="space-y-4 text-sm text-gray-700 leading-relaxed mb-6">
          <p>
            All livestock transports are handled by vetted, biosecurity-compliant logistics partners specializing in humane animal transport across South Africa.
          </p>
          <ul className="list-disc list-inside space-y-2 pl-2">
            <li><strong>Delivery Fees:</strong> Flat R250.00 standard delivery fee per order.</li>
            <li><strong>Dispatch Times:</strong> Dispatches are scheduled within 2-4 business days following payment confirmation.</li>
            <li><strong>Tracking:</strong> Real-time status updates are provided via your account order dashboard.</li>
          </ul>
        </div>
        <Link to="/" className="text-sm font-medium text-[#ffac00] hover:underline">
          &larr; Back to Home
        </Link>
      </div>
    </div>
  )
}

export default ShippingDelivery