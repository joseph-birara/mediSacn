// app/dashboard/doctors/page.tsx

'use client';

import { User } from '@/models/User';
import { useEffect, useState } from 'react';
import { FaUserMd } from 'react-icons/fa'; // Using icon for avatar
// import { Doctor } from './types'; // Define Doctor type in a separate file if necessary

export default function DoctorsPage() {
  const [doctors, setDoctors] = useState<User[]>([]);
  const [showAddDoctorModal, setShowAddDoctorModal] = useState(false);
  const [newDoctor, setNewDoctor] = useState({
    name: '',
    phone: '',
    email: '',
    image: ''
  });

  // Fetch doctors when the component loads
  useEffect(() => {
    const fetchDoctors = async () => {
      try {
        const response = await fetch('/api/dashboard/doctors');
        const data = await response.json();
        setDoctors(data);
      } catch (error) {
        console.error('Error fetching doctors:', error);
      }
    };

    fetchDoctors();
  }, []);

  // Add a new doctor
  const handleAddDoctor = async () => {
    try {
      const response = await fetch('/api/dashboard/doctors', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(newDoctor),
      });

      if (response.ok) {
        const newDoctorFromResponse = await response.json();
        setDoctors([...doctors, newDoctorFromResponse]);
        setShowAddDoctorModal(false);
        setNewDoctor({ name: '', phone: '', email: '', image: '' });
      } else {
        console.error('Error adding doctor:', response.statusText);
      }
    } catch (error) {
      console.error('Error adding doctor:', error);
    }
  };

  // Delete a doctor
  const deleteDoctor = async (id: string) => {
    try {
      await fetch(`/api/dashboard/doctors?id=${id}`, {
        method: 'DELETE',
      });
      setDoctors(doctors.filter((doc) => doc._id !== id));
    } catch (error) {
      console.error('Error deleting doctor:', error);
    }
  };

  return (
    <div>
      <div className="flex justify-between items-center mb-4">
        <h1 className="text-2xl font-bold">Doctors Management</h1>
        <button
          className="px-4 py-2 text-white bg-green-500 rounded-lg hover:bg-green-700"
          onClick={() => setShowAddDoctorModal(true)}
        >
          Add Doctor
        </button>
      </div>

      {showAddDoctorModal && (
        <div className="fixed inset-0 bg-gray-800 bg-opacity-50 flex items-center justify-center">
          <div className="bg-white p-6 rounded-lg shadow-lg">
            <h2 className="text-xl font-semibold mb-4">Add New Doctor</h2>
            <form
              onSubmit={(e) => {
                e.preventDefault();
                handleAddDoctor();
              }}
            >
              <div className="mb-4">
                <label className="block text-gray-700">Name:</label>
                <input
                  type="text"
                  value={newDoctor.name}
                  onChange={(e) => setNewDoctor({ ...newDoctor, name: e.target.value })}
                  className="mt-1 block w-full border-gray-300 rounded-md shadow-sm"
                />
              </div>
              <div className="mb-4">
                <label className="block text-gray-700">Phone:</label>
                <input
                  type="text"
                  value={newDoctor.phone}
                  onChange={(e) => setNewDoctor({ ...newDoctor, phone: e.target.value })}
                  className="mt-1 block w-full border-gray-300 rounded-md shadow-sm"
                />
              </div>
              <div className="mb-4">
                <label className="block text-gray-700">Email:</label>
                <input
                  type="email"
                  value={newDoctor.email}
                  onChange={(e) => setNewDoctor({ ...newDoctor, email: e.target.value })}
                  className="mt-1 block w-full border-gray-300 rounded-md shadow-sm"
                />
              </div>
              <div className="mb-4">
                <label className="block text-gray-700">Image URL:</label>
                <input
                  type="text"
                  value={newDoctor.image}
                  onChange={(e) => setNewDoctor({ ...newDoctor, image: e.target.value })}
                  className="mt-1 block w-full border-gray-300 rounded-md shadow-sm"
                />
              </div>
              <div className="flex justify-end">
                <button
                  type="button"
                  className="px-4 py-2 text-white bg-gray-500 rounded-lg hover:bg-gray-700 mr-2"
                  onClick={() => setShowAddDoctorModal(false)}
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 text-white bg-green-500 rounded-lg hover:bg-green-700"
                >
                  Add Doctor
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      <ul className="space-y-4 mt-4">
        {doctors.map((doc) => (
          <li key={doc._id} className="flex items-center p-4 bg-white rounded-lg shadow">
            <FaUserMd className="w-16 h-16 text-blue-500 mr-4" /> {/* Avatar icon */}
            <div className="flex-1">
              <h2 className="text-xl font-semibold">{doc.name}</h2>
              <p className="text-gray-600">Phone: {doc.phone}</p>
              <p className="text-gray-600">Email: {doc.email}</p>
            </div>
            <button
              className="ml-4 px-4 py-2 text-white bg-red-500 rounded-lg hover:bg-red-700"
              onClick={() => deleteDoctor(doc._id)}
            >
              Delete
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}
