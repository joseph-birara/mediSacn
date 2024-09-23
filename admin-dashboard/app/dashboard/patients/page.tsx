// app/dashboard/patients/page.tsx

'use client';

import { useEffect, useState } from 'react';

interface Patient {
  _id: string;
  name: string;
  age: number;
  phone: string;
  picture: string;
  result: string;
}

export default function PatientsPage() {
  const [patients, setPatients] = useState<Patient[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Fetch patients from the API
    const fetchPatients = async () => {
      try {
        const res = await fetch('/api/patients');
        const data = await res.json();
        setPatients(data);
      } catch (error) {
        console.error('Failed to fetch patients:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchPatients();
  }, []);

  if (loading) {
    return <div>Loading patients...</div>;
  }

  return (
    <div className="container mx-auto p-6">
      <h1 className="text-2xl font-bold mb-4">Patients List</h1>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {patients.map((patient) => (
          <div key={patient._id} className="p-4 bg-white rounded-lg shadow-lg">
            <img
              src={patient.picture}
              alt={patient.name}
              className="w-32 h-32 object-cover rounded-full mx-auto mb-4"
            />
            <h2 className="text-lg font-semibold text-center">{patient.name}</h2>
            <p className="text-gray-600 text-center">Age: {patient.age}</p>
            <p className="text-gray-600 text-center">Phone: {patient.phone}</p>
            <p className="text-gray-600 text-center">Result: {patient.result}</p>
          </div>
        ))}
      </div>
    </div>
  );
}
