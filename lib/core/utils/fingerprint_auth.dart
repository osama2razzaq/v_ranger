import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintAuthPage extends StatefulWidget {
  @override
  _FingerprintAuthPageState createState() => _FingerprintAuthPageState();
}

class _FingerprintAuthPageState extends State<FingerprintAuthPage> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticated = false;

  Future<void> _authenticate() async {
    try {
      _isAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access this feature',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fingerprint Authentication'),
      ),
      body: Center(
        child: _isAuthenticated
            ? Text('Authenticated')
            : ElevatedButton(
                onPressed: _authenticate,
                child: Text('Authenticate with Fingerprint'),
              ),
      ),
    );
  }
}
