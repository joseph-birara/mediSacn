const Doctor = require('../models/doctor');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

exports.loginDoctor = async (req, res) => {
  const { email, password } = req.body;
  console.log(req.body)
  try {
    console.log("inside log in")
    const doctor = await Doctor.findOne({ email });
    if (!doctor) {
      console.log("no doctore found")
      return res.status(400).json({ message: 'Invalid credentials' });}

    const isMatch = password == doctor.password;
    if (!isMatch) {
      console.log("password not match")
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    const token = jwt.sign({ id: doctor._id }, process.env.JWT_SECRET, { expiresIn: '1h' });
    res.json({ token});
  } catch (error) {
    res.status(500).json({ error: 'Server error' + error.message });
  }
};

exports.getDoctorProfile = async (req, res) => {
  try {
    const doctor = await Doctor.findById(req.user.id).select('-password');
    res.json(doctor);
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
};


exports.getAllDoctors = async (req, res) => {
  try {
    const doctors = await Doctor.find(); // Exclude password from response
    res.json(doctors);
  } catch (error) {
    console.error('Error fetching doctors:', error);
    res.status(500).json({ error: 'Server error' });
  }
};