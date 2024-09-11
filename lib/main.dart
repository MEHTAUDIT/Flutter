import 'package:flutter/material.dart';
import 'package:lab/screens/auth/login.dart';
import 'package:lab/screens/auth/register.dart';
import 'package:lab/screens/home/home.dart';
import 'package:lab/screens/trips/trip_page.dart';
import 'package:lab/screens/footer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const Footer(),
        '/home': (context) => const MyHomePage(),
        '/trips': (context) => const TripsPage(),
        '/profile': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Delaying navigation to the next screen
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/');
    });

    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/image.png', // Replace with your image path
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
