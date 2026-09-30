import { Link } from 'react-router-dom'

function About() {
  return (
    <div className="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-3xl mx-auto bg-white p-8 rounded-lg shadow-sm border border-gray-200">
        <h1 className="text-3xl font-bold text-gray-900 mb-4">About WeanerMart</h1>
        <p className="text-gray-600 mb-4 leading-relaxed">
          WeanerMart is South Africa’s dedicated online marketplace connecting livestock farmers, breeders, and commercial buyers directly with trusted weaner producers.
        </p>
        <p className="text-gray-600 mb-6 leading-relaxed">
          Our platform simplifies livestock sourcing by streamlining catalog browsing, order fulfillment, biosecure transport logistics, and secure payment processing.
        </p>
        <Link to="/" className="text-sm font-medium text-[#ffac00] hover:underline">
          &larr; Back to Home
        </Link>
      </div>
    </div>
  )
}

export default About