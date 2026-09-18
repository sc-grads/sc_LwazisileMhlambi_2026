import { useState, useEffect } from 'react'

function AdminProducts() {
  const [products, setProducts] = useState([])
  const [categories, setCategories] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  // Modal / Form state for Add/Update
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [isEditing, setIsEditing] = useState(false)
  const [currentProductId, setCurrentProductId] = useState(null)
  
  const [formData, setFormData] = useState({
    product_name: '',
    current_price: '',
    previous_price: '',
    in_stock: '',
    product_picture: '',
    flash_sale: false,
    category_id: ''
  })
  const [formError, setFormError] = useState('')

  useEffect(() => {
    document.title = 'Manage Products | WeanerMart Admin'
    fetchProducts()
    fetchCategories()
  }, [])

  const fetchProducts = async () => {
    try {
      const response = await fetch('http://127.0.0.1:5001/api/products')
      const data = await response.json()
      if (!response.ok) throw new Error(data.error || 'Failed to fetch products')
      setProducts(data)
    } catch (err) {
      setError('Could not connect to server to load products.')
    } finally {
      setLoading(false)
    }
  }

  const fetchCategories = async () => {
    try {
      const response = await fetch('http://127.0.0.1:5001/api/categories') // Adjust if your category route differs
      const data = await response.json()
      if (response.ok) setCategories(data)
    } catch (err) {
      console.error('Failed to fetch categories for dropdown')
    }
  }

  const handleOpenAddModal = () => {
    setIsEditing(false)
    setCurrentProductId(null)
    setFormData({
      product_name: '',
      current_price: '',
      previous_price: '',
      in_stock: '',
      product_picture: '',
      flash_sale: false,
      category_id: categories.length > 0 ? categories[0].id : ''
    })
    setFormError('')
    setIsModalOpen(true)
  }

  const handleOpenEditModal = (product) => {
    setIsEditing(true)
    setCurrentProductId(product.id)
    setFormData({
      product_name: product.product_name,
      current_price: product.current_price,
      previous_price: product.previous_price,
      in_stock: product.in_stock,
      product_picture: product.product_picture,
      flash_sale: product.flash_sale || false,
      category_id: product.category_id || ''
    })
    setFormError('')
    setIsModalOpen(true)
  }

  const handleFormSubmit = async (e) => {
    e.preventDefault()
    setFormError('')
    const token = localStorage.getItem('token')

    const payload = {
      product_name: formData.product_name,
      current_price: parseFloat(formData.current_price),
      previous_price: parseFloat(formData.previous_price),
      in_stock: parseInt(formData.in_stock, 10),
      product_picture: formData.product_picture,
      flash_sale: Boolean(formData.flash_sale),
      category_id: formData.category_id ? parseInt(formData.category_id, 10) : null
    }

    const url = isEditing 
      ? `http://127.0.0.1:5001/api/admin/products/${currentProductId}`
      : 'http://127.0.0.1:5001/api/admin/products'
    
    const method = isEditing ? 'PUT' : 'POST'

    try {
      const response = await fetch(url, {
        method: method,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        },
        body: JSON.stringify(payload)
      })

      const data = await response.json()
      if (!response.ok) {
        setFormError(data.error || 'Failed to save product')
        return
      }

      setIsModalOpen(false)
      fetchProducts() // Refresh list
    } catch (err) {
      setFormError('Network error while saving product.')
    }
  }

  const handleDelete = async (id) => {
    if (!window.confirm('Are you sure you want to delete this product?')) return

    try {
      const token = localStorage.getItem('token')
      const response = await fetch(`http://127.0.0.1:5001/api/admin/products/${id}`, {
        method: 'DELETE',
        headers: {
          'Authorization': `Bearer ${token}`
        }
      })

      if (!response.ok) {
        const data = await response.json()
        alert(data.error || 'Failed to delete product (Status: ${response.status})')
        return
      }

      setProducts(products.filter(p => p.id !== id))
    } catch (err) {
      alert('Could not connect to server to delete product.')
    }
  }

  return (
    <div className="min-h-screen bg-gray-50 py-10 px-4 sm:px-6 lg:px-8">
      <div className="max-w-7xl mx-auto">
        
        {/* Header and Add Action */}
        <div className="flex justify-between items-center mb-8">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Manage Products</h1>
            <p className="text-sm text-gray-500 mt-1">View and manage all products</p>
          </div>
          <button 
            onClick={handleOpenAddModal}
            className="bg-[#ffac00] text-white font-medium px-4 py-2 rounded-md hover:bg-[#e09800] transition-colors shadow-sm"
          >
            + Add New Product
          </button>
        </div>

        {loading && <p className="text-center text-gray-500 py-20">Loading inventory...</p>}
        {error && <p className="text-center text-red-600 py-20">{error}</p>}

        {/* Products Table */}
        {!loading && !error && (
          <div className="bg-white shadow-sm rounded-lg overflow-hidden border border-gray-200">
            {products.length === 0 ? (
              <p className="text-center text-gray-500 py-12">No products found.</p>
            ) : (
              <div className="divide-y divide-gray-200">
                {products.map((product) => {
                  const isAvailable = product.in_stock > 0;
                  return (
                    <div key={product.id} className="flex items-center justify-between p-4 sm:px-6 hover:bg-gray-50/50 transition-colors">
                      
                      {/* Picture & Name */}
                      <div className="flex items-center space-x-4 min-w-0 flex-1">
                        <div className="w-16 h-16 bg-gray-100 rounded-md overflow-hidden flex-shrink-0 flex items-center justify-center border border-gray-100">
                          <img 
                            src={product.product_picture} 
                            alt={product.product_name} 
                            className="w-full h-full object-contain p-1 mix-blend-multiply"
                          />
                        </div>
                        <div className="min-w-0 flex-1">
                          <h3 className="text-gray-900 font-medium text-base truncate">
                            {product.product_name}
                          </h3>
                          <span className="text-xs text-gray-400 block mt-0.5">ID: {product.id}</span>
                        </div>
                      </div>

                      {/* Status, Stock, Price */}
                      <div className="flex items-center space-x-8 sm:space-x-12 px-4 flex-shrink-0">
                        <div className="hidden md:flex items-center space-x-1.5 text-sm">
                          {/* <span className={`w-2 h-2 rounded-full ${isAvailable ? 'bg-green-500' : 'bg-red-500'}`}></span> 
                          <span className={isAvailable ? 'text-gray-700 font-medium' : 'text-red-600 font-medium'}>
                            {isAvailable ? 'Available' : 'Disabled'}
                          </span> */}
                        </div>

                        <div className="text-sm font-semibold text-gray-700 w-12 text-right">
                          <span className="text-xs text-gray-400 block font-normal">Stock</span>
                          {product.in_stock}
                        </div>

                        <div className="text-sm font-bold text-gray-900 w-24 text-right">
                          <span className="text-xs text-gray-400 block font-normal">Price</span>
                          R{product.current_price.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                        </div>
                      </div>

                      {/* Actions */}
                      <div className="flex items-center space-x-2 flex-shrink-0 pl-4 border-l border-gray-100">
                        <button
                          onClick={() => handleOpenEditModal(product)}
                          className="px-3 py-1.5 text-xs font-medium text-blue-600 bg-blue-50 rounded-md hover:bg-blue-100 transition-colors"
                        >
                          Update
                        </button>
                        <button
                          onClick={() => handleDelete(product.id)}
                          className="px-3 py-1.5 text-xs font-medium text-red-600 bg-red-50 rounded-md hover:bg-red-100 transition-colors"
                        >
                          Delete
                        </button>
                      </div>

                    </div>
                  )
                })}
              </div>
            )}
          </div>
        )}

        {/* Add / Edit Product Modal */}
        {isModalOpen && (
          <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
            <div className="bg-white rounded-lg max-w-lg w-full p-6 shadow-xl max-h-[90vh] overflow-y-auto">
              <h2 className="text-xl font-bold text-gray-900 mb-4">
                {isEditing ? 'Update Product' : 'Add New Product'}
              </h2>

              {formError && <div className="mb-4 text-sm text-red-600 bg-red-50 p-2 rounded">{formError}</div>}

              <form onSubmit={handleFormSubmit} className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700">Product Name</label>
                  <input 
                    type="text" 
                    required
                    value={formData.product_name}
                    onChange={(e) => setFormData({...formData, product_name: e.target.value})}
                    className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 text-sm"
                  />
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700">Current Price (R)</label>
                    <input 
                      type="number" 
                      step="0.01" 
                      required
                      value={formData.current_price}
                      onChange={(e) => setFormData({...formData, current_price: e.target.value})}
                      className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 text-sm"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700">Previous Price (R)</label>
                    <input 
                      type="number" 
                      step="0.01" 
                      required
                      value={formData.previous_price}
                      onChange={(e) => setFormData({...formData, previous_price: e.target.value})}
                      className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 text-sm"
                    />
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700">Stock Quantity</label>
                    <input 
                      type="number" 
                      required
                      value={formData.in_stock}
                      onChange={(e) => setFormData({...formData, in_stock: e.target.value})}
                      className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 text-sm"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700">Category</label>
                    <select
                      value={formData.category_id}
                      onChange={(e) => setFormData({...formData, category_id: e.target.value})}
                      className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 text-sm bg-white"
                    >
                      <option value="">Select Category</option>
                      {categories.map((cat) => (
                        <option key={cat.id} value={cat.id}>{cat.name || cat.category_name}</option>
                      ))}
                    </select>
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700">Product Picture Path / URL</label>
                  <input 
                    type="text" 
                    required
                    placeholder="/images/chicken-tractor-400x400.jpg"
                    value={formData.product_picture}
                    onChange={(e) => setFormData({...formData, product_picture: e.target.value})}
                    className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 text-sm"
                  />
                </div>

                <div className="flex items-center space-x-2">
                  <input 
                    type="checkbox" 
                    id="flash_sale"
                    checked={formData.flash_sale}
                    onChange={(e) => setFormData({...formData, flash_sale: e.target.checked})}
                    className="h-4 w-4 text-[#ffac00] border-gray-300 rounded"
                  />
                  <label htmlFor="flash_sale" className="text-sm font-medium text-gray-700">Flash Sale Item</label>
                </div>

                <div className="flex justify-end space-x-3 pt-4 border-t border-gray-100">
                  <button 
                    type="button" 
                    onClick={() => setIsModalOpen(false)}
                    className="px-4 py-2 border border-gray-300 text-gray-700 rounded-md text-sm hover:bg-gray-50"
                  >
                    Cancel
                  </button>
                  <button 
                    type="submit" 
                    className="px-4 py-2 bg-[#ffac00] text-white rounded-md text-sm hover:bg-[#e09800]"
                  >
                    {isEditing ? 'Save Changes' : 'Create Product'}
                  </button>
                </div>
              </form>
            </div>
          </div>
        )}

      </div>
    </div>
  )
}

export default AdminProducts