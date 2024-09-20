import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:untitled9/Home/home_screen.dart';
import 'package:untitled9/auth/login/login.dart';
import 'package:untitled9/auth/register/register.dart';
import 'package:untitled9/my_theme.dart';
import 'package:untitled9/provider/app_config_provider.dart';
import 'package:untitled9/provider/list_provider.dart';
import 'package:untitled9/provider/user_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyBAS91jQnzV_IXa9mRrbpYwC1tsQca2iIg",
          appId: "to-doapp12",
          messagingSenderId: "111027077675",
              projectId: "to-doapp12"))
      : await FirebaseFirestore.instance.disableNetwork();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppConfigProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
      },
      theme: MyThemeData.LightTheme,
      darkTheme: MyThemeData.darkTheme,
      themeMode: provider.appMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(provider.appLanguage),
    );
  }
}
