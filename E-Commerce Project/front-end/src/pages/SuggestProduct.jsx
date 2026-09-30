import { Link } from 'react-router-dom'

function SuggestProduct() {
  return (
    <div className="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-2xl mx-auto bg-white p-8 rounded-lg shadow-sm border border-gray-200">
        <h1 className="text-3xl font-bold text-gray-900 mb-4">Suggest a Product or Livestock Category</h1>
        <p className="text-gray-600 mb-6 text-sm">
          Looking for a specific breed, feed type, or farm equipment not currently listed? Let us know what you need and our sourcing team will follow up.
        </p>
        <div className="p-4 bg-amber-50 border border-amber-200 rounded-md mb-6 text-sm text-amber-900">
          Email your requests and specifications to{' '}
          <a href="mailto:requests@weaner.com" className="font-bold text-[#ffac00] hover:underline">
            requests@weaner.com
          </a>.
        </div>
        <Link to="/" className="text-sm font-medium text-[#ffac00] hover:underline">
          &larr; Back to Home
        </Link>
      </div>
    </div>
  )
}

export default SuggestProduct