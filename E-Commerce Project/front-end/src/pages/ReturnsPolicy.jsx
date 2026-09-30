import { Link } from 'react-router-dom'

function ReturnsPolicy() {
  return (
    <div className="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-4xl mx-auto bg-white p-8 sm:p-10 rounded-lg shadow-sm border border-gray-200">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">Returns & Cancellation Policy</h1>
        <p className="text-xs text-gray-400 mb-6">Effective Date: Immediate</p>

        <div className="space-y-6 text-sm text-gray-700 leading-relaxed">
          <div className="p-4 bg-red-50 border-l-4 border-red-500 text-red-900 rounded-r-md">
            <h2 className="font-bold text-base mb-1">Important Notice Regarding Livestock</h2>
            <p className="text-sm">
              Due to strict biosecurity, health, and animal welfare regulations, <strong>no returns, exchanges, or refunds</strong> are permitted once livestock has departed our facility or is out on delivery.
            </p>
          </div>

          <section className="space-y-2">
            <h2 className="text-base font-semibold text-gray-900">1. Incorrect Item Delivered</h2>
            <p>
              If the delivered livestock does not match your order specifications (e.g., incorrect breed, age group, or quantity), you must notify the delivery driver <strong>at the time of offloading</strong> before signing the delivery acceptance form.
            </p>
            <p>
              In such cases, please take clear photos/documentation and email us within <strong>2 hours</strong> at <a href="mailto:support@weaner.com" className="text-[#ffac00] font-medium hover:underline">support@weaner.com</a>. We will arrange a replacement or issue a full refund for the mismatched portion.
            </p>
          </section>

          <section className="space-y-2">
            <h2 className="text-base font-semibold text-gray-900">2. Order Cancellations</h2>
            <p>
              You may cancel your order for a full refund up to <strong>24 hours prior</strong> to the scheduled dispatch date. Once livestock is prepped or dispatched for transport, cancellations are non-refundable.
            </p>
          </section>

          <section className="space-y-2">
            <h2 className="text-base font-semibold text-gray-900">3. Non-Livestock Items</h2>
            <p>
              For dry goods, feeds, or farm supplies, returns are accepted within 7 days of delivery provided items remain unopened and in their original packaging. Return transport fees apply.
            </p>
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

export default ReturnsPolicy