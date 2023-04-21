import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meproject/models/user.dart';
import 'package:meproject/screens/Home/home.dart';
import 'package:meproject/screens/Authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserN>(context);
    if (user.uid == '') {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
