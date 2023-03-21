import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 32.0,
          ),
          Image.asset(
            'assets/images/notifications.png',
            height: 150,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            'No Notifications',
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
