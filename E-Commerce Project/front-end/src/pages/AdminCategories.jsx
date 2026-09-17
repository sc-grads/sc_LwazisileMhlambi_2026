import { useState, useEffect } from 'react'

function AdminCategories() {
  const [categories, setCategories] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  // Modal state
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [isEditing, setIsEditing] = useState(false)
  const [currentCategoryId, setCurrentCategoryId] = useState(null)
  const [categoryName, setCategoryName] = useState('')
  const [formError, setFormError] = useState('')

  useEffect(() => {
    document.title = 'Manage Categories | WeanerMart Admin'
    fetchCategories()
  }, [])

  const fetchCategories = async () => {
    try {
      const token = localStorage.getItem('token')
      const response = await fetch('http://127.0.0.1:5001/api/categories', {
        headers: { 'Authorization': `Bearer ${token}` }
      })
      const data = await response.json()
      if (!response.ok) throw new Error(data.error || 'Failed to fetch categories')
      setCategories(data)
    } catch (err) {
      setError('Could not connect to server to load categories.')
    } finally {
      setLoading(false)
    }
  }

  const handleOpenAddModal = () => {
    setIsEditing(false)
    setCurrentCategoryId(null)
    setCategoryName('')
    setFormError('')
    setIsModalOpen(true)
  }

  const handleOpenEditModal = (cat) => {
    setIsEditing(true)
    setCurrentCategoryId(cat.id)
    setCategoryName(cat.name)
    setFormError('')
    setIsModalOpen(true)
  }

  const handleFormSubmit = async (e) => {
    e.preventDefault()
    setFormError('')
    const token = localStorage.getItem('token')

    const url = isEditing 
      ? `http://127.0.0.1:5001/api/admin/categories/${currentCategoryId}`
      : 'http://127.0.0.1:5001/api/admin/categories'
    
    const method = isEditing ? 'PUT' : 'POST'

    try {
      const response = await fetch(url, {
        method: method,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        },
        body: JSON.stringify({ name: categoryName })
      })

      const data = await response.json()
      if (!response.ok) {
        setFormError(data.error || 'Failed to save category')
        return
      }

      setIsModalOpen(false)
      fetchCategories()
    } catch (err) {
      setFormError('Network error while saving category.')
    }
  }

  const handleDelete = async (id) => {
    if (!window.confirm('Are you sure you want to delete this category? Products associated to it may be affected.')) return

    try {
      const token = localStorage.getItem('token')
      const response = await fetch(`http://127.0.0.1:5001/api/admin/categories/${id}`, {
        method: 'DELETE',
        headers: { 'Authorization': `Bearer ${token}` }
      })

      const data = await response.json()
      if (!response.ok) {
        alert(data.error || `Failed to delete category (Status: ${response.status})`)
        return
      }

      setCategories(categories.filter(c => c.id !== id))
    } catch (err) {
      alert('Could not connect to server to delete category.')
    }
  }

  return (
    <div className="min-h-screen bg-gray-50 py-10 px-4 sm:px-6 lg:px-8">
      <div className="max-w-5xl mx-auto">
        
        {/* Header & Add Action */}
        <div className="flex justify-between items-center mb-8">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">Manage Product Categories</h1>
            <p className="text-sm text-gray-500 mt-1">Admin category control panel</p>
          </div>
          <button 
            onClick={handleOpenAddModal}
            className="bg-[#ffac00] text-white font-medium px-4 py-2 rounded-md hover:bg-[#e09800] transition-colors shadow-sm"
          >
            + Add New Category
          </button>
        </div>

        {loading && <p className="text-center text-gray-500 py-20">Loading categories...</p>}
        {error && <p className="text-center text-red-600 py-20">{error}</p>}

        {/* Categories List Table */}
        {!loading && !error && (
          <div className="bg-white shadow-sm rounded-lg overflow-hidden border border-gray-200">
            {categories.length === 0 ? (
              <p className="text-center text-gray-500 py-12">No categories found.</p>
            ) : (
              <div className="divide-y divide-gray-200">
                {categories.map((cat) => (
                  <div key={cat.id} className="flex items-center justify-between p-4 sm:px-6 hover:bg-gray-50/50 transition-colors">
                    
                    {/* Category ID & Name */}
                    <div className="flex items-center space-x-4">
                      <span className="w-8 h-8 rounded-full bg-orange-50 text-[#ffac00] font-bold flex items-center justify-center text-xs">
                        {cat.id}
                      </span>
                      <h3 className="text-gray-900 font-medium text-base">
                        {cat.name}
                      </h3>
                    </div>

                    {/* Actions */}
                    <div className="flex items-center space-x-2">
                      <button
                        onClick={() => handleOpenEditModal(cat)}
                        className="px-3 py-1.5 text-xs font-medium text-blue-600 bg-blue-50 rounded-md hover:bg-blue-100 transition-colors"
                      >
                        Update
                      </button>
                      <button
                        onClick={() => handleDelete(cat.id)}
                        className="px-3 py-1.5 text-xs font-medium text-red-600 bg-red-50 rounded-md hover:bg-red-100 transition-colors"
                      >
                        Delete
                      </button>
                    </div>

                  </div>
                ))}
              </div>
            )}
          </div>
        )}

        {/* Add / Edit Modal */}
        {isModalOpen && (
          <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
            <div className="bg-white rounded-lg max-w-md w-full p-6 shadow-xl">
              <h2 className="text-xl font-bold text-gray-900 mb-4">
                {isEditing ? 'Update Category' : 'Add New Category'}
              </h2>

              {formError && <div className="mb-4 text-sm text-red-600 bg-red-50 p-2 rounded">{formError}</div>}

              <form onSubmit={handleFormSubmit} className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700">Category Name</label>
                  <input 
                    type="text" 
                    required
                    placeholder="e.g. Accessories"
                    value={categoryName}
                    onChange={(e) => setCategoryName(e.target.value)}
                    className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 text-sm"
                  />
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
                    {isEditing ? 'Save Changes' : 'Create Category'}
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

export default AdminCategories