import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wecount/navigations/auth_switch.dart';
import 'package:wecount/screens/sign_in.dart';
import 'package:wecount/screens/sign_up.dart';
import 'package:wecount/shared/button.dart' show Button;
import 'package:wecount/utils/asset.dart' as Asset;
import 'package:wecount/utils/colors.dart';
import 'package:wecount/utils/general.dart' show General;
import 'package:wecount/utils/localization.dart';

class Intro extends StatelessWidget {
  static const String name = '/intro';

  Future<void> _googleLogin(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
    );
    General.instance.showSpinnerDialog(
      text: t('SIGNING_IN_WITH_GOOGLE'),
    );

    GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      await storeUser(googleUser);
      googleSignIn.signOut();

      Get.offAll(AuthSwitch());
    } else {
      Get.back();
    }
  }

  Future<void> storeUser(GoogleSignInAccount googleUser) async {
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    UserCredential auth =
        await FirebaseAuth.instance.signInWithCredential(credential);
    User user = auth.user!;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'email': user.email,
      'displayName': user.displayName,
      'name': user.displayName,
      'googleId': googleAuth.idToken,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'deletedAt': null,
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle _signInWithTextStyle = TextStyle(
      color: Color.fromRGBO(255, 255, 255, 0.7),
      fontSize: 16.0,
    );

    Widget renderSignInBtn() {
      return Button(
        onPress: () => Get.to(() => SignIn.name),
        margin: EdgeInsets.only(top: 198.0),
        textStyle: TextStyle(
          fontSize: 16.0,
          color: Theme.of(context).primaryColor,
        ),
        backgroundColor: Colors.white,
        text: t('SIGN_IN'),
        width: 240.0,
        height: 56.0,
      );
    }

    Widget renderDoNotHaveAccount() {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 2.0),
        child: TextButton(
          onPressed: () =>
              General.instance.navigateScreenNamed(context, SignUp.name),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: t('DO_NOT_HAVE_ACCOUNT'),
                ),
                TextSpan(
                  text: '  ' + t('SIGN_UP'),
                  style: TextStyle(
                    color: greenColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    Widget renderOrSignInWith() {
      return Container(
        margin: EdgeInsets.only(top: 12.0),
        child: Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              child: Text(
                '----------------------',
                style: _signInWithTextStyle,
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
            Text(
              ' or sign in with ',
              style: _signInWithTextStyle,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
            Expanded(
              child: Text(
                '----------------------',
                style: _signInWithTextStyle,
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
          ],
        ),
      );
    }

    Widget renderGoogleSignInButton() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Button(
            margin: EdgeInsets.only(top: 20.0),
            imageMarginLeft: 8,
            textStyle: _signInWithTextStyle,
            borderColor: Colors.white,
            backgroundColor: Colors.transparent,
            text: 'Google',
            width: MediaQuery.of(context).size.width >
                    MediaQuery.of(context).size.height
                ? MediaQuery.of(context).size.width - 224
                : MediaQuery.of(context).size.width - 128,
            height: 52.0,
            image: Image(
              image: Asset.Icons.icGoogle,
              width: 24.0,
              height: 24.0,
            ),
            onPress: () => _googleLogin(context),
          ),
        ],
      );
    }

    Widget renderTermsAndAgreement() {
      var clickableTextStyle = TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.secondary,
        fontSize: 13,
      );

      return Container(
        margin: EdgeInsets.only(top: 16.0, bottom: 40.0),
        child: RichText(
          text: TextSpan(
            text: t('TERMS_1'),
            style: _signInWithTextStyle.merge(
              TextStyle(fontSize: 12, height: 1.3),
            ),
            children: [
              TextSpan(
                text: t('TERMS_OF_USE'),
                style: clickableTextStyle,
                semanticsLabel: t('TERMS_OF_USE'),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(
                      Uri.parse('https://dooboolab.com/termsofservice'),
                    );
                  },
              ),
              TextSpan(
                text: t('TERMS_2'),
                semanticsLabel: t('TERMS_2'),
              ),
              TextSpan(
                text: t('PRIVACY_POLICY'),
                style: clickableTextStyle,
                semanticsLabel: t('PRIVACY_POLICY'),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(
                      Uri.parse('https://dooboolab.com/privacyandpolicy'),
                    );
                  },
              ),
              TextSpan(
                text: t('TERMS_3'),
                semanticsLabel: t('TERMS_3'),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Scaffold(
      body: Container(
        child: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverPadding(
                padding:
                    const EdgeInsets.only(top: 148.0, left: 60.0, right: 60.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      Image(
                        image: Asset.Icons.icWeCount,
                        width: 200.0,
                        height: 60.0,
                      ),
                      renderSignInBtn(),
                      renderDoNotHaveAccount(),
                      renderOrSignInWith(),
                      renderGoogleSignInButton(),
                      renderTermsAndAgreement(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        constraints: BoxConstraints.expand(
          height: double.infinity,
          width: double.infinity,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColorDark
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
      ),
    );
  }
}
