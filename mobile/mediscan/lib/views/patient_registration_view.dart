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
import 'package:tflite/tflite.dart';

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
  final _diagnosisController = TextEditingController();
  final uuid = Uuid();

  File? _imageFile;
  String? _uploadedImageUrl;

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  // Load the TFLite model
  Future<void> _loadModel() async {
    String? result = await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt", // If you have a labels file
    );
    print(result);
  }

  // Function to pick image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Run TFLite model on the selected image
      _predictImage(_imageFile!);

      // Upload the image to Cloudinary
      _uploadImageToCloudinary(_imageFile!);
    }
  }

  // Function to run prediction using the TFLite model
  Future<void> _predictImage(File image) async {
    var result = await Tflite.runModelOnImage(
      path: image.path, // Path to the image file
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2, // Assuming two classes (TB or not TB)
      threshold: 0.5,
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        // Assuming the result is a list of predictions with confidence values
        _diagnosisController.text = result[0]
            ['label']; // Store the predicted label in the diagnosis field
      });
    } else {
      print('No prediction result.');
    }
  }

  // Function to upload image to Cloudinary
  Future<void> _uploadImageToCloudinary(File imageFile) async {
    String cloudinaryUrl =
        'https://api.cloudinary.com/v1_1/<your-cloud-name>/image/upload'; // Replace with your Cloudinary cloud name
    String uploadPreset =
        '<your-upload-preset>'; // Replace with your upload preset

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
        const SnackBar(content: Text('Image uploaded successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image')),
      );
    }
  }

  void _registerPatient() {
    if (_formKey.currentState!.validate()) {
      final newPatient = Patient(
        id: uuid.v4(), // Generate a unique ID for the patient
        name: _nameController.text,
        age: int.parse(_ageController.text),
        diagnosis: _diagnosisController.text, // Use the predicted diagnosis
        imageUrl: _uploadedImageUrl ?? '', // Set uploaded image URL
      );

      // Add the new patient to the state
      Provider.of<PatientState>(context, listen: false).addPatient(newPatient);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Patient Registered Successfully!')),
      );

      // Clear the form
      _nameController.clear();
      _ageController.clear();
      _diagnosisController.clear();
      setState(() {
        _imageFile = null;
        _uploadedImageUrl = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register New Patient'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Patient Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the patient\'s name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Patient Age'),
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
                TextFormField(
                  controller: _diagnosisController,
                  decoration: const InputDecoration(labelText: 'Diagnosis'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the diagnosis';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text('Patient Image'),
                const SizedBox(height: 10),
                _imageFile == null
                    ? ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.image),
                        label: const Text('Upload Image'),
                      )
                    : Image.file(
                        _imageFile!,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _registerPatient,
                  child: const Text('Register Patient'),
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
    _diagnosisController.dispose();
    super.dispose();
  }
}
