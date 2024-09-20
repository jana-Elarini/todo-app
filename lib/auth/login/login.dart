import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled9/app-colors.dart';
import 'package:untitled9/auth/custom_txt_field.dart';
import 'package:untitled9/auth/register/register.dart';

import '../../Firebase -utils.dart';
import '../../Home/home_screen.dart';
import '../../dialog.utils.dart';
import '../../provider/user_provider.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = 'login_screen';

  TextEditingController emailController =
      TextEditingController(text: 'jana@route.com');
  TextEditingController passwordController =
      TextEditingController(text: '123456');
  var formKey = GlobalKey<FormState>();
  late UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Welcome Back!',
                textAlign: TextAlign.center,
              ),
            ),
            Form(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                      login(context);
                    },
                    child: Text(
                      'Login',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(RegisterScreen.routeName);
                    },
                    child: Text(
                      'Or Create Account ',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primaryColor, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }

  void login(BuildContext context) async {
    /////show loading
    if (formKey.currentState?.validate() == true) {
      try {
        DialogUtils.showLoading(context: context, loadingLabel: 'Waiting');
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
          //hide loading
          //show message
        );

        var user = await FirebaseUtils.readUserFromFireStore(
            credential.user?.uid ?? '');
        if (user == null) {
          return;
        }

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.updateUser(user);

        //hide loading
        DialogUtils.hideLoading(context);
        //show message
        DialogUtils.showMessage(
            context: context,
            content: 'Login Successfully.',
            title: 'Success',
            posActionName: 'OK',
            posAction: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            });
        print(credential.user?.uid ?? "");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-credential') {
          //hide loading
          DialogUtils.hideLoading(context);
          //show message
          DialogUtils.showMessage(
              context: context,
              content:
                  'The supplied auth credential is incorrect, malformed or has expired.',
              title: 'Error',
              posActionName: 'OK');
          print(
              'The supplied auth credential is incorrect, malformed or has expired.');
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
        print(e.toString());
      }
    }
  }
}
