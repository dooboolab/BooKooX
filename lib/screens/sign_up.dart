import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:wecount/utils/general.dart' show General;
import 'package:wecount/shared/edit_text.dart' show EditText;
import 'package:wecount/shared/button.dart' show Button;
import 'package:wecount/utils/localization.dart' show Localization;
import 'package:wecount/utils/validator.dart' show Validator;
import 'package:wecount/utils/asset.dart' as Asset;

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

class SignUp extends StatefulWidget {
  static const String name = '/sign_up';

  SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Localization? _localization;

  String? _email;
  String? _password;
  String? _passwordConfirm;
  String? _displayName;
  String? _name;

  String? _errorEmail;
  String? _errorPassword;
  String? _errorPasswordConfirm;
  String? _errorDisplayName;
  String? _errorName;

  bool _isValidEmail = false;
  bool _isValidPassword = false;
  bool _isValidDisplayName = false;
  bool _isValidName = false;
  bool _isRegistering = false;

  void _signUp() async {
    if (_email == null ||
        _password == null ||
        _passwordConfirm == null ||
        _displayName == null ||
        _name == null) {
      return;
    }

    if (!_isValidEmail) {
      setState(() => _errorEmail = _localization!.trans('NO_VALID_EMAIL'));
      return;
    }

    if (!_isValidPassword) {
      setState(() => _errorPassword = _localization!.trans('PASSWORD_HINT'));
      return;
    }

    if (_passwordConfirm != _password) {
      setState(() => _errorPasswordConfirm =
          _localization!.trans('PASSWORD_CONFIRM_HINT'));
      return;
    }

    if (!_isValidDisplayName) {
      setState(
          () => _errorDisplayName = _localization!.trans('DISPLAY_NAME_HINT'));
      return;
    }

    if (!_isValidName) {
      setState(() => _errorName = _localization!.trans('NAME_HINT'));
      return;
    }

    setState(() => _isRegistering = true);

    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(
        email: _email!,
        password: _password!,
      ))
          .user;

      if (user != null) {
        await user.sendEmailVerification();
        await firestore.collection('users').doc(user.uid).set({
          'email': _email,
          'displayName': _displayName,
          'name': _name,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'deletedAt': null,
        });

        user.updateDisplayName(_displayName);

        return General.instance.showSingleDialog(
          context,
          title: Text(_localization!.trans('SIGN_UP_SUCCESS_TITLE')!),
          content: Text(_localization!.trans('SIGN_UP_SUCCESS_CONTENT')!),
          onPress: () {
            _auth.signOut();
            Navigator.of(context).pop();
          },
        );
      }

      throw Error();
    } catch (err) {
      General.instance.showSingleDialog(
        context,
        title: Text(_localization!.trans('SIGN_UP_ERROR_TITLE')!),
        content: Text(_localization!.trans('SIGN_UP_ERROR_CONTENT')!),
      );
    } finally {
      setState(() => _isRegistering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    _localization = Localization.of(context);

    Widget renderSignUpText() {
      return Text(
        _localization!.trans('SIGN_UP')!,
        style: TextStyle(
          fontSize: 24.0,
          color: Theme.of(context).textTheme.headline1!.color,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    Widget renderEmailField() {
      return EditText(
        key: Key('email'),
        margin: EdgeInsets.only(top: 68.0),
        textInputAction: TextInputAction.next,
        textLabel: _localization!.trans('EMAIL'),
        textHint: _localization!.trans('EMAIL_HINT'),
        hasChecked: _isValidEmail,
        onChanged: (String str) {
          if (Validator.instance.validateEmail(str)) {
            setState(() {
              _isValidEmail = true;
              _errorEmail = null;
            });
          } else {
            setState(() => _isValidEmail = false);
          }
          _email = str;
        },
        errorText: _errorEmail,
        onSubmitted: (String str) => _signUp(),
      );
    }

    Widget renderPasswordField() {
      return EditText(
        key: Key('password'),
        margin: EdgeInsets.only(top: 24.0),
        textInputAction: TextInputAction.next,
        textLabel: _localization!.trans('PASSWORD'),
        textHint: _localization!.trans('PASSWORD_HINT'),
        isSecret: true,
        hasChecked: _isValidPassword,
        onChanged: (String str) {
          if (Validator.instance.validatePassword(str)) {
            setState(() {
              _isValidPassword = true;
              _errorPassword = null;
            });
          } else {
            setState(() => _isValidPassword = false);
          }
          _password = str;
        },
        errorText: _errorPassword,
        onSubmitted: (String str) => _signUp(),
      );
    }

    Widget renderPasswordConfirmField() {
      return EditText(
        key: Key('password-confirm'),
        margin: EdgeInsets.only(top: 24.0),
        textInputAction: TextInputAction.next,
        textLabel: _localization!.trans('PASSWORD_CONFIRM'),
        textHint: _localization!.trans('PASSWORD_CONFIRM_HINT'),
        isSecret: true,
        hasChecked: _passwordConfirm != null &&
            _passwordConfirm != '' &&
            _passwordConfirm == _password,
        onChanged: (String str) => setState(() {
          _passwordConfirm = str;
          if (str == _password) {
            _errorPasswordConfirm = null;
          }
        }),
        errorText: _errorPasswordConfirm,
        onSubmitted: (String str) => _signUp(),
      );
    }

    Widget renderDisplayNameField() {
      return EditText(
        key: Key('display-name'),
        margin: EdgeInsets.only(top: 24.0),
        textInputAction: TextInputAction.next,
        textLabel: _localization!.trans('DISPLAY_NAME'),
        textHint: _localization!.trans('DISPLAY_NAME_HINT'),
        hasChecked: _isValidDisplayName,
        onChanged: (String str) {
          if (Validator.instance.validateNicknameOrName(str)) {
            setState(() {
              _isValidDisplayName = true;
              _errorDisplayName = null;
            });
          } else {
            setState(() => _isValidDisplayName = false);
          }
          _displayName = str;
        },
        errorText: _errorDisplayName,
        onSubmitted: (String str) => _signUp(),
      );
    }

    Widget renderNameField() {
      return EditText(
        key: Key('name'),
        margin: EdgeInsets.only(top: 24.0),
        textInputAction: TextInputAction.next,
        textLabel: _localization!.trans('NAME'),
        textHint: _localization!.trans('NAME_HINT'),
        hasChecked: _isValidName,
        onChanged: (String str) {
          if (Validator.instance.validateNicknameOrName(str)) {
            setState(() {
              _isValidName = true;
              _errorName = null;
            });
          } else {
            setState(() => _isValidName = false);
          }
          _name = str;
        },
        errorText: _errorName,
        onSubmitted: (String str) => _signUp(),
      );
    }

    Widget renderSignUpButton() {
      return Button(
        key: Key('button-sign-up'),
        isLoading: _isRegistering,
        onPress: () => _signUp(),
        margin: EdgeInsets.only(top: 36.0, bottom: 48.0),
        textStyle: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
        borderColor: Colors.white,
        backgroundColor: Asset.Colors.main,
        text: _localization!.trans('SIGN_UP'),
        width: MediaQuery.of(context).size.width / 2 - 64,
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
          color: Theme.of(context).textTheme.headline1!.color,
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding:
                  const EdgeInsets.only(top: 44.0, left: 60.0, right: 60.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    renderSignUpText(),
                    renderEmailField(),
                    renderPasswordField(),
                    renderPasswordConfirmField(),
                    renderDisplayNameField(),
                    renderNameField(),
                    renderSignUpButton(),
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
