import { useState, useEffect } from 'react'
import { useParams, Link, useNavigate } from 'react-router-dom'

function ProductDetail() {
  const { id } = useParams()
  const navigate = useNavigate()
  
  const [product, setProduct] = useState(null)
  const [quantity, setQuantity] = useState(1)
  const [loading, setLoading] = useState(true)
  const [message, setMessage] = useState({ type: '', text: '' })

  useEffect(() => {
    fetchProductDetails()
  }, [id])

  const fetchProductDetails = async () => {
    try {
      const response = await fetch(`http://127.0.0.1:5001/api/products/${id}`)
      const data = await response.json()
      if (!response.ok) throw new Error(data.error || 'Failed to load product')
      setProduct(data)
      document.title = `${data.product_name} | WeanerMart`
    } catch (err) {
      setMessage({ type: 'error', text: 'Could not load product details.' })
    } finally {
      setLoading(false)
    }
  }

  const handleQuantityChange = (delta) => {
    setQuantity((prev) => {
      const newQty = prev + delta
      return newQty < 1 ? 1 : newQty
    })
  }

  const handleAddToCart = async () => {
    try {
      const token = localStorage.getItem('token')
      if (!token) {
        navigate('/login')
        return
      }

      const response = await fetch('http://127.0.0.1:5001/api/cart', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        },
        body: JSON.stringify({ product_id: product.id, quantity: quantity })
      })

      const data = await response.json()
      if (!response.ok) throw new Error(data.error || 'Failed to add to cart')

      setMessage({ type: 'success', text: `Added ${quantity} ${product.product_name}(s) to your cart!` })
    } catch (err) {
      setMessage({ type: 'error', text: err.message || 'Error adding to cart.' })
    }
  }

  const handleAddToWishlist = async () => {
    try {
      const token = localStorage.getItem('token')
      if (!token) {
        navigate('/login')
        return
      }

      const response = await fetch('http://127.0.0.1:5001/api/wishlist', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        },
        body: JSON.stringify({ product_id: product.id })
      })

      const data = await response.json()
      if (!response.ok) throw new Error(data.error || 'Failed to add to wishlist')

      setMessage({ type: 'success', text: `${product.product_name} added to your wishlist!` })
    } catch (err) {
      setMessage({ type: 'error', text: err.message || 'Error adding to wishlist.' })
    }
  }

  if (loading) {
    return <div className="min-h-screen bg-gray-50 flex items-center justify-center text-gray-500">Loading product...</div>
  }

  if (!product) {
    return <div className="min-h-screen bg-gray-50 flex items-center justify-center text-red-500">Product not found.</div>
  }

  return (
    <div className="min-h-screen bg-white py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-6xl mx-auto mb-8">
        <Link to="/products" className="text-mb font-medium text-[#ffac00] hover:underline">
          &larr; Back to Products
        </Link>
      </div>

      {message.text && (
        <div className={`max-w-6xl mx-auto p-4 mb-6 rounded-md text-sm ${message.type === 'error' ? 'bg-red-50 text-red-700 border border-red-200' : 'bg-green-50 text-green-700 border border-green-200'}`}>
          {message.text}
        </div>
      )}

      <div className="max-w-6xl mx-auto grid grid-cols-1 md:grid-cols-2 gap-12 items-start">
        {/* Product Image Card */}
        <div className="bg-gray-50 rounded-2xl p-8 border border-gray-100 flex items-center justify-center">
          <img
            src={product.product_picture || 'https://via.placeholder.com/500'}
            alt={product.product_name}
            className="w-full h-96 object-contain rounded-lg"
          />
        </div>

        {/* Product Details Section */}
        <div className="space-y-6">
          <div>
            <h1 className="text-4xl font-extrabold text-gray-900 tracking-tight">{product.product_name}</h1>
            <p className="text-2xl font-semibold text-green-600 mt-2">R{product.current_price.toFixed(2)}</p>
          </div>

          {/* Stock Display */}
          <div className="flex items-center space-x-2">
            <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${product.in_stock > 0 ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`}>
              {product.in_stock > 0 ? `${product.in_stock} in stock` : 'Out of stock'}
            </span>
          </div>

          <p className="text-gray-600 leading-relaxed text-base">
            {product.description || 'No detailed description available for this product yet.'}
          </p>

          {/* Quantity Selector */}
          <div className="flex items-center space-x-4 pt-2">
            <span className="text-sm font-medium text-gray-700">Choose Quantity</span>
            <div className="flex items-center border border-gray-300 rounded-md bg-white">
              <button
                onClick={() => handleQuantityChange(-1)}
                className="px-3 py-1.5 text-gray-600 hover:bg-gray-100 rounded-l-md transition"
              >
                -
              </button>
              <span className="px-4 py-1.5 text-gray-900 font-medium">{quantity}</span>
              <button
                onClick={() => handleQuantityChange(1)}
                className="px-3 py-1.5 text-gray-600 hover:bg-gray-100 rounded-r-md transition"
              >
                +
              </button>
            </div>
          </div>

          {/* Action Buttons */}
          <div className="flex flex-col sm:flex-row space-y-3 sm:space-y-0 sm:space-x-4 pt-4">
            <button
              onClick={handleAddToCart}
              disabled={product.in_stock <= 0}
              className="flex-1 bg-green-600 hover:bg-green-700 text-white font-medium py-3 px-6 rounded-lg shadow transition text-center disabled:opacity-50"
            >
              Add to Cart
            </button>

            <button
              onClick={handleAddToWishlist}
              className="flex-1 bg-[#ffac00] hover:bg-[#e09800] text-white font-medium py-3 px-6 rounded-lg shadow transition text-center"
            >
              Add to Wishlist
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}

export default ProductDetail