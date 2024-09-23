import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mediscan/models/patient.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../state/patient_state.dart';
import 'package:http_parser/http_parser.dart';

class PatientRegistrationView extends StatefulWidget {
  const PatientRegistrationView({super.key});

  @override
  _PatientRegistrationViewState createState() =>
      _PatientRegistrationViewState();
}

class _PatientRegistrationViewState extends State<PatientRegistrationView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final uuid = const Uuid();

  File? _imageFile;
  String? _uploadedImageUrl;
  bool _isLoading = false;

  // Constants for Cloudinary configuration
  static const String cloudinaryUrl =
      'https://api.cloudinary.com/v1_1/dh7erhtam/image/upload';
  static const String uploadPreset = 'ttt';

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadImageToCloudinary(_imageFile!);
    }
  }

  Future<void> _uploadImageToCloudinary(File imageFile) async {
    final mimeType = imageFile.path.split('.').last;

    final request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl))
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path,
          contentType: MediaType('image', mimeType)));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      final data = json.decode(responseData.body);
      setState(() {
        _uploadedImageUrl = data['secure_url'];
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully!')));
      _registerPatient(); // Save patient data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image')));
    }
  }

  void _registerPatient() {
    if (_formKey.currentState!.validate()) {
      // Randomly assign diagnosis
      String diagnosis =
          (DateTime.now().millisecondsSinceEpoch % 2 == 0) ? "TB" : "Not TB";

      final newPatient = Patient(
        id: uuid.v4(),
        name: _nameController.text,
        age: int.parse(_ageController.text),
        diagnosis: diagnosis,
        imageUrl: _uploadedImageUrl ?? '',
      );

      Provider.of<PatientState>(context, listen: false).addPatient(newPatient);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patient Registered Successfully!')));

      // Clear the form
      _nameController.clear();
      _ageController.clear();
      setState(() {
        _imageFile = null;
        _uploadedImageUrl = null;
      });

      Navigator.pushNamed(context, '/patientList'); // Navigate to patient list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register New Patient'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Patient Registration',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Patient Name',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Please enter the patient\'s name'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: 'Patient Age',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the patient\'s age';
                    } else if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Patient Image',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _imageFile == null
                    ? ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.image, color: Colors.white),
                        label: const Text('Upload Image',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          fixedSize: const Size(200, 50), // Set button size
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          elevation: 5,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _imageFile!,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                const SizedBox(height: 20),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () {
                          // Optionally call _registerPatient here
                          if (_uploadedImageUrl != null) {
                            _registerPatient();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Please upload an image first.')));
                          }
                        },
                        child: const Text(
                          'Register Patient',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          fixedSize: const Size(200, 50), // Set button size
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          elevation: 5,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
