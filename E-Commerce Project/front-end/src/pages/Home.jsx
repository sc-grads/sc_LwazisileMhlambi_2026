import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import heroImage from '../assets/cows-road.jpg'

function Home() {
  const [featuredProducts, setFeaturedProducts] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    document.title = 'Home | WeanerMart'

    const fetchFeaturedProducts = async () => {
      try {
        const response = await fetch('http://127.0.0.1:5001/api/products')
        const data = await response.json()
        if (response.ok) {
          // Filter to get products with IDs 1, 2, and 3
          const featured = data.filter(product => [1, 2, 3].includes(product.id))
          setFeaturedProducts(featured.length > 0 ? featured : data.slice(0, 3))
        }
      } catch (err) {
        console.error('Error fetching featured products:', err)
      } finally {
        setLoading(false)
      }
    }

    fetchFeaturedProducts()
  }, [])

  return (
    <div className="min-h-screen bg-gray-50">
      
      {/* Hero Section */}
      <section className="relative bg-gray-900 text-white py-24 px-4 sm:px-6 lg:px-8 overflow-hidden">
        <div className="absolute inset-0 z-0">
          <img 
            src={heroImage} 
            alt="Cows on road" 
            className="w-full h-full object-cover opacity-35"
          />
         {/* <div className="absolute inset-0 bg-gradient-to-r from-gray-900 via-gray-900/80 to-transparent"></div> */}
        </div>

        <div className="relative z-10 max-w-4xl mx-auto text-center sm:text-left">
          <span className="inline-block bg-[#ffac00] text-white text-xs font-bold uppercase tracking-widest px-3 py-1 rounded-xl mb-4">
            Wean the market with WeanerMart
          </span>
          <h1 className="text-4xl sm:text-6xl font-extrabold tracking-tight text-white mb-4">
            Welcome to WeanerMart
          </h1>
          <p className="text-lg sm:text-xl text-gray-300 max-w-2xl mb-8">
            Your #1 market to find weaned and ready to breed animals... and also much need farming stuff.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center sm:justify-start">
            <Link
              to="/products"
              className="bg-[#ffac00] hover:bg-[#e09800] text-white font-bold py-3 px-8 rounded-md transition shadow-md text-center"
            >
              Browse Our Products
            </Link>
          </div>
        </div>
      </section>

      {/* Featured Products Section */}
      <section className="max-w-7xl mx-auto py-16 px-4 sm:px-6 lg:px-8">
        <div className="flex flex-col sm:flex-row sm:items-end sm:justify-between mb-10 pb-4 border-b border-gray-200">
          <div>
            <h2 className="text-3xl font-bold text-gray-900 tracking-tight">Featured Items</h2>
            <p className="text-sm text-gray-500 mt-1">Explore top-quality farming products.</p>
          </div>
          <Link
            to="/products"
            className="mt-4 sm:mt-0 text-[#ffac00] hover:text-[#e09800] font-semibold text-sm flex items-center gap-1 transition"
          >
            View All Products &rarr;
          </Link>
        </div>

        {loading ? (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
            {[1, 2, 3].map((n) => (
              <div key={n} className="bg-white rounded-lg p-4 animate-pulse border border-gray-200">
                <div className="bg-gray-200 aspect-square rounded-md mb-4"></div>
                <div className="bg-gray-200 h-4 rounded w-3/4 mb-2"></div>
                <div className="bg-gray-200 h-4 rounded w-1/2"></div>
              </div>
            ))}
          </div>
        ) : (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
            {featuredProducts.map((product) => (
              <div
                key={product.id}
                className="bg-white rounded-lg border border-gray-200 shadow-sm overflow-hidden flex flex-col justify-between transition hover:shadow-md"
              >
                <div>
                  {/* Square container using product_picture */}
                  <div className="w-full aspect-square bg-white-100 overflow-hidden flex items-center justify-center p-4">
                    <img
                      src={product.product_picture || 'https://via.placeholder.com/400'}
                      alt={product.product_name}
                      className="w-full h-full object-contain mix-blend-multiply"
                    />
                  </div>
                  <div className="p-6">
                    {/* Updated property to product_name */}
                    <h3 className="text-lg font-bold text-gray-900 mb-1">{product.product_name}</h3>
                    <p className="text-xs text-gray-500 mb-4 line-clamp-2">{product.description}</p>
                    <p className="text-2xl font-extrabold text-gray-900">
                      R{Number(product.current_price).toFixed(2)}
                    </p>
                  </div>
                </div>

                <div className="px-6 pb-6 pt-0">
                  <Link
                    to={`/products/${product.id}`}
                    className="block w-full text-center bg-[#ffac00] hover:bg-[#e09800] text-white text-sm font-semibold py-2.5 rounded-md transition"
                  >
                    View Details
                  </Link>
                </div>
              </div>
            ))}
          </div>
        )}

      </section>

    </div>
  )
}

export default Home