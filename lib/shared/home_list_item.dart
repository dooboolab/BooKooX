import 'package:bookoo2/models/LedgerItem.dart';
import 'package:flutter/material.dart';
import 'package:bookoo2/utils/asset.dart' as Asset;
import 'package:intl/intl.dart';
import 'package:bookoo2/models/User.dart';

class HomeListItem extends StatelessWidget {
  final LedgerItem ledgerItem;

  HomeListItem({
    Key key,
    this.ledgerItem,
  }) : super(key: key);

  List<Widget> buildLabelArea(
    String label, {
    User writer,
    BuildContext context,
  }) {
    List<Widget> labelArea = [];
    labelArea.add(
      Container(
        // margin: EdgeInsets.only(bottom: 8.0),
        child: Text(
          label,
          style: TextStyle(
            color: Theme.of(context).textTheme.title.color,
            fontSize: 16.0,
          ),
        ),
      ),
    );
    if (writer != null) {
      labelArea.add(
        Container(
          child: Text(
            writer.displayName,
            style: TextStyle(
              color: Theme.of(context).textTheme.subtitle.color,
              fontSize: 12.0,
            ),
          ),
        ),
      );
    }
    return labelArea;
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency();

    AssetImage _image = ledgerItem.category.getIconImage();
    String _label = ledgerItem.category.label;
    User _writer = ledgerItem.writer;
    bool _isPlus = ledgerItem.price > 0;
    String _priceFormatted = formatCurrency.format(ledgerItem.price ?? 0.0);
    String _priceToShow = (_isPlus ? '+ ' : '- ') +
        _priceFormatted.toString().replaceAll('-', '');

    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: () {
        print('onPress');
      },
      child: Container(
        height: 60,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Image(
                image: _image,
                fit: BoxFit.contain,
                width: 30.0,
                height: 30.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: buildLabelArea(
                  _label,
                  writer: _writer,
                  context: context,
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    _priceToShow,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: _isPlus
                            ? Theme.of(context).textTheme.title.color
                            : Asset.Colors.carnation),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
