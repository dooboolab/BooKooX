import 'package:flutter/material.dart';
import 'package:wecount/screens/ledger_edit.dart';
import 'package:wecount/screens/setting.dart';

import 'package:wecount/shared/button.dart' show Button;
import 'package:wecount/utils/general.dart';
import 'package:wecount/utils/localization.dart' show Localization;

import '../shared/home_header.dart' show renderHomeAppBar;

class MainEmpty extends StatefulWidget {
  static const String name = '/main_empty';

  MainEmpty({
    Key? key,
    this.title = '',
  }) : super(key: key);
  final String title;

  @override
  _MainEmptyState createState() => new _MainEmptyState();
}

class _MainEmptyState extends State<MainEmpty> {
  @override
  Widget build(BuildContext context) {
    var _localization = Localization.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: renderHomeAppBar(
        context: context,
        title: '',
        actions: [
          Container(
            width: 56.0,
            child: RawMaterialButton(
              padding: EdgeInsets.all(0.0),
              shape: CircleBorder(),
              onPressed: () =>
                  General.instance.navigateScreenNamed(context, Setting.name),
              child: Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.sentiment_dissatisfied,
              color: Theme.of(context).primaryColorLight,
              size: 80,
            ),
            Container(
              margin: EdgeInsets.only(
                left: 40,
                right: 40,
                top: 22,
                bottom: 32,
              ),
              child: Text(
                _localization.trans('NO_LEDGER_DESCRIPTION')!,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1!.color,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Button(
              backgroundColor: Colors.transparent,
              width: 160,
              height: 56,
              shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
                side: BorderSide(
                  color: Theme.of(context).textTheme.headline2!.color!,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              onPress: () => Navigator.of(context).pushNamed(LedgerEdit.name),
              text: _localization.trans('ADD_LEDGER'),
              textStyle: TextStyle(
                fontSize: 20,
                color: Theme.of(context).textTheme.headline2!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
