"use client";
import { useEffect, useState } from 'react';
import axios from 'axios';
import { FaSignOutAlt } from 'react-icons/fa'; // Importing logout icon
import { useRouter } from 'next/navigation';

export default function DashboardPage() {
  const router = useRouter();
  const [totalPatients, setTotalPatients] = useState(0);
  const [totalDoctors, setTotalDoctors] = useState(0);
  
  useEffect(() => {
    const fetchData = async () => {
      try {
        const patientsResponse = await axios.get('/api/dashboard/patients');
        const doctorsResponse = await axios.get('/api/dashboard/doctors');
        
        setTotalPatients(patientsResponse.data.length); // Assuming response is an array
        setTotalDoctors(doctorsResponse.data.length); // Assuming response is an array
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    };

    fetchData();
  }, []);

  const handleLogout = () => {
    // Add your logout logic here (e.g., clear user session, tokens, etc.)
    // For example:
    // localStorage.removeItem('token');
    router.push('/login'); // Redirect to login page
  };

  return (
    <div className="flex min-h-screen bg-gray-100">
      {/* Sidebar */}
      <aside className="w-64 bg-white shadow-lg">
        <div className="p-6 bg-gradient-to-r from-indigo-600 to-blue-500 text-white">
          <h2 className="text-3xl font-bold">Admin Dashboard</h2>
        </div>
        <nav className="p-4">
          <a href="/dashboard/patients" className="block px-4 py-3 mb-4 text-lg text-gray-700 bg-gray-100 rounded-lg hover:bg-indigo-600 hover:text-white transition-colors duration-300">
            Patients
          </a>
          <a href="/dashboard/doctors" className="block px-4 py-3 text-lg text-gray-700 bg-gray-100 rounded-lg hover:bg-indigo-600 hover:text-white transition-colors duration-300">
            Doctors
          </a>
        </nav>
      </aside>

      {/* Main Content */}
      <main className="flex-1 p-10 bg-gray-50">
        <div className="mb-8">
          <h1 className="text-4xl font-extrabold text-gray-900">Welcome, Admin</h1>
          <p className="mt-2 text-lg text-gray-600">Manage doctors and view patient data using the sidebar.</p>
        </div>

        {/* Dashboard Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div className="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow duration-300">
            <h3 className="text-xl font-semibold text-gray-700">Total Patients</h3>
            <p className="mt-4 text-2xl font-bold text-indigo-600">{totalPatients}</p>
          </div>
          <div className="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow duration-300">
            <h3 className="text-xl font-semibold text-gray-700">Total Doctors</h3>
            <p className="mt-4 text-2xl font-bold text-indigo-600">{totalDoctors}</p>
          </div>
        </div>

        {/* Logout Button */}
        <button
          className="fixed bottom-6 left-6 p-2 text-white bg-red-500 rounded-full hover:bg-red-600 transition-colors duration-300"
          onClick={handleLogout}
          title="Logout"
        >
          <FaSignOutAlt size={24} />
        </button>
      </main>
    </div>
  );
}
