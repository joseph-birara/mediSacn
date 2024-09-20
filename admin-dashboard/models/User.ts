import { ObjectId } from 'mongodb';

// Define the Patient interface
export interface Patient {
  _id?: ObjectId;
  name: string;
  age: number;
    phone: string;
  picture : string;
  result : string;
}

// Existing User interface
export interface User {
  _id?: ObjectId;
  name: string;
  email: string;
  password: string;
  role: 'admin' | 'doctor';
}
