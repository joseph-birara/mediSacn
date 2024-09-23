import 'package:flutter/material.dart';
import 'package:mediscan/views/patient_registration_view.dart';
import 'package:mediscan/views/profile_view.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'state/auth_state.dart';
import 'state/patient_state.dart';
import 'state/profile_state.dart';
import 'views/login_view.dart';
import 'views/patient_list_view.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppState()),
      ChangeNotifierProvider(create: (_) => AuthState()),
      ChangeNotifierProvider(create: (_) => PatientState()),
      ChangeNotifierProvider(create: (_) => ProfileState()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediScan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginView(),
        '/patientList': (context) => const PatientListView(),
        '/add-patient': (context) => const PatientRegistrationView(),
        '/profile': (context) => const ProfileView()
      },
    );
  }
}
