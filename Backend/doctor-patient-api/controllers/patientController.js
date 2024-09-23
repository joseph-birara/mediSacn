const Patient = require('../models/patient');

const smsService = require('../services/sms')
let message = ""
exports.addPatient = async (req, res) => {
  
  const { name, age, diagnosis, imageUrl } = req.body;
  console.log('Received request to add patient:', { name, age, diagnosis, imageUrl });
  if (diagnosis == "TB"){
    message = "You have been diagnosed with TB. Please follow your doctor's advice, take your medication regularly, and avoid close contact with others until cleared. Stay healthy!"

  }
  else{
    message = "Great news! You are not diagnosed with TB. To maintain good health, remember to eat well, exercise regularly, and get plenty of rest. Stay safe!"
  }
  try {
    const newPatient = new Patient({
      name,
      age,
      diagnosis,
      imageUrl,
      doctor: req.user.id,
    });
    await newPatient.save();
    console.log('Patient added successfully:', newPatient);
    await smsService.sendSMS(
      "+2510975455836",
      message
    );
    res.status(201).json(newPatient);
  } catch (error) {
    console.error('Error adding patient:', error.message);
    res.status(500).json({ error: 'Server error' });
  }
};

exports.getPatients = async (req, res) => {
  console.log('Received request to get patients for doctor:', req.user.id);
  try {
    const patients = await Patient.find({ doctor: req.user.id });
    console.log('Fetched patients successfully:', patients);
    res.json(patients);
  } catch (error) {
    console.error('Error fetching patients:', error.message);
    res.status(500).json({ error: 'Server error' });
  }
};
