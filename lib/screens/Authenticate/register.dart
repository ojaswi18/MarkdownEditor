import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:meproject/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthServices _auth = AuthServices();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool isLoading = false;
  String errorText = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        title: const Text("Register page"),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              widget.toggleView();
            },
            icon: const Icon(Icons.person),
            label: const Text("SignIn"),
          ),
        ],
        backgroundColor: const Color.fromARGB(146, 141, 110, 99),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
            key: _formKey,
            child: Column(children: [
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                onChanged: (val) {
                  setState(() {
                    email = val.toLowerCase(); 
                  });
                },
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please enter your email';
                  } else if (!EmailValidator.validate(val)) {
                    return 'Please enter a valid email';
                  } else if (val.contains(RegExp(r'[A-Z]'))) {
                    return 'Email should not have capital letters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  validator: (val) => val == null
                      ? "enter valid password"
                      : val.length < 6
                          ? "enter valid password"
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
                    dynamic result =
                        await _auth.registerWithEandPassword(email, password);
                    if (result == null) {
                      setState(() {
                        error = "register with valid email";
                        isLoading = false;
                      });
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fix the errors"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Register'),
              ),
              const SizedBox(height: 20.0),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ])),
      ),
    );
  }
}
