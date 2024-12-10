import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'widgets/continueButton.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensures Flutter is ready before calling Firebase.initializeApp()
  await Firebase.initializeApp();  // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      title: 'Welcome Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Welcome Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // First message with app color
            Text(
              'Welcome to our App!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: appColor, // Use the primary color from the app theme
              ),
            ),
            const SizedBox(height: 10),
            // Second message with light color
            const Text(
              'Let\'s get started by exploring new features.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey, // Light grey for the second message
              ),
            ),
            const SizedBox(height: 20),
            const ContinueButton(),
          ],
        ),
      ),
    );
  }
}
