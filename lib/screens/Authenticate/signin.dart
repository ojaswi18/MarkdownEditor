import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:meproject/services/auth.dart';
import 'package:meproject/services/theme.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthServices _auth = AuthServices();
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String error = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          title: const Text("Sign In page"),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: const Icon(Icons.person),
              label: const Text("Register"),
            ),
          ],
          backgroundColor: Colors.brown[400],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    validator: (val) => EmailValidator.validate(email)
                        ? null
                        : "Email Id Incorrect",
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    }),
                const SizedBox(height: 20.0),
                TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    validator: (val) => val == null
                        ? "enter valid password"
                        : val.length < 6
                            ? "password incorrect"
                            : null,
                    obscureText: true,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    }),
                const SizedBox(height: 40.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      dynamic result = await _auth.signInWithEmailAndPassword(
                          email, password);
                      if (result == null) {
                        setState(() {
                          isLoading = false;
                          error = "Invalid Credentials";
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(error),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Sign In'),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      );
    });
  }
}
