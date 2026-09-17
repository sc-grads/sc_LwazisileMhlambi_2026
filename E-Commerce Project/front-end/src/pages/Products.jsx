import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'

function Products() {
  const [products, setProducts] = useState([])
  const [selectedCategory, setSelectedCategory] = useState('ALL')
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    document.title = 'Products | WeanerMart'
    fetchProducts()
  }, [])

  const fetchProducts = async () => {
    try {
      const response = await fetch('http://127.0.0.1:5001/api/products')
      const data = await response.json()
      if (!response.ok) {
        throw new Error(data.error || 'Failed to fetch products')
      }
      setProducts(data)
    } catch (err) {
      setError('Could not connect to the server to load products.')
    } finally {
      setLoading(false)
    }
  }

  // Dynamically extract unique categories from the fetched products data
  const dynamicCategories = [
    { id: 'ALL', name: 'ALL' },
    ...Array.from(
      new Map(
        products.map(p => [p.category_id, { id: p.category_id, name: p.category_name.toUpperCase() }])
      ).values()
    )
  ]

  // Filter products based on selected category tab
  const filteredProducts = selectedCategory === 'ALL' 
    ? products 
    : products.filter(p => p.category_id === selectedCategory)

  return (
    <div className="min-h-screen bg-white py-10 px-4 sm:px-6 lg:px-8">
      <div className="max-w-7xl mx-auto">
        
        {/* Header Section */}
        <div className="text-center mb-10">
          <span className="text-[#ffac00] font-medium text-sm tracking-widest uppercase block mb-1 font-serif bold">
            Recently Added
          </span>
          <h1 className="text-4xl font-extrabold text-gray-900 tracking-tight">
            Latest Products
          </h1>

          {/* Dynamic Category Filter Navigation */}
          {!loading && !error && (
            <div className="flex flex-wrap justify-center items-center gap-6 mt-6 text-sm font-semibold tracking-wide">
              {dynamicCategories.map((cat) => (
                <button
                  key={cat.id}
                  onClick={() => setSelectedCategory(cat.id)}
                  className={`pb-1 transition-colors ${
                    selectedCategory === cat.id
                      ? 'text-gray-900 border-b-2 border-gray-900'
                      : 'text-gray-400 hover:text-gray-700'
                  }`}
                >
                  {cat.name}
                </button>
              ))}
            </div>
          )}
        </div>

        {/* Loading / Error States */}
        {loading && <p className="text-center text-gray-500 py-20">Loading products...</p>}
        {error && <p className="text-center text-red-600 py-20">{error}</p>}

        {/* Products Grid */}
        {!loading && !error && (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
            {filteredProducts.length === 0 ? (
              <p className="col-span-full text-center text-gray-500 py-12">No products found in this category.</p>
            ) : (
              filteredProducts.map((product) => (
                <div key={product.id} className="group flex flex-col">
                  
                  {/* Image Card Container */}
                  <div className="relative bg-[#f8f8f8] rounded-xl overflow-hidden aspect-square flex items-center justify-center p-6 shadow-sm hover:shadow-md transition-shadow">
                    <img 
                      src={product.product_picture} 
                      alt={product.product_name} 
                      className="w-full h-full object-contain mix-blend-multiply group-hover:scale-105 transition-transform duration-300"
                    />

                    {/* Quick Action Buttons (Wishlist & Cart overlay on hover) */}
                    {/*}
                    <div className="absolute inset-0 bg-black/5 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center space-x-3">
                      <button 
                        aria-label="Add to Wishlist"
                        className="w-10 h-10 bg-black text-white rounded-full flex items-center justify-center shadow hover:bg-[#ffac00] transition-colors"
                      >
                        <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" />
                        </svg>
                      </button>
                      <button 
                        aria-label="Add to Cart"
                        className="w-10 h-10 bg-black text-white rounded-full flex items-center justify-center shadow hover:bg-[#ffac00] transition-colors"
                      >
                        <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
                        </svg>
                      </button>
                    </div>
                    */}

                    {/* Optional Flash Sale Badge */}
                    {product.flash_sale && (
                      <span className="absolute top-3 left-3 bg-[#ffac00] text-white text-xs font-bold px-2.5 py-1 rounded">
                        SALE
                      </span>
                    )}
                  </div>

                  {/* Product Details info */}
                  <div className="text-center mt-4">
                    <h3 className="text-gray-900 font-medium text-lg">
                      {product.product_name}
                    </h3>
                    <div className="mt-1 flex items-center justify-center space-x-2">
                      <span className="text-green-600 font-semibold">
                        R{product.current_price.toFixed(2)}
                      </span>
                      {product.previous_price > product.current_price && (
                        <span className="text-gray-400 line-through text-sm">
                          R{product.previous_price.toFixed(2)}
                        </span>
                      )}
                    </div>
                  </div>

                </div>
              ))
            )}
          </div>
        )}

      </div>
    </div>
  )
}

export default Products