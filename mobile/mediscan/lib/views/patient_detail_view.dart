import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/patient_state.dart';

class PatientDetailView extends StatelessWidget {
  final String patientId;

  const PatientDetailView({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    final patient =
        Provider.of<PatientState>(context).getPatientById(patientId);

    if (patient == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Patient Details'),
          backgroundColor: Colors.teal,
        ),
        body: const Center(child: Text('Patient not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Details - ${patient.name}'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(patient.imageUrl),
                radius: 50.0,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Name: ${patient.name}',
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Age: ${patient.age}',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Diagnosis: ${patient.diagnosis}',
              style: const TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
