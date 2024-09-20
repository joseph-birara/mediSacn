const Patient = require('../models/patient');

exports.addPatient = async (req, res) => {
  const { name, age, diagnosis, imageUrl } = req.body;
  try {
    const newPatient = new Patient({
      name,
      age,
      diagnosis,
      imageUrl,
      doctor: req.user.id,
    });
    await newPatient.save();
    res.status(201).json(newPatient);
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
};

exports.getPatients = async (req, res) => {
  try {
    const patients = await Patient.find({ doctor: req.user.id });
    res.json(patients);
  } catch (error) {
    res.status(500).json({ error: 'Server error' });
  }
};
