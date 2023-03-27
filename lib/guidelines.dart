import 'package:flutter/material.dart';

class CommunityGuidelinesScreen extends StatelessWidget {
  const CommunityGuidelinesScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Guidelines'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Community Guidelines',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Respect other users: Treat others with respect and kindness. '
              'Don\'t harass, bully, or threaten other users. '
              'Don\'t use hate speech, discriminatory language, or slurs.',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              'No illegal activity: Don\'t use our app to promote illegal activity. '
              'This includes sharing content that promotes drug use, weapons, '
              'terrorism, or other illegal activities.',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              'No explicit content: Our app is intended for a general audience. '
              'Don\'t post explicit content, including nudity, pornography, '
              'or sexually suggestive content.',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Protect user privacy: Don\'t share personal information about '
              'other users without their permission. Don\'t use our app to collect '
              'personal information about users.',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              'No spam or scams: Don\'t use our app to send spam or engage in '
              'fraudulent activity. This includes sending unsolicited messages, '
              'creating fake accounts, or scamming other users.',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Report violations: If you see content or behavior that violates '
              'our community guidelines, please report it to us. We will take '
              'appropriate action to address the issue.'
              'Reporting can be done by viewing the post and selecting the report icon.'
              'Describe the reason',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 32.0),
            const Text(
              'By using this app, you agree that all the data you post can be used '
              'by the app developer as necessary.',
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 32.0),
            const Text(
              'By using this app, you agree that all the data you post can be used ',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
