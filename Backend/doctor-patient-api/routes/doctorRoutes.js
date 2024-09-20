const express = require('express');
const { loginDoctor, getDoctorProfile } = require('../controllers/doctorController');
const auth = require('../middleware/authMiddleware');
const router = express.Router();

router.post('/login', loginDoctor);
router.get('/profile', auth, getDoctorProfile);

module.exports = router;
