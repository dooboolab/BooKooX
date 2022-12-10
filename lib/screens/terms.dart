import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Terms extends HookWidget {
  const Terms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          'Terms',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.only(top: 44.0, left: 60.0, right: 60.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
