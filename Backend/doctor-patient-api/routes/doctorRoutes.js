const express = require('express');
const { loginDoctor, getDoctorProfile , getAllDoctors} = require('../controllers/doctorController');
const auth = require('../middleware/authMiddleware');
const router = express.Router();

router.post('/login', loginDoctor);
router.get('/profile', auth, getDoctorProfile);
router.get("/all",getAllDoctors)

module.exports = router;
