// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:credential_manager/credential_manager.dart';

import 'package:credential_manager_example/home_screen.dart';
import 'package:credential_manager_example/main.dart';

import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String? username;
  String? password;
  bool isRegistering = false;
  bool isLoggingIn = false;
  String? errorMessage;
  bool passEnabled = false;
  bool isRegisterPassword = false;
  String rpId = "https://blogs-deeplink-example.vercel.app/";
  bool googleSignIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('One Tap Auth', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Experience the magic of One Tap Auth!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.deepPurple),
              ),
              const SizedBox(height: 24),
              TextField(
                onChanged: (value) {
                  setState(() {
                    username = value;
                    errorMessage = null;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Enter your username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person, color: Colors.deepPurple),
                ),
              ),
              if (passEnabled) const SizedBox(height: 16),
              if (passEnabled)
                TextField(
                  onChanged: (value) {
                    setState(() {
                      password = value;
                      errorMessage = null;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.password, color: Colors.deepPurple),
                  ),
                ),
              const SizedBox(height: 16),
              if (errorMessage != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              if (errorMessage != null) const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: isRegisterPassword ? null : registerWithPassword,
                icon: isRegisterPassword
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.password),
                label: isRegisterPassword
                    ? const SizedBox.shrink()
                    : const Text('Register with password'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  textStyle: const TextStyle(fontSize: 16.0),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: isRegistering ? null : registerWithPassKey,
                icon: isRegistering
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.fingerprint),
                label: isRegistering
                    ? const SizedBox.shrink()
                    : const Text('Register with passkey'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  textStyle: const TextStyle(fontSize: 16.0),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: googleSignIn ? null : signInWithGoogle,
                icon: googleSignIn
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : Image.network(
                        "https://cdn4.iconfinder.com/data/icons/logos-brands-7/512/google_logo-google_icongoogle-512.png",
                        height: 30,
                      ),
                label: googleSignIn
                    ? const SizedBox.shrink()
                    : const Text('Sign in with Google'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  textStyle: const TextStyle(fontSize: 16.0),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: isLoggingIn ? null : login,
                icon: isLoggingIn
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.login),
                label:
                    isLoggingIn ? const SizedBox.shrink() : const Text('Login'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  textStyle: const TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      googleSignIn = true;
      errorMessage = null;
    });
    try {
      final res = await credentialManager.saveGoogleCredential();
      if (res != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              user: res.displayName ?? "Hello",
            ),
          ),
        );
      } else {
        setState(() {
          errorMessage = 'Error: Google Sign In failed';
        });
      }
    } on CredentialException catch (e) {
      log("Error: ${e.message} ${e.code} ${e.details} ");
      setState(() {
        errorMessage = 'Error: ${e.message}';
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        googleSignIn = false;
      });
    }
  }

  Future<void> login() async {
    setState(() {
      isLoggingIn = true;
      errorMessage = null;
    });
    try {
      final credResponse = await credentialManager.getPasswordCredentials(
        passKeyOption: CredentialLoginOptions(
          challenge: EncryptData.getEncodedChallenge(),
          rpId: rpId,
          userVerification: 'required',
        ),
      );
      //check if credentials are passwordbased,google or public key
      if (credResponse.passwordCredential != null) {
        final cred = credResponse.passwordCredential!;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              user: cred.username!,
            ),
          ),
        );
      } else if (credResponse.publicKeyCredential == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              user: username!,
            ),
          ),
        );
      } else if (credResponse.googleIdTokenCredential != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              user: username!,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        isLoggingIn = false;
      });
    }
  }

  Future<void> registerWithPassword() async {
    if (!passEnabled) {
      setState(() {
        passEnabled = true;
      });
      return;
    }
    if (username == null || username?.isEmpty == true) {
      setState(() {
        errorMessage = 'Please enter a username';
      });
      return;
    }
    //check if password is empty
    if (password == null || password?.isEmpty == true) {
      setState(() {
        errorMessage = 'Please enter a password';
      });
      return;
    }
    try {
      setState(() {
        isRegisterPassword = true;
        errorMessage = null;
      });
      await credentialManager.savePasswordCredentials(PasswordCredential(
        username: username!,
        password: password!,
      ));

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            user: username!,
          ),
        ),
      );
    } on CredentialException catch (e) {
      log("Error: ${e.message} ${e.code} ${e.details} ");
      setState(() {
        errorMessage = 'Error: ${e.message}';
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        isRegisterPassword = false;
      });
    }
  }

  Future<void> registerWithPassKey() async {
    setState(() {
      passEnabled = false;
      isRegistering = true;
      errorMessage = null;
    });
    try {
      await credentialManager.savePasskeyCredentials(
          request: CredentialCreationOptions.fromJson({
        "challenge": EncryptData.getEncodedChallenge(),
        "rp": {
          "name": "CredMan App Test",
          "id": rpId,
        },
        "user": {
          "id": EncryptData.getEncodedUserId(),
          "name": username,
          "displayName": username,
        },
        "pubKeyCredParams": [
          {"type": "public-key", "alg": -7},
          {"type": "public-key", "alg": -257}
        ],
        "timeout": 1800000,
        "attestation": "none",
        "excludeCredentials": [
          {"id": "ghi789", "type": "public-key"},
          {"id": "jkl012", "type": "public-key"}
        ],
        "authenticatorSelection": {
          "authenticatorAttachment": "platform",
          "residentKey": "required",
          "userVerification": "none"
        }
      }));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            user: username!,
          ),
        ),
      );
    } on CredentialException catch (e) {
      log("Error: ${e.message} ${e.code} ${e.details} ");
      setState(() {
        errorMessage = 'Error: ${e.message}';
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        isRegistering = false;
      });
    }
  }
}
