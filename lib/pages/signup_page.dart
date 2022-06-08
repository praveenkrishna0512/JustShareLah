// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:justsharelah_v1/components/auth_state.dart';
import 'package:justsharelah_v1/utils/constants.dart';
import 'package:justsharelah_v1/const_templates.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends AuthState<SignupPage> {
  bool _isLoading = false;
  late final TextEditingController _emailController;
  late final TextEditingController _usernameController;
  late final TextEditingController _firstnameController;
  late final TextEditingController _lastnameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _cfmpasswordController;

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    final response = await supabase.auth
        .signUp(_emailController.text, _passwordController.text);

    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    } else {
      context.showSnackBar(message: 'Sign Up Successful!');
      Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _cfmpasswordController = TextEditingController();
    _usernameController = TextEditingController();
    _firstnameController = TextEditingController();
    _lastnameController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _lastnameController.dispose();
    _firstnameController.dispose();
    _cfmpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          title: const Text("JustShareLah!"),
          backgroundColor: Colors.black,
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              alignment: Alignment.center,
              child: Text(
                'Register Your Details!',
                style: kHeadingText,
              ),
            ),

            SizedBox(
              height: 20.0,
            ),

            TextFormField(
              obscureText: false,
              textAlign: TextAlign.center,
              controller: _emailController,
              decoration: kTextFormFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                  labelText: 'Email',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),

            const SizedBox(height: 18),

            TextFormField(
              obscureText: false,
              textAlign: TextAlign.center,
              controller: _usernameController,
              decoration: kTextFormFieldDecoration.copyWith(
                  hintText: 'Enter your username',
                  labelText: 'Username',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),

            const SizedBox(height: 18),

            TextFormField(
              obscureText: false,
              textAlign: TextAlign.center,
              controller: _firstnameController,
              decoration: kTextFormFieldDecoration.copyWith(
                  hintText: 'Enter your first name',
                  labelText: 'First Name',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),

            const SizedBox(height: 18),

            TextFormField(
              obscureText: false,
              textAlign: TextAlign.center,
              controller: _lastnameController,
              decoration: kTextFormFieldDecoration.copyWith(
                  hintText: 'Enter your last name',
                  labelText: 'Last Name',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),

            const SizedBox(height: 18),
            //TODO: Make sure the passwords are the same
            TextFormField(
              obscureText: true,
              textAlign: TextAlign.center,
              controller: _passwordController,
              decoration: kTextFormFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                  labelText: 'Password',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),

            // make sure that the password is same - idk why but doesn't work
            const SizedBox(height: 18),
            TextFormField(
              obscureText: true,
              textAlign: TextAlign.center,
              controller: _cfmpasswordController,
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }

                return null;
              },
              decoration: kTextFormFieldDecoration.copyWith(
                  hintText: 'Enter the same password as above',
                  labelText: 'Confirm Password',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            const SizedBox(height: 120),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                        side: BorderSide(width: 4, color: Colors.black),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.all(20)),
                    onPressed: _isLoading ? null : _signUp,
                    child: Text(_isLoading ? 'Loading' : 'Register'),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    ]);
  }
}

//   ,)]),)
// Container(
//   padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
//   child: ListView(
//     children: [
//       const SizedBox(height: 32),
//       Center(
//         child: Text(
//           'Registration',
//           style: TextStyle(
//               fontSize:
//                   Theme.of(context).textTheme.headline4?.fontSize ??
//                       32),
