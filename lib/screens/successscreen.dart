import 'package:customer/screens/tabsscreen.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  static const routeName = '/success';
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Successfully Booked',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          height: 40.0,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                TabsScreen.routeName,
              );
            },
            child: const Text('Go To Homepage'),
          ),
        ),
      ),
    );
  }
}
