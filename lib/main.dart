import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meproject/screens/wrapper.dart';
import 'package:meproject/services/auth.dart';
import 'package:meproject/models/user.dart';
import 'package:provider/provider.dart';
import 'package:meproject/services/theme.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<UserN>(
          initialData: UserN(uid: ''),
          create: (_) => AuthServices().user,
        ),
        ChangeNotifierProvider<ThemeModel>(
          create: (_) => ThemeModel(),
        ),
      ],
      child: Consumer<ThemeModel>(
        builder: (context, themeModel, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeModel.isDark ? ThemeData.dark() : ThemeData.light(),
            home:const Wrapper(),
          );
            
        },
      ),
    );
  }
}

