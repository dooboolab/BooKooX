import 'package:flutter/material.dart';

import 'package:wecount/models/ledger.dart';
import 'package:wecount/utils/asset.dart' as asset;
import 'package:wecount/utils/localization.dart' show Localization;
import 'package:wecount/types/color.dart' show ColorType;

abstract class ListItem {}

class HeadingItem implements ListItem {
  final String displayName;
  final String email;
  final String imgStr;

  HeadingItem(this.displayName, this.email, this.imgStr);
}

class LedgerItem implements ListItem {
  final Ledger ledger;
  final bool isOwner;

  LedgerItem(this.ledger, this.isOwner);
}

class LedgerListItem extends StatelessWidget {
  const LedgerListItem({
    super.key,
    this.title,
    this.color,
    this.people,
    this.isOwner,
    this.onMorePressed,
    this.onLedgerPressed,
  });

  final String? title;
  final ColorType? color;
  final int? people;
  final bool? isOwner;
  final Function? onMorePressed;
  final Function? onLedgerPressed;

  @override
  Widget build(BuildContext context) {
    var localization = Localization.of(context)!;
    return SizedBox(
      height: 100.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: MaterialButton(
              padding: const EdgeInsets.only(left: 24.0),
              onPressed: onLedgerPressed as void Function()?,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 48.0,
                    height: 48.0,
                    child: Stack(
                      children: <Widget>[
                        ClipOval(
                          child: Image(
                            image: color == ColorType.red
                                ? asset.Icons.icRed
                                : color == ColorType.orange
                                    ? asset.Icons.icOrange
                                    : color == ColorType.yellow
                                        ? asset.Icons.icYellow
                                        : color == ColorType.green
                                            ? asset.Icons.icGreen
                                            : color == ColorType.blue
                                                ? asset.Icons.icBlue
                                                : color == ColorType.purple
                                                    ? asset.Icons.icPurple
                                                    : asset.Icons.icDusk,
                            fit: BoxFit.cover,
                            width: 40.0,
                            height: 40.0,
                          ),
                        ),
                        isOwner!
                            ? Positioned(
                                right: 4,
                                bottom: 4,
                                child: Image(
                                  image: asset.Icons.icOwner,
                                  width: 20,
                                  height: 20,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            title!,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Text(
                          people! > 1
                              ? '$people ${localization.trans("PEOPLE")}'
                              : '$people ${localization.trans("PERSON")}',
                          style: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: onMorePressed as void Function()?,
            child: SizedBox(
              height: double.infinity,
              child: Center(
                child: Text(
                  localization.trans('MORE')!,
                  style: const TextStyle(
                    color: asset.Colors.green,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
