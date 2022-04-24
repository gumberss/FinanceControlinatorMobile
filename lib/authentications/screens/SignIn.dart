import 'dart:io';

import 'package:finance_controlinator_mobile/components/Progress.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../components/DefaultInput.dart';
import '../../dashboard/Dashboard.dart';
import '../../expenses/components/DefaultToast.dart';
import '../domain/SignInUser.dart';
import '../webclients/AuthenticationWebClient.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign In"),
        ),
        body: _SignInForm());
  }
}

class _SignInForm extends StatefulWidget {
  FToast toast;
  final _formKey;

  _SignInForm()
      : toast = FToast(),
        _formKey = GlobalKey<FormState>();

  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(-2, 0),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOutBack,
  ));
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    widget.toast.init(context);
    return Form(
        key: widget._formKey,
        child: Column(
          children: [
            DefaultInput("User Name", TextInputType.text, _userNameController,
                validator: (text) {
                  return text == null || text.isEmpty
                      ? "Uhhh, please, type your user name :)"
                      : null;
                }),
            DefaultInput(
              "Password",
              TextInputType.visiblePassword,
              _passwordController,
              obscureText: true,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
              child: SizedBox(
                width: double.maxFinite,
                child: OutlinedButton(
                    onPressed: () async {
                      var isValidForm =
                      (widget._formKey.currentState?.validate() ?? false);
                      if (!isValidForm) return;

                      _animationController.animateTo(1);

                      var userName = _userNameController.text;
                      var password = _passwordController.text;

                      try {
                        var result = await AuthenticationWebClient()
                            .signIn(SignInUser(userName, password));

                        if (result == 200) {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (c) => Dashboard()));
                          _passwordController.clear();
                          _animationController.reverse();
                        } else {
                          _animationController.reverse();
                          _ToastError();
                        }
                      } on HttpException catch (e) {
                        _animationController.reverse();
                        _ToastError(message: e.message);
                      } on Exception catch (e) {
                        _animationController.reverse();
                        _ToastError();
                      }
                    },
                    child: Text("Let's go!")),
              ),
            ),
            SlideTransition(
              position: _offsetAnimation,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Progress(),
              ),
            )
          ],
        ));
  }

  void _ToastError({String message =
  "Oh no! I think something goes wrong.\nTry again in a few minutes"}) {
    widget.toast.showToast(
      child: DefaultToast.Error(message),
      gravity: ToastGravity.TOP_RIGHT,
      toastDuration: const Duration(seconds: 2),
    );
  }
}
