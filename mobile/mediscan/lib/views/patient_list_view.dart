import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/patient_state.dart';

class PatientListView extends StatelessWidget {
  const PatientListView({super.key});

  @override
  Widget build(BuildContext context) {
    final patients = Provider.of<PatientState>(context).patients;

    return Scaffold(
      appBar: AppBar(title: const Text('Patient List')),
      body: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (context, index) {
          final patient = patients[index];
          return ListTile(
            title: Text(patient.name),
            subtitle:
                Text('Age: ${patient.age}, Diagnosis: ${patient.diagnosis}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a screen to add a new patient
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
