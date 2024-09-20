const express = require('express');
const { addPatient, getPatients } = require('../controllers/patientController');
const auth = require('../middleware/authMiddleware');
const router = express.Router();

router.post('/', auth, addPatient);
router.get('/', auth, getPatients);

module.exports = router;
