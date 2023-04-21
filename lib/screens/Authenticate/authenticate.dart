import 'package:flutter/material.dart';
import 'package:meproject/screens/Authenticate/register.dart';
import 'package:meproject/screens/Authenticate/signin.dart';
import 'package:provider/provider.dart';
import 'package:meproject/services/theme.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    // Other light mode colors and styles
  );

  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    // Other dark mode colors and styles
  );

  // bool _isDarkModeEnabled = false;
  // void toggleTheme() {
  //   _isDarkModeEnabled = !_isDarkModeEnabled;
  
  //   if (_isDarkModeEnabled) {
  //     Provider.of<ThemeChanger>(context, listen: false).setTheme(darkTheme);
  //   } else {
  //     Provider.of<ThemeChanger>(context, listen: false).setTheme(lightTheme);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
