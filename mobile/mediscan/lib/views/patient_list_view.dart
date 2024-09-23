import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/patient_state.dart';
import '../state/auth_state.dart'; // Import AuthState
import 'patient_detail_view.dart';

class PatientListView extends StatefulWidget {
  const PatientListView({super.key});

  @override
  _PatientListViewState createState() => _PatientListViewState();
}

class _PatientListViewState extends State<PatientListView> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPatients();
    });
  }

  Future<void> _loadPatients() async {
    try {
      await Provider.of<PatientState>(context, listen: false).fetchPatients();
    } catch (e) {
      print('Error loading patients: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final patients = Provider.of<PatientState>(context).patients;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient List'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : patients.isEmpty
                    ? const Center(child: Text('No patients available'))
                    : ListView.builder(
                        itemCount: patients.length,
                        itemBuilder: (context, index) {
                          final patient = patients[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(patient.imageUrl),
                                radius: 30.0,
                              ),
                              title: Text(patient.name),
                              subtitle: Text(
                                  'Age: ${patient.age}, Diagnosis: ${patient.diagnosis}'),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PatientDetailView(
                                      patientId: patient.id,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                    context, '/profile'); // Navigate to ProfileView
              },
              child: const Text('Back to Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Set a color for the button
                padding: const EdgeInsets.symmetric(
                    horizontal: 30, vertical: 15), // Adjust padding
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-patient');
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
