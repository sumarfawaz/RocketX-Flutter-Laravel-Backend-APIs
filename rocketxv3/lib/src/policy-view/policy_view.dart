import 'package:flutter/material.dart';

class PolicyView extends StatelessWidget {
  const PolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy & Terms and Conditions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your privacy is important to us. We are committed to protecting the personal information you provide when using our services...',
            ),
            const SizedBox(height: 32),
            const Text(
              'Terms and Conditions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'By using our services, you agree to comply with the following terms and conditions...',
            ),
            // Add more text as needed
          ],
        ),
      ),
    );
  }
}
