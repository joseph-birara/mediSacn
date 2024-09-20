import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/auth_state.dart';

class LoginView extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Doctor ID'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<AuthState>(context, listen: false)
                    .login(_controller.text);
                Navigator.pushReplacementNamed(context, '/patientList');
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
