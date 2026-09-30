import { Link } from 'react-router-dom'

function PrivacyPolicy() {
  return (
    <div className="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-4xl mx-auto bg-white p-8 sm:p-10 rounded-lg shadow-sm border border-gray-200">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">Privacy Policy</h1>
        <p className="text-xs text-gray-400 mb-6">Last updated: September 2026</p>

        <div className="space-y-6 text-sm text-gray-700 leading-relaxed">
          <p>
            At WeanerMart, we value your privacy and are committed to protecting your personal information in accordance with the Protection of Personal Information Act (POPIA).
          </p>

          <section className="space-y-2">
            <h2 className="text-base font-semibold text-gray-900">1. Information We Collect</h2>
            <p>We collect personal information necessary to process your orders and facilitate transport. This includes:</p>
            <ul className="list-disc list-inside space-y-1 pl-2">
              <li>Full name, email address, and phone number</li>
              <li>Delivery address and farm details</li>
              <li>Payment references (processed securely via Paystack)</li>
            </ul>
          </section>

          <section className="space-y-2">
            <h2 className="text-base font-semibold text-gray-900">2. How We Use Your Data</h2>
            <p>Your data is used strictly for fulfilling orders, managing logistics with our transport partners, sending transaction updates, and improving our services. We do not sell your personal data to third parties.</p>
          </section>

          <section className="space-y-2">
            <h2 className="text-base font-semibold text-gray-900">3. Third-Party Services</h2>
            <p>We work with trusted third-party providers (such as Paystack for payments and registered delivery drivers for logistics). They only receive information necessary to complete their specific services.</p>
          </section>

          <section className="space-y-2">
            <h2 className="text-base font-semibold text-gray-900">4. Contact Us</h2>
            <p>If you have any questions regarding your personal data, please reach out to us at <a href="mailto:support@weaner.com" className="text-[#ffac00] hover:underline">support@weaner.com</a>.</p>
          </section>
        </div>

        <div className="mt-8 pt-6 border-t border-gray-200">
          <Link to="/" className="text-sm font-medium text-[#ffac00] hover:underline">
            &larr; Back to Home
          </Link>
        </div>
      </div>
    </div>
  )
}

export default PrivacyPolicy