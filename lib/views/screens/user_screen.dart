import 'package:flutter/material.dart';
import 'package:travel_app/services/user_service.dart';
import 'package:travel_app/views/screens/login_screen.dart';
import 'package:travel_app/views/screens/welcome_screen.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User')),
      body: Center(
        child: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await UserService().logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
              );
            },
          ),
      ),
    );
  }
}