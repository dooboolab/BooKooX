import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookoo2/models/User.dart';
import 'package:flutter/material.dart';
import 'package:bookoo2/utils/asset.dart' as Asset;

abstract class ListItem {}

class HeadingItem implements ListItem {
  final int numOfPeople;

  HeadingItem({
    this.numOfPeople = 0,
  });
}

class MemberItem implements ListItem {
  final User user;
  final Membership membership;

  MemberItem(this.user, this.membership);
}

class MemberListItem extends StatelessWidget {
  final Key key;
  final User user;
  final Membership membership;
  final Function onPressMember;
  final Function onPressAuth;

  const MemberListItem({
    this.key,
    @required this.user,
    @required this.membership,
    this.onPressMember,
    this.onPressAuth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      alignment: Alignment(-1, 0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              onPressed: this.onPressMember,
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                children: <Widget>[
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Container(
                        width: 52,
                        height: 52,
                        child: Image(
                          image: Asset.Icons.icMask,
                          width: 40,
                          height: 40,
                        ),
                      ),
                      membership == Membership.Owner
                      ? Positioned(
                        bottom: 0,
                        right: 0,
                        child: Image(
                          image: membership == Membership.Owner
                            ? Asset.Icons.icOwner
                            : Asset.Icons.icOwner,
                          width: 20,
                          height: 20,
                        ),
                      ) : Container(),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AutoSizeText(
                            user.email,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).textTheme.title.color,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            child: AutoSizeText(
                              user.email,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).textTheme.display2.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment(0,0),
            width: 80,
            height: double.infinity,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: this.onPressAuth,
              child: Text(
                membership == Membership.Owner
                ? 'Owner'
                : membership == Membership.Writer
                ? 'Writer'
                : 'Guest',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.display2.color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}