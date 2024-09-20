const mongoose = require('mongoose');

const patientSchema = new mongoose.Schema({
  name: { type: String, required: true },
  age: { type: Number, required: true },
  diagnosis: String,
  imageUrl: String,
  doctor: { type: mongoose.Schema.Types.ObjectId, ref: 'Doctor', required: true },
});

const Patient = mongoose.model('Patient', patientSchema);
module.exports = Patient;
