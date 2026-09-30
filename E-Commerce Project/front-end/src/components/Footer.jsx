import { Link } from 'react-router-dom'

function Footer() {
  const handleFooterClick = (e) => {
    // Only scroll up if a link or button was clicked
    if (e.target.closest('a, button')) {
      window.scrollTo({ top: 0, behavior: 'smooth' })
    }
  }

  return (
    <footer 
      onClick={handleFooterClick}
      className="bg-[#1f1e1b] text-gray-300 pt-16 pb-12 border-t border-gray-800"
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-10">
          
          {/* Column 1: Brand & Tagline */}
          <div className="lg:col-span-1">
            <div className="flex items-center space-x-2 mb-4">
              <span className="text-2xl font-extrabold text-white tracking-tight">
                Weaner<span className="text-[#ffac00]">Mart</span>
              </span>
            </div>
            <p className="text-sm text-gray-400 leading-relaxed mb-6">
              The premier online marketplace for finding high-quality weaned livestock ready for breeding and farm expansion.
            </p>
            {/* Social Links */}
            <div className="flex space-x-3">
              {['facebook', 'twitter', 'instagram'].map((social) => (
                <a
                  key={social}
                  href={`https://${social}.com`}
                  target="_blank"
                  rel="noreferrer"
                  className="w-9 h-9 rounded-full bg-[#2a2925] flex items-center justify-center text-gray-400 hover:bg-[#ffac00] hover:text-white transition-colors"
                >
                  <span className="capitalize text-xs">{social[0].toUpperCase()}</span>
                </a>
              ))}
            </div>
          </div>

          {/* Column 2: Account Links */}
          <div>
            <h4 className="text-white text-lg font-bold mb-4 relative pb-2 after:content-[''] after:absolute after:bottom-0 after:left-0 after:w-8 after:h-0.5 after:bg-[#4baf47]">
              Account
            </h4>
            <ul className="space-y-2.5 text-sm">
              <li>
                <Link to="/profile" className="hover:text-[#ffac00] transition-colors">
                  My Account
                </Link>
              </li>
              <li>
                <Link to="/orders" className="hover:text-[#ffac00] transition-colors">
                  Order History
                </Link>
              </li>
              <li>
                <Link to="/profile/details" className="hover:text-[#ffac00] transition-colors">
                  Personal Details
                </Link>
              </li>
            </ul>
          </div>

          {/* Column 3: Help Links */}
          <div>
            <h4 className="text-white text-lg font-bold mb-4 relative pb-2 after:content-[''] after:absolute after:bottom-0 after:left-0 after:w-8 after:h-0.5 after:bg-[#4baf47]">
              Help
            </h4>
            <ul className="space-y-2.5 text-sm">
              <li>
                <Link to="/suggest-product" className="hover:text-[#ffac00] transition-colors">
                  Suggest a Product
                </Link>
              </li>
              <li>
                <Link to="/shipping-delivery" className="hover:text-[#ffac00] transition-colors">
                  Shipping and Delivery
                </Link>
              </li>
              <li>
                <a 
                  href="https://forms.cloud.microsoft/r/cgeUWxfstY" 
                  target="_blank" 
                  rel="noopener noreferrer"
                  className="hover:text-[#ffac00] transition-colors"
                >
                  Report a Bug
                  </a>
              </li>
            </ul>
          </div>

          {/* Column 4: Company Links */}
          <div>
            <h4 className="text-white text-lg font-bold mb-4 relative pb-2 after:content-[''] after:absolute after:bottom-0 after:left-0 after:w-8 after:h-0.5 after:bg-[#4baf47]">
              Company
            </h4>
            <ul className="space-y-2.5 text-sm">
              <li>
                <Link to="/about" className="hover:text-[#ffac00] transition-colors">
                  About Us
                </Link>
              </li>
              <li>
                <Link to="/deliver-for-us" className="hover:text-[#ffac00] transition-colors">
                  Deliver for Us
                </Link>
              </li>
              <li>
                <a 
                  href="https://www.farmersweekly.co.za" 
                  target="_blank" 
                  rel="noopener noreferrer"
                  className="hover:text-[#ffac00] transition-colors"
                >
                  Agri News
                </a>
              </li>
            </ul>

            <h4 className="text-white text-lg font-bold mt-6 mb-4 relative pb-2 after:content-[''] after:absolute after:bottom-0 after:left-0 after:w-8 after:h-0.5 after:bg-[#4baf47]">
              Terms & Policies
            </h4>
            <ul className="space-y-2.5 text-sm">
              <li>
                <Link to="/returns-policy" className="hover:text-[#ffac00] transition-colors">
                  Returns Policy
                </Link>
              </li>
              <li>
                <Link to="/privacy-policy" className="hover:text-[#ffac00] transition-colors">
                  Privacy Policy
                </Link>
              </li>
            </ul>
          </div>

          {/* Column 5: Contact Details */}
          <div>
            <h4 className="text-white text-lg font-bold mb-4 relative pb-2 after:content-[''] after:absolute after:bottom-0 after:left-0 after:w-8 after:h-0.5 after:bg-[#4baf47]">
              Contact
            </h4>
            <ul className="space-y-4 text-sm">
              <li className="flex items-center space-x-3">
                <span className="text-[#ffac00]">Telephone:</span>
                <span>0800 10111</span>
              </li>
              <li className="flex items-center space-x-3">
                <span className="text-[#ffac00]">Mail To:</span>
                <a href="mailto:help@weaner.com" className="hover:underline">
                  help@weaner.com
                </a>
              </li>
              <li className="flex items-start space-x-3">
                <span className="text-[#ffac00] mt-0.5">Address:</span>
                <span>Plot 41 Leeuwpoort, Mpumalanga</span>
              </li>
            </ul>
          </div>

        </div>

        {/* Bottom Copyright Bar */}
        <div className="mt-12 pt-6 border-t border-gray-800 text-center text-xs text-gray-500">
          <p>&copy; {new Date().getFullYear()} WeanerMart. All rights reserved.</p>
        </div>
      </div>
    </footer>
  )
}

export default Footer