import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  
  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: MyCustomForm(),
      );
  }

}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 70),
            //username
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Username is invalid';
                }
                RegExp regex = RegExp(r'^(?=(.*[A-Za-z]){3,})(?=(.*\d){3,}).+$');
                if (!regex.hasMatch(value)) {
                  return 'Username is invalid';
                }
                return null;
              },
              controller: _usernameController,
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 12.0),
            //password
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              controller: _passwordController,
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12.0),
            //passwordConfirm
            TextFormField(
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Confirm Password doesn\'t match Password';
                }
                return null;
              },
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Confirm Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12.0),
            //EmailAddress
            TextFormField(
              validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Email Address';
                  }
                  return null;
                },
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Email Address',
              ),
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
                child: const Text('SIGN UP'),
                onPressed: () { 
                  if (_formKey.currentState!.validate()) {
                    Navigator.popUntil(context, ModalRoute.withName('/login'));
                  }
                },
            ),
            
          ],
        ),
    );
  }
}