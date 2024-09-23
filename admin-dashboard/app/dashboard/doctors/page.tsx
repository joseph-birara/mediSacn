'use client';

import { User } from '@/models/User';
import router from 'next/router';
import { useEffect, useState } from 'react';
import { FaUserMd } from 'react-icons/fa';

export default function DoctorsPage() {
  const [doctors, setDoctors] = useState<User[]>([]);
  const [showAddDoctorModal, setShowAddDoctorModal] = useState(false);
  const [newDoctor, setNewDoctor] = useState({
    name: '',
    phone: '',
    email: '',
    image: '', 
    password: ''
  });
  const [imageFile, setImageFile] = useState<File | null>(null); // Separate state for the file
  const [loading, setLoading] = useState(false);
  

  // Fetch doctors when the component loads
  useEffect(() => {
    const fetchDoctors = async () => {
      setLoading(true);
      console.log("fetching doctores")
      const response = await fetch('/api/dashboard/doctors');
      const data = await response.json();
      setDoctors(data);
      setLoading(false);
    };

    fetchDoctors();
  }, []);

  // Add a new doctor
  const handleAddDoctor = async (e: any) => {
    e.preventDefault();
    let imageUrl = '';

    if (imageFile) {
      const formData = new FormData();
      formData.append('file', imageFile);
      formData.append('upload_preset', 'YOUR_CLOUDINARY_UPLOAD_PRESET');

      const res = await fetch(
        `https://api.cloudinary.com/v1_1/YOUR_CLOUDINARY_NAME/image/upload`,
        {
          method: 'POST',
          body: formData,
        }
      );
      const file = await res.json();
      imageUrl = file.secure_url;
    }

    const doctorData = { ...newDoctor, image: imageUrl };

    const response = await fetch('/api/dashboard/doctors', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(doctorData),
    });

    if (response.ok) {
      console.log("adding doctores")
      const newDoctorFromResponse = await response.json();
      setDoctors([...doctors, newDoctorFromResponse]);
      setShowAddDoctorModal(false);
      setNewDoctor({ name: '', phone: '', email: '', image: '', password: '' });
      setImageFile(null); // Reset the image file
    }
  };

  // Delete a doctor
  const deleteDoctor = async (id: string) => {
    await fetch(`/api/dashboard/doctors?id=${id}`, {
      method: 'DELETE',
    });
    setDoctors(doctors.filter((doc) => doc._id.toString() !== id));
  };

  return (
    <div className="p-4 md:p-8">
  {/* Back Button */}
  <div className="flex justify-between mb-4">
  <button
  className="flex items-center text-white bg-blue-500 hover:bg-blue-700 px-4 py-2 rounded-lg shadow mb-4"
  onClick={() => router.back()} // Assuming 'router' is defined using 'useRouter' from 'next/router'
>
  <svg
    xmlns="http://www.w3.org/2000/svg"
    fill="none"
    viewBox="0 0 24 24"
    strokeWidth="2"
    stroke="currentColor"
    className="w-5 h-5 mr-2"
  >
    <path
      strokeLinecap="round"
      strokeLinejoin="round"
      d="M15 19l-7-7 7-7"
    />
  </svg>
  Back
</button>


  {/* Centered Header */}
  <div className="flex justify-center mb-4">
    <h1 className="text-2xl font-bold">Doctors Management</h1>
  </div>

  <div className="flex justify-between items-center mb-4">
    <button
      className="px-4 py-2 text-white bg-green-500 rounded-lg hover:bg-green-700"
      onClick={() => setShowAddDoctorModal(true)}
    >
      Add Doctor
    </button>
  </div>
  </div>

  {/* Show message if no doctors are found */}
  {loading ? (
    <p>Loading doctors...</p>
  ) : doctors.length === 0 ? (
    <p className="text-gray-500">No doctors found.</p>
  ) : (
    <ul className="space-y-4 mt-4 max-w-4xl mx-auto"> {/* Limit width and center */}
      {doctors.map((doc) => (
        <li key={doc._id.toString()} className="flex items-center p-4 bg-white rounded-lg shadow max-w-xl mx-auto"> {/* Added max width */}
          {doc.image ? (
            <img src={doc.image} alt={doc.name} className="w-16 h-16 rounded-full mr-4" />
          ) : (
            <FaUserMd className="w-16 h-16 text-blue-500 mr-4" />
          )}
          <div className="flex-1">
            <h2 className="text-xl font-semibold">{doc.name}</h2>
            <p className="text-gray-600">Phone: {doc.phone}</p>
            <p className="text-gray-600">Email: {doc.email}</p>
          </div>
          <button
            className="ml-4 px-4 py-2 text-white bg-red-500 rounded-lg hover:bg-red-700"
            onClick={() => deleteDoctor(String(doc._id))}
          >
            Delete
          </button>
        </li>
      ))}
    </ul>
  )}

  {/* Modal for adding new doctor */}
  {showAddDoctorModal && (
    <div className="fixed inset-0 bg-gray-800 bg-opacity-50 flex items-center justify-center">
      <div className="bg-white p-6 rounded-lg shadow-lg w-96">
        <h2 className="text-xl font-semibold mb-4">Add New Doctor</h2>
        <form onSubmit={handleAddDoctor}>
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
            <label className="block text-gray-700">Password:</label>
            <input
              type="password"
              value={newDoctor.password}
              onChange={(e) => setNewDoctor({ ...newDoctor, password: e.target.value })}
              className="mt-1 block w-full border-gray-300 rounded-md shadow-sm"
            />
          </div>
          <div className="mb-4">
            <label className="block text-gray-700">Image:</label>
            <input
              type="file"
              onChange={(e) => setImageFile(e.target.files?.[0] || null)}
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
</div>

  );
}
