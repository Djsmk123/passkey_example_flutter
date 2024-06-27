import 'package:credential_manager/credential_manager.dart';
import 'package:credential_manager_example/auth_screen.dart';
import 'package:flutter/material.dart';

CredentialManager credentialManager = CredentialManager();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (credentialManager.isSupportedPlatform) {
    await credentialManager.init(
        preferImmediatelyAvailableCredentials: true,
        googleClientId:
            "492037512529-nbcdejpkq19ad1fos6ninmlh3990km3i.apps.googleusercontent.com");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthScreen(
        key: Key('auth_screen'),
      ),
    );
  }
}
