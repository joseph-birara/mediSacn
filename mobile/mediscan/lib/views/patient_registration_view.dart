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
  bool _isLoading = false; // Make this mutable

  static const String cloudinaryUrl =
      'https://api.cloudinary.com/v1_1/dh7erhtam/image/upload';
  static const String uploadPreset = 'sample';

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _isLoading = true; // Start loading after picking an image
      });
      await _uploadImageToCloudinary(_imageFile!);
    }
  }

  Future<void> _uploadImageToCloudinary(File imageFile) async {
    try {
      final mimeType = imageFile.path.split('.').last;

      // Create the multipart request for Cloudinary
      final request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl))
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path,
            contentType: MediaType('image', mimeType)));

      // Send the request and await the response
      final response = await request.send();

      // Check if the response was successful
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final data = json.decode(responseData.body);
        setState(() {
          _uploadedImageUrl = data['secure_url'];
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image uploaded successfully!')));
      } else {
        // Log the full response body for failed uploads
        final responseData = await http.Response.fromStream(response);
        print('Upload failed with status code: ${response.statusCode}');
        print('Response body: ${responseData.body}');

        setState(() {
          _isLoading = false;
        });

        // Show a failure message to the user
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to upload image: ${response.statusCode}')));
      }
    } catch (e) {
      // Catch and log any exceptions
      print('Error during image upload: $e');

      setState(() {
        _isLoading = false;
      });

      // Show an error message to the user
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
    }
  }

  Future<void> _registerPatient() async {
    if (_formKey.currentState!.validate()) {
      String diagnosis =
          (DateTime.now().millisecondsSinceEpoch % 2 == 0) ? "TB" : "Not TB";

      final newPatient = Patient(
        id: uuid.v4(),
        name: _nameController.text,
        age: int.parse(_ageController.text),
        diagnosis: diagnosis,
        imageUrl: _uploadedImageUrl ?? '',
      );

      // Make the function call await the completion
      await Provider.of<PatientState>(context, listen: false)
          .addPatient(newPatient);

// Show the success message only after the patient is added
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patient Registered Successfully!')));

// Clear the form
      _nameController.clear();
      _ageController.clear();
      setState(() {
        _imageFile = null;
        _uploadedImageUrl = null;
      });

// Navigate to the patient list page after the function call completes
      Navigator.pushNamed(context, '/patientList');
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
                const Text(
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
                    border: const OutlineInputBorder(),
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
                    border: const OutlineInputBorder(),
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
                          fixedSize: const Size(200, 50),
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
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () {
                          if (_imageFile == null || _uploadedImageUrl == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Please upload an image first.')));
                          } else {
                            _registerPatient();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          fixedSize: const Size(200, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          elevation: 5,
                        ),
                        child: const Text(
                          'Register Patient',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
