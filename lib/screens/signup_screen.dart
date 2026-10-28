import 'package:flutter/material.dart';

import 'success_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // 🔑 The Global Key - acts like a remote control for the form
  final _formKey = GlobalKey<FormState>();

  // 📝 Controllers to track what the user types
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // State fields — add near your controllers
  DateTime? _birthDate;
  final _dateController = TextEditingController();

  bool _obscurePassword = true;
  bool _submitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true); // potion starts brewing

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return; // user may have left the screen

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessScreen(userName: _nameController.text.trim()),
      ),
    );
  }

  // Task A
  static const String _tipCategory = 'password_help';
  static const Map<String, List<String>> _localTips = {
    'password_help': [
      'Use a long, unique passphrase for each account. Avoid reusing passwords from other sites.',
      'A password manager can help you create and store unique passwords.',
      'Avoid common words, predictable sequences, and personal details in your password.',
    ],
  };
  static const String _localTipError =
      'Demo error: the local tip could not be loaded. Tap Retry to show a preset tip.';

  bool _isTipLoading = false;
  String? _tipText;
  String? _tipError;
  int _nextTipIndex = 0;

  Future<void> _getSignupTip({bool simulateError = false}) async {
    if (_isTipLoading) return;

    setState(() {
      _isTipLoading = true;
      _tipText = null;
      _tipError = null;
    });

    // Simulate local loading only: no HTTP request or model call.
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    setState(() {
      _isTipLoading = false;
      if (simulateError) {
        _tipError = _localTipError;
      } else {
        final tips = _localTips[_tipCategory]!;
        _tipText = tips[_nextTipIndex];
        _nextTipIndex = (_nextTipIndex + 1) % tips.length;
      }
    });
  }

  Widget _buildSignupTipPanel() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Local demo signup tip',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Preset demo content, not AI-generated advice. No live model is called. '
              'Tips do not approve or reject signup or replace form validation.',
            ),
            const SizedBox(height: 12),
            if (_isTipLoading)
              const Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Loading local demo tip...'),
                ],
              )
            else
              Semantics(
                liveRegion: true,
                child: Text(
                  _tipError ??
                      _tipText ??
                      'Tap Get a signup tip to see a preset tip.',
                ),
              ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _isTipLoading ? null : () => _getSignupTip(),
                  child: Text(_tipError == null ? 'Get a signup tip' : 'Retry'),
                ),
                TextButton(
                  onPressed: _isTipLoading
                      ? null
                      : () => _getSignupTip(simulateError: true),
                  child: const Text('Test local error'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 👨 Parent
      appBar: AppBar(
        title: const Text(
          'Do you dare sign the guest book?',
        ),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // 👶 Child
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Create Your Account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // 👤 Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 📧 Email Field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 🔒 Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // 🚀 Sign Up Button
              TextFormField(
                controller: _dateController,
                readOnly: true, // taps open the picker, not the keyboard
                decoration: const InputDecoration(
                  labelText: 'Birth Date',
                  prefixIcon: Icon(Icons.cake),
                  border: OutlineInputBorder(),
                ),
                validator: (_) =>
                    _birthDate == null ? 'Pick your birth date' : null,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _birthDate ?? DateTime(2008),
                    firstDate: DateTime(1920),
                    lastDate: DateTime.now(), // no future birthdays!
                  );
                  if (!mounted) return;
                  if (picked != null) {
                    setState(() {
                      _birthDate = picked;
                      _dateController.text =
                          '${picked.month}/${picked.day}/${picked.year}';
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitting ? null : _submit, // null = disabled
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Join the Mansion',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
              const SizedBox(height: 24),
              _buildSignupTipPanel(),
            ],
          ),
        ),
      ),
    );
  }
}
