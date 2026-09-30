import { Link } from 'react-router-dom'

function DeliverForUs() {
  return (
    <div className="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-3xl mx-auto bg-white p-8 rounded-lg shadow-sm border border-gray-200">
        <h1 className="text-3xl font-bold text-gray-900 mb-4">Partner With Us: Deliver For WeanerMart</h1>
        <p className="text-gray-600 mb-6">
          We are always looking for reliable drivers and transport partners to help us deliver quality livestock safely and efficiently.
        </p>

        <div className="bg-amber-50 border border-amber-200 rounded-md p-6 mb-6">
          <h2 className="text-lg font-semibold text-gray-900 mb-2">How to Apply</h2>
          <p className="text-sm text-gray-700 mb-4">
            To register as a delivery partner, please send an email to{' '}
            <a href="mailto:deliver@weaner.com" className="font-bold text-[#ffac00] hover:underline">
              deliver@weaner.com
            </a>{' '}
            with the subject line <strong className="text-gray-900">"Delivery Partner Application - [Your Name]"</strong>.
          </p>
          
          <h3 className="text-sm font-semibold text-gray-900 uppercase tracking-wide mb-2">Required Supporting Documents:</h3>
          <ul className="list-disc list-inside text-sm text-gray-700 space-y-1.5">
            <li>Copy of your RSA ID or Passport</li>
            <li>Valid Driver’s License and Professional Driving Permit (PrDP)</li>
            <li>Vehicle Registration & Transport Readiness Documents</li>
            <li>Clean Criminal Record Check (not older than 3 months)</li>
            <li>Proof of Banking Details (Bank Confirmation Letter)</li>
            <li>Contact details and physical location / operating area</li>
          </ul>
        </div>

        <p className="text-xs text-gray-500 mb-6">
          Our logistics team reviews applications within 3-5 business days and will get in touch with you directly if your profile meets our current transport needs.
        </p>

        <Link to="/" className="inline-block text-sm font-medium text-[#ffac00] hover:underline">
          &larr; Back to Home
        </Link>
      </div>
    </div>
  )
}

export default DeliverForUs