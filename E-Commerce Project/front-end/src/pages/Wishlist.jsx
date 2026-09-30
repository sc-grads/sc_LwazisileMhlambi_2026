import { useState, useEffect } from 'react'
import { Link, useNavigate } from 'react-router-dom'

function Wishlist() {
  const navigate = useNavigate()
  const [wishlistItems, setWishlistItems] = useState([])
  const [loading, setLoading] = useState(true)
  const [message, setMessage] = useState({ type: '', text: '' })

  useEffect(() => {
    document.title = 'My Wishlist | WeanerMart'
    checkAuthAndFetchWishlist()
  }, [])

  const checkAuthAndFetchWishlist = async () => {
    const token = localStorage.getItem('token')
    if (!token) {
      navigate('/login')
      return
    }

    try {
      const response = await fetch('http://127.0.0.1:5001/api/wishlist', {
        headers: { 'Authorization': `Bearer ${token}` }
      })
      const data = await response.json()
      if (!response.ok) throw new Error(data.error || 'Failed to fetch wishlist')
      setWishlistItems(data)
    } catch (err) {
      setMessage({ type: 'error', text: 'Could not load your wishlist items.' })
    } finally {
      setLoading(false)
    }
  }

  const handleRemoveItem = async (wishlistId) => {
    try {
      const token = localStorage.getItem('token')
      const response = await fetch(`http://127.0.0.1:5001/api/wishlist/${wishlistId}`, {
        method: 'DELETE',
        headers: { 'Authorization': `Bearer ${token}` }
      })
      const data = await response.json()
      if (!response.ok) throw new Error(data.error || 'Failed to remove item')

      setWishlistItems((prev) => prev.filter(item => item.id !== wishlistId))
      setMessage({ type: 'success', text: 'Item removed from wishlist.' })

      // Dispatch event to update navbar counts in real time
      window.dispatchEvent(new Event('wishlistUpdated'))
    } catch (err) {
      setMessage({ type: 'error', text: err.message || 'Error removing item.' })
    }
  }

  const handleAddAllToCart = async () => {
    try {
      const token = localStorage.getItem('token')
      const response = await fetch('http://127.0.0.1:5001/api/wishlist/add-all-to-cart', {
        method: 'POST',
        headers: { 'Authorization': `Bearer ${token}` }
      })
      const data = await response.json()
      if (!response.ok) throw new Error(data.error || 'Failed to add items to cart')

      setWishlistItems([])
      setMessage({ type: 'success', text: 'All wishlist items have been added to your cart!' })

      window.dispatchEvent(new Event('cartUpdated'))
      window.dispatchEvent(new Event('wishlistUpdated'))
    } catch (err) {
      setMessage({ type: 'error', text: err.message || 'Error moving wishlist items to cart.' })
    }
  }

  const handleAddToCart = async (wishlistId, productId) => {
    try {
      const token = localStorage.getItem('token')
      
      // 1. Add item to cart backend endpoint
      const cartResponse = await fetch('http://127.0.0.1:5001/api/cart', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        },
        body: JSON.stringify({ product_id: productId, quantity: 1 })
      })
      const cartData = await cartResponse.json()
      if (!cartResponse.ok) throw new Error(cartData.error || 'Failed to add item to cart')

      // 2. Remove item from backend wishlist database
      const wishlistResponse = await fetch(`http://127.0.0.1:5001/api/wishlist/${wishlistId}`, {
        method: 'DELETE',
        headers: { 'Authorization': `Bearer ${token}` }
      })
      if (!wishlistResponse.ok) {
        const wishlistData = await wishlistResponse.json()
        throw new Error(wishlistData.error || 'Item added to cart, but failed to remove from wishlist.')
      }

      // 3. Update local state and trigger navbar re-render events
      setWishlistItems((prev) => prev.filter(item => item.id !== wishlistId))
      setMessage({ type: 'success', text: 'Item added to your cart and removed from wishlist!' })

      window.dispatchEvent(new Event('cartUpdated'))
      window.dispatchEvent(new Event('wishlistUpdated'))
    } catch (err) {
      setMessage({ type: 'error', text: err.message || 'Error adding item to cart.' })
    }
  }

  if (loading) {
    return <div className="min-h-screen bg-gray-50 flex items-center justify-center text-gray-500">Loading wishlist...</div>
  }

  return (
    <div className="min-h-screen bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-4xl mx-auto">
        
        {/* Header Section */}
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between mb-8 pb-4 border-b border-gray-200">
          <div>
            <h1 className="text-3xl font-bold text-gray-900 tracking-tight">My Wishlist</h1>
            <p className="text-sm text-gray-500 mt-1">Manage your saved items or add them to your cart.</p>
          </div>
          <div className="flex items-center gap-3 mt-4 sm:mt-0">
            {wishlistItems.length > 0 && (
              <button
                onClick={handleAddAllToCart}
                className="bg-[#ffac00] hover:bg-[#e09800] text-white font-medium text-sm py-2.5 px-4 rounded-md shadow transition"
              >
                Add All To Cart
              </button>
            )}
          </div>
        </div>

        {message.text && (
          <div className={`p-4 mb-6 rounded-md text-sm ${message.type === 'error' ? 'bg-red-50 text-red-700 border border-red-200' : 'bg-green-50 text-green-700 border border-green-200'}`}>
            {message.text}
          </div>
        )}

        {wishlistItems.length === 0 ? (
          <div className="bg-white shadow-sm rounded-lg border border-gray-200 p-12 text-center">
            <p className="text-gray-500 text-lg mb-4">Your wishlist is currently empty.</p>
            <Link
              to="/products"
              className="inline-block bg-[#ffac00] text-white font-medium text-sm py-2.5 px-6 rounded-md hover:bg-[#e09800] transition"
            >
              Explore Products
            </Link>
          </div>
        ) : (
          <div className="space-y-4">
            {wishlistItems.map((item) => {
              const product = item.product || {}
              const itemPrice = product.current_price ?? product.price ?? item.current_price ?? item.price ?? 0
              const imageUrl = product.product_picture || item.product_picture || 'https://via.placeholder.com/150'
              const productName = product.product_name || item.product_name || 'Product'
              const productId = product.id || item.product_id
              const inStock = product.in_stock ?? item.in_stock ?? 1

              return (
                <div 
                  key={item.id} 
                  className="bg-white shadow-sm rounded-lg border border-gray-200 p-6 flex flex-col sm:flex-row items-center justify-between gap-6 transition hover:shadow-md"
                >
                  {/* Product Image & Info */}
                  <div className="flex items-center space-x-4 w-full sm:w-auto">
                    <div className="w-20 h-20 bg-gray-100 rounded-md overflow-hidden flex-shrink-0 flex items-center justify-center p-2">
                      <img 
                        src={imageUrl} 
                        alt={productName} 
                        className="w-full h-full object-contain mix-blend-multiply"
                      />
                    </div>
                    <div>
                      <Link to={`/products/${productId}`} className="text-lg font-medium text-gray-900 hover:text-[#ffac00] transition">
                        {productName}
                      </Link>
                      <p className="text-green-600 font-semibold mt-1">
                        R{Number(itemPrice).toFixed(2)}
                      </p>
                      <span className={`inline-block text-xs px-2 py-0.5 rounded mt-1 font-medium ${inStock > 0 ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`}>
                        {inStock > 0 ? 'In Stock' : 'Out of Stock'}
                      </span>
                    </div>
                  </div>

                  {/* Actions */}
                  <div className="flex items-center space-x-3 w-full sm:w-auto justify-end border-t sm:border-t-0 pt-4 sm:pt-0 border-gray-100">
                    <button
                      onClick={() => handleAddToCart(item.id, productId)}
                      disabled={inStock <= 0}
                      className="px-4 py-2 bg-green-600 hover:bg-green-700 text-white text-sm font-medium rounded-md transition text-center disabled:opacity-50"
                    >
                      Add to Cart
                    </button>
                    <button
                      onClick={() => handleRemoveItem(item.id)}
                      className="px-4 py-2 border border-red-300 text-red-600 hover:bg-red-50 text-sm font-medium rounded-md transition text-center"
                    >
                      Remove
                    </button>
                  </div>
                </div>
              )
            })}
          </div>
        )}

      </div>
    </div>
  )
}

export default Wishlist