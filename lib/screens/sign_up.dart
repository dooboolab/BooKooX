import 'package:flutter/material.dart';

import 'package:bookoo2/shared/edit_text.dart' show EditText;
import 'package:bookoo2/shared/button.dart' show Button;
import 'package:bookoo2/utils/localization.dart' show Localization;
import 'package:bookoo2/utils/validator.dart' show Validator;
import 'package:bookoo2/utils/asset.dart' as Asset;

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => new _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Localization _localization;
  String _email;
  String _emailError;
  String _password;
  String _passwordError;
  String _passwordConfirm;
  String _passwordConfirmError;
  bool _isEmail = false;
  bool _isPassword = false;

  void _onSignUp() {
    if (_email == null || _password == null) {
      print('_email or _password is null.');
      return;
    }

    bool isEmail = Validator.instance.validateEmail(_email);
    bool isPassword = Validator.instance.validatePassword(_password);

    if (!isEmail) {
      setState(() => _emailError = _localization.trans('NO_VALID_EMAIL'));
      return;
    }

    if (!isPassword) {
      setState(() => _passwordError = _localization.trans('PASSWORD_HINT'));
      return;
    }

    if (_passwordConfirm != _password) {
      setState(() => _passwordConfirmError = _localization.trans('PASSWORD_CONFIRM_HINT'));
      return;
    }
    print('onSignUp');
  }

  @override
  Widget build(BuildContext context) {
    _localization = Localization.of(context);

    Widget signUpText() {
      return Text(_localization.trans('SIGN_UP'),
        style: TextStyle(
          fontSize: 24.0,
          color: Theme.of(context).textTheme.title.color,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    Widget emailField() {
      return EditText(
        key: Key('email'),
        margin: EdgeInsets.only(top: 68.0),
        textInputAction: TextInputAction.next,
        textLabel: _localization.trans('EMAIL'),
        textHint: _localization.trans('EMAIL_HINT'),
        hasChecked: _isEmail ?? false,
        onChanged: (String str) {
          if (Validator.instance.validateEmail(str)) {
            setState(() {
              _isEmail = true;
              _emailError = null;
            });
          } else {
            setState(() => _isEmail = false);
          }
          _email = str;
        },
        errorText: _emailError,
        onSubmitted: (String str) => _onSignUp(),
      );
    }

    Widget passwordField() {
      return EditText(
        key: Key('password'),
        obscureText: true,
        margin: EdgeInsets.only(top: 24.0),
        textInputAction: TextInputAction.next,
        textLabel: _localization.trans('PASSWORD'),
        textHint: _localization.trans('PASSWORD_HINT'),
        isSecret: true,
        hasChecked: _isPassword,
        onChanged: (String str) {
          if (Validator.instance.validatePassword(str)) {
            setState(() {
              _isPassword = true;
              _passwordError = null;
            });
          } else {
            setState(() => _isPassword = false);
          }
          _password = str;
        },
        errorText: _passwordError,
        onSubmitted: (String str) => _onSignUp(),
      );
    }

    Widget passwordConfirmField() {
      return EditText(
        key: Key('password_confirm'),
        obscureText: true,
        margin: EdgeInsets.only(top: 24.0),
        textInputAction: TextInputAction.next,
        textLabel: _localization.trans('PASSWORD_CONFIRM'),
        textHint: _localization.trans('PASSWORD_CONFIRM_HINT'),
        isSecret: true,
        hasChecked: _passwordConfirm != null && _passwordConfirm != '' && _passwordConfirm == _password,
        onChanged: (String str) => setState(() {
          _passwordConfirm = str;
          if (str == _password) {
            _passwordConfirmError = null;
          }
        }),
        errorText: _passwordConfirmError,
        onSubmitted: (String str) => _onSignUp(),
      );
    }

    Widget signUpButton() {
      return Button(
        key: Key('signupButton'),
        onPress: () => _onSignUp(),
        margin: EdgeInsets.only(top: 28.0, bottom: 8.0),
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
        borderColor: Colors.white,
        backgroundColor: Asset.Colors.dusk,
        text: _localization.trans('SIGN_UP'),
        width: MediaQuery.of(context).size.width / 2- 64,
        height: 56.0,
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        brightness: Theme.of(context).brightness,
        elevation: 0.0,
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryIconTheme.color,
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.only(top: 44.0, left: 60.0, right: 60.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    signUpText(),
                    emailField(),
                    passwordField(),
                    passwordConfirmField(),
                    signUpButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
