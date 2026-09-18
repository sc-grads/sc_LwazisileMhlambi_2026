import { useState, useEffect } from 'react'

function AdminUsers() {
  const [users, setUsers] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    document.title = 'Manage Users | WeanerMart Admin'
    fetchUsers()
  }, [])

  const fetchUsers = async () => {
    try {
      const token = localStorage.getItem('token')
      const response = await fetch('http://127.0.0.1:5001/api/admin/users', {
        headers: { 'Authorization': `Bearer ${token}` }
      })
      const data = await response.json()
      if (!response.ok) throw new Error(data.error || 'Failed to fetch users')
      setUsers(data)
    } catch (err) {
      setError('Could not connect to server to load users.')
    } finally {
      setLoading(false)
    }
  }

  const handleRoleToggle = async (user) => {
    const newRole = user.role === 'admin' ? 'customer' : 'admin'
    if (!window.confirm(`Change role for ${user.first_name} ${user.last_name} to ${newRole}?`)) return

    try {
      const token = localStorage.getItem('token')
      const response = await fetch(`http://127.0.0.1:5001/api/admin/users/${user.id}/role`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        },
        body: JSON.stringify({ role: newRole })
      })

      const data = await response.json()
      if (!response.ok) {
        alert(data.error || 'Failed to update user role')
        return
      }

      // Update local state
      setUsers(users.map(u => u.id === user.id ? { ...u, role: newRole } : u))
    } catch (err) {
      alert('Network error while updating role.')
    }
  }

  const handleDelete = async (id) => {
    if (!window.confirm('Are you sure you want to delete this user account?')) return

    try {
      const token = localStorage.getItem('token')
      const response = await fetch(`http://127.0.0.1:5001/api/admin/users/${id}`, {
        method: 'DELETE',
        headers: { 'Authorization': `Bearer ${token}` }
      })

      const data = await response.json()
      if (!response.ok) {
        alert(data.error || `Failed to delete user (Status: ${response.status})`)
        return
      }

      setUsers(users.filter(u => u.id !== id))
    } catch (err) {
      alert('Could not connect to server to delete user.')
    }
  }

  return (
    <div className="min-h-screen bg-gray-50 py-10 px-4 sm:px-6 lg:px-8">
      <div className="max-w-6xl mx-auto">
        
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900">Manage Users</h1>
          <p className="text-sm text-gray-500 mt-1">View user accounts and manage their permission levels</p>
        </div>

        {loading && <p className="text-center text-gray-500 py-20">Loading users...</p>}
        {error && <p className="text-center text-red-600 py-20">{error}</p>}

        {/* Users Table */}
        {!loading && !error && (
          <div className="bg-white shadow-sm rounded-lg overflow-hidden border border-gray-200">
            {users.length === 0 ? (
              <p className="text-center text-gray-500 py-12">No registered users found.</p>
            ) : (
              <div className="divide-y divide-gray-200">
                {users.map((user) => {
                  const isAdmin = user.role === 'admin';

                  return (
                    <div key={user.id} className="flex items-center justify-between p-4 sm:px-6 hover:bg-gray-50/50 transition-colors">
                      
                      {/* User Info */}
                      <div className="flex items-center space-x-4 min-w-0 flex-1">
                        <div className="w-10 h-10 rounded-full bg-gray-100 text-gray-600 font-bold flex items-center justify-center text-sm flex-shrink-0">
                          {user.first_name ? user.first_name.charAt(0).toUpperCase() : 'U'}
                        </div>
                        <div className="min-w-0 flex-1">
                          <h3 className="text-gray-900 font-medium text-base truncate">
                            {user.first_name} {user.last_name}
                          </h3>
                          <span className="text-xs text-gray-400 block truncate">{user.email}</span>
                        </div>
                      </div>

                      {/* Role Badge & Status */}
                      <div className="flex items-center space-x-6 px-4 flex-shrink-0">
                        <span className={`px-2.5 py-1 text-xs font-semibold rounded-md ${
                          isAdmin ? 'bg-orange-100 text-[#ffac00]' : 'bg-gray-100 text-gray-700'
                        }`}>
                          {user.role.toUpperCase()}
                        </span>
                      </div>

                      {/* Actions */}
                      <div className="flex items-center space-x-2 flex-shrink-0 pl-4 border-l border-gray-100">
                        <button
                          onClick={() => handleRoleToggle(user)}
                          className="px-3 py-1.5 text-xs font-medium text-blue-600 bg-blue-50 rounded-md hover:bg-blue-100 transition-colors"
                        >
                          {isAdmin ? 'Demote to Customer' : 'Promote to Admin'}
                        </button>
                        <button
                          onClick={() => handleDelete(user.id)}
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

      </div>
    </div>
  )
}

export default AdminUsers