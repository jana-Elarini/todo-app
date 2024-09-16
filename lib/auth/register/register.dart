import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = 'register_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Form(
              child: Column(
            children: [TextFormField()],
          ))
        ],
      ),
    );
  }
}
