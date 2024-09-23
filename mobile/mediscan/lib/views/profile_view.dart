import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/profile_state.dart';
import '../state/auth_state.dart'; // Import AuthState for logout functionality

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileState>(context).profile;
    final authState = Provider.of<AuthState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        // Allows for scrolling in case of overflow
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${profile?.name}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Specialization: ${profile?.specialization}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),

            // Edit Profile Button with Custom Styles
            ElevatedButton(
              onPressed: () {
                // Navigate to a screen to edit the profile
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Background color
                textStyle: const TextStyle(
                  fontSize: 16, // Text size
                  color: Colors.white, // Text color
                ),
                minimumSize: const Size(150, 50), // Button size
              ),
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 20),

            // Go to Patient List Button with Custom Styles
            ElevatedButton(
              onPressed: () {
                // Navigate to PatientListView
                Navigator.pushNamed(context, '/patientList');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Background color
                textStyle: const TextStyle(
                  fontSize: 16, // Text size
                  color: Colors.white, // Text color
                ),
                minimumSize: const Size(200, 50), // Button size
              ),
              child: const Text('Go to Patient List'),
            ),
            const SizedBox(height: 20),

            // Log Out Button with Custom Styles
            ElevatedButton(
              onPressed: () {
                // Perform logout by clearing the authentication state
                authState.logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false, // Remove all previous routes
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Background color
                textStyle: const TextStyle(
                  fontSize: 16, // Text size
                  color: Colors.white, // Text color
                ),
                minimumSize: const Size(200, 50), // Button size
              ),
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
