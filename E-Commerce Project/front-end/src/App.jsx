import { Routes, Route } from 'react-router-dom'
import Navbar from './components/Navbar'
import SignUp from './pages/SignUp'


function App() {
  return (
    <div>
      <Navbar />
      <Routes>
        <Route path="/sign-up" element={<SignUp />} />
      </Routes>
    </div>
  )
}

export default App