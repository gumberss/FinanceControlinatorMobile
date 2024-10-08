import 'dart:io';

import 'package:finance_controlinator_mobile/authentications/domain/SignUpUser.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../components/DefaultInput.dart';
import '../../expenses/components/DefaultToast.dart';
import '../services/EstimatePasswordStrength.dart';
import '../webclients/AuthenticationWebClient.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Register"),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Come with us!",
                style: TextStyle(
                    fontSize: 36, color: Theme.of(context).primaryColor)),
            _SignUpForm(),
          ]),
        )));
  }
}

class _SignUpForm extends StatelessWidget {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassowordController =
      TextEditingController();
  FToast toast;
  final _formKey;

  _SignUpForm()
      : toast = FToast(),
        _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    toast.init(context);

    return Form(
        key: _formKey,
        child: Column(
          children: [
            DefaultInput("Username", TextInputType.text, _userNameController,
                validator: (text) {
              return text == null || text.length < 4 || text.length > 30
                  ? "From 4 to 30 characters"
                  : null;
            }),
            DefaultInput("Email", TextInputType.text, _emailController),
            DefaultInput(
              "Password",
              TextInputType.visiblePassword,
              _passwordController,
              obscureText: true,
              validator: EstimatePasswordStrength().findErrorMessage,
            ),
            DefaultInput(
              "Confirm Password",
              TextInputType.visiblePassword,
              _confirmPassowordController,
              obscureText: true,
              validator: (pass) {
                return pass != _passwordController.text
                    ? "The password and confirm password are different :("
                    : null;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
              child: SizedBox(
                width: double.maxFinite,
                child: OutlinedButton(
                    onPressed: () async {
                      var isValidForm =
                          (_formKey.currentState?.validate() ?? false);
                      if (!isValidForm) return;

                      var username = _userNameController.text;
                      var email = _emailController.text;
                      var password = _passwordController.text;

                      try {
                        var result = await AuthenticationWebClient()
                            .signUp(SignUpUser(username, password, email));

                        if (result == 200) {
                          Navigator.of(context).pop(username);
                        } else {
                          toast.showToast(
                            child: DefaultToast.Error(
                                "Oh no! I think something goes wrong.\nTry again in a few minutes"),
                            gravity: ToastGravity.TOP_RIGHT,
                            toastDuration: const Duration(seconds: 2),
                          );
                        }
                      } on HttpException catch (e) {
                        toast.showToast(
                          child: DefaultToast.Error(e.message),
                          gravity: ToastGravity.TOP,
                          toastDuration: const Duration(seconds: 2),
                        );
                      }
                    },
                    child: const Text("I want to be part")),
              ),
            ),
          ],
        ));
  }
}
