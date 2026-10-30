import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _register = false;
  bool _loading = false;

  Future<void> _submit() async {
    if (_email.text.trim().isEmpty || _password.text.length < 6) {
      _message('Enter an email and a password with at least 6 characters.');
      return;
    }
    setState(() => _loading = true);
    try {
      if (_register) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text,
        );
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text,
        );
      }
    } on FirebaseAuthException catch (e) {
      _message(e.message ?? 'Authentication failed.');
    } catch (_) {
      _message('Something went wrong. Check your Firebase configuration.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _message(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.water_drop, size: 72, color: Color(0xFF087E8B)),
                const SizedBox(height: 12),
                Text('Jal Raksha', textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
                const Text('Every drop counts.', textAlign: TextAlign.center),
                const SizedBox(height: 32),
                TextField(controller: _email, keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email')),
                const SizedBox(height: 12),
                TextField(controller: _password, obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password')),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading ? const CircularProgressIndicator() : Text(_register ? 'Create account' : 'Sign in'),
                ),
                TextButton(
                  onPressed: () => setState(() => _register = !_register),
                  child: Text(_register ? 'Already registered? Sign in' : 'New here? Create an account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
