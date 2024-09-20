import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled9/auth/custom_txt_field.dart';
import 'package:untitled9/dialog.utils.dart';

import '../../Firebase -utils.dart';
import '../../Home/home_screen.dart';
import '../../model/my_user.dart';
import '../../provider/user_provider.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = 'register screen';
  TextEditingController nameController = TextEditingController(text: 'Jana');
  TextEditingController emailController =
      TextEditingController(text: 'jana@route.com');
  TextEditingController passwordController =
      TextEditingController(text: '123456');
  TextEditingController confirmPasswordController =
      TextEditingController(text: '123456');
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Welcome Back!',
                    textAlign: TextAlign.center,
                  ),
                ),
                CustomTxtForm(
                  label: 'Email',
                  controller: emailController,
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return 'Please enter Email.';
                    }
                    final bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(text);

                    if (!emailValid) {
                      return 'Please Enter valid Email';
                    }
                    return null;
                  },
                  KeyboardType: TextInputType.emailAddress,
                ),
                CustomTxtForm(
                  label: 'Password',
                  controller: passwordController,
                  validator: (text) {
                    if (text == null || text.trim().isEmpty) {
                      return 'Please enter Password.';
                    }
                    if (text.length < 6) {
                      return 'Password must be at least 6 chars.';
                    }
                    return null;
                  },
                  KeyboardType: TextInputType.number,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    onPressed: () {
                      register(context);
                    },
                    child: Text(
                      'Login',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }

  void register(BuildContext context) async {
    ///Valid == true , Not Valid == false , lw true hyb2a rg3 null
    ///show loading

    if (formKey.currentState?.validate() == true) {
      DialogUtils.showLoading(
        context: context,
        loadingLabel: 'Loading...',
      );
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        MyUser myUser = MyUser(
            id: credential.user?.uid ?? '',
            name: nameController.text,
            email: emailController.text);

        print('before database');
        await FirebaseUtils.addUserToFireStore(myUser);
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.updateUser(myUser);
        print('after database');

        //hide loading
        DialogUtils.hideLoading(context);
        //show message
        DialogUtils.showMessage(
            context: context,
            content: 'Register Successfully.',
            title: 'Success',
            posActionName: 'OK',
            posAction: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          //hide loading
          DialogUtils.hideLoading(context);
          //show message
          DialogUtils.showMessage(
              context: context,
              content: 'The password provided is too weak.',
              title: 'Error',
              posActionName: 'OK');
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          //hide loading
          DialogUtils.hideLoading(context);
          //show message
          DialogUtils.showMessage(
              context: context,
              content: 'The account already exists for that email.',
              title: 'Error',
              posActionName: 'OK');
          print('The account already exists for that email.');
        }
      } catch (e) {
        //hide loading
        DialogUtils.hideLoading(context);
        //show message
        DialogUtils.showMessage(
            context: context,
            content: e.toString(),
            title: 'Error',
            posActionName: 'OK');
        print(e);
      }
    }
  }
}