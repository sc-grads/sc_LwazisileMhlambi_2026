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
          <span className="text-[#ffac00] font-medium text-sm tracking-widest uppercase block mb-1 font-serif">
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
                // Wrapped the entire card in a Link to route to /products/:id
                <Link 
                  key={product.id} 
                  to={`/products/${product.id}`}
                  className="group flex flex-col focus:outline-none"
                >
                  
                  {/* Image Card Container */}
                   <div className="relative bg-[#f8f8f8] rounded-xl overflow-hidden aspect-square flex items-center justify-center p-6 shadow-sm group-hover:shadow-md transition-shadow"> 
                    <img 
                      src={product.product_picture} 
                      alt={product.product_name} 
                      className="w-full h-full object-contain mix-blend-multiply group-hover:scale-105 transition-transform duration-300"
                    />

                    {/* Optional Flash Sale Badge */}
                    {product.flash_sale && (
                      <span className="absolute top-3 left-3 bg-[#ffac00] text-white text-xs font-bold px-2.5 py-1">
                        SALE
                      </span>
                    )}
                  </div>

                  {/* Product Details info */}
                  <div className="text-center mt-4">
                    <h3 className="text-gray-900 font-medium text-lg group-hover:text-[#ffac00] transition-colors">
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

                </Link>
              ))
            )}
          </div>
        )}

      </div>
    </div>
  )
}

export default Products