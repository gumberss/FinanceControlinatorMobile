import 'dart:io';

import 'package:finance_controlinator_mobile/components/BusinessException.dart';
import 'package:finance_controlinator_mobile/components/JwtService.dart';
import 'package:finance_controlinator_mobile/components/Progress.dart';
import 'package:finance_controlinator_mobile/purchases/webclients/UserWebClient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../components/DefaultInput.dart';
import '../../components/toast.dart';
import '../../components/userService.dart';
import '../../dashboard/Dashboard.dart';
import '../domain/SignInUser.dart';
import '../webclients/AuthenticationWebClient.dart';
import 'SignUp.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sign In"),
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

  Future firebaseLogin(String userName, String password) async {
    var result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: userName, password: password);
    if (result.user != null) {
      await JwtService().store(result.user!.uid);
      await JwtService().storeUserId(result.user!.uid);
      var response = await UserWebClient().register(result.user!.uid);
      if (response.success() && response.data?.id != null) {
        await JwtService().storeUserId(response.data!.id!);
        UserSharedPreferencies()
            .storeUserNickname(response.data!.nickname ?? "");
      } else {
        throw BusinessException("Couldn't be possible to identify the user");
      }
    }
  }

  final bool _firebaseLogin = true;

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
                        if (_firebaseLogin) {
                          await firebaseLogin(userName, password);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (c) => const Dashboard()));
                          _passwordController.clear();
                          _animationController.reverse();
                        } else {
                          var result = await AuthenticationWebClient()
                              .signIn(SignInUser(userName, password));
                          if (result != null) {
                            await JwtService().store(result);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (c) => const Dashboard()));
                            _passwordController.clear();
                            _animationController.reverse();
                          } else {
                            _animationController.reverse();
                            DefaultToaster.toastError(widget.toast);
                          }
                        }
                      } on HttpException catch (e) {
                        _animationController.reverse();
                        DefaultToaster.toastError(widget.toast,message: e.message);
                      } on Exception {
                        _animationController.reverse();
                        DefaultToaster.toastError(widget.toast);
                      }
                    },
                    child: const Text("Let's go!")),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(right: 16, top: 16),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      onTap: () => {
                            Navigator.of(context)
                                .push<String>(
                                    MaterialPageRoute(builder: (c) => const SignUp()))
                                .then((value) {
                              if (value != null) {
                                _userNameController.text = value;
                              }
                            })
                          }),
                )),
            SlideTransition(
              position: _offsetAnimation,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Progress(),
              ),
            )
          ],
        ));
  }
}
