import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _smsNotifications = false;
  bool _complaintUpdates = true;
  bool _feedbackResponses = true;
  bool _newFeatures = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Notification Channels',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SwitchListTile(
              title: const Text('Push Notifications'),
              subtitle: const Text('Receive notifications on your device'),
              value: _pushNotifications,
              onChanged: (bool value) {
                setState(() {
                  _pushNotifications = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Email Notifications'),
              subtitle: const Text('Receive updates via email'),
              value: _emailNotifications,
              onChanged: (bool value) {
                setState(() {
                  _emailNotifications = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('SMS Notifications'),
              subtitle: const Text('Receive updates via SMS'),
              value: _smsNotifications,
              onChanged: (bool value) {
                setState(() {
                  _smsNotifications = value;
                });
              },
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Notification Types',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SwitchListTile(
              title: const Text('Complaint Updates'),
              subtitle: const Text('Status changes and responses to your complaints'),
              value: _complaintUpdates,
              onChanged: (bool value) {
                setState(() {
                  _complaintUpdates = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Feedback Responses'),
              subtitle: const Text('Responses to your feedback'),
              value: _feedbackResponses,
              onChanged: (bool value) {
                setState(() {
                  _feedbackResponses = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('New Features'),
              subtitle: const Text('Updates about new app features'),
              value: _newFeatures,
              onChanged: (bool value) {
                setState(() {
                  _newFeatures = value;
                });
              },
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Note: You can customize your notification preferences at any time. Changes will be saved automatically.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}