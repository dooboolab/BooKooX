import 'package:wecount/models/ledger_item.dart';
import 'package:wecount/utils/localization.dart';

List<LedgerItem> createCalendarLedgerItemMock() {
  List<LedgerItem> ledgerList = [];
  var currentMonth = DateTime.now().month;

  ledgerList.add(LedgerItem(
      price: -12000,
      category:
          Category(iconId: 8, label: t('EXERCISE'), type: CategoryType.consume),
      selectedDate: DateTime(2019, currentMonth, 10)));
  ledgerList.add(LedgerItem(
      price: 300000,
      category: Category(
          iconId: 18, label: t('WALLET_MONEY'), type: CategoryType.income),
      selectedDate: DateTime(2019, currentMonth, 10)));
  ledgerList.add(LedgerItem(
      price: -32000,
      category:
          Category(iconId: 4, label: t('DATING'), type: CategoryType.consume),
      selectedDate: DateTime(2019, currentMonth, 10)));
  ledgerList.add(LedgerItem(
      price: -3100,
      category:
          Category(iconId: 0, label: t('CAFE'), type: CategoryType.consume),
      selectedDate: DateTime(2019, currentMonth, 10)));
  ledgerList.add(LedgerItem(
      price: -3100,
      category:
          Category(iconId: 0, label: t('CAFE'), type: CategoryType.consume),
      selectedDate: DateTime(2019, currentMonth, 10)));
  ledgerList.add(LedgerItem(
      price: -3100,
      category:
          Category(iconId: 0, label: t('CAFE'), type: CategoryType.consume),
      selectedDate: DateTime(2019, currentMonth, 10)));
  ledgerList.add(LedgerItem(
      price: -3100,
      category:
          Category(iconId: 0, label: t('CAFE'), type: CategoryType.consume),
      selectedDate: DateTime(2019, currentMonth, 15)));
  ledgerList.add(LedgerItem(
      price: -12000,
      category:
          Category(iconId: 12, label: t('PRESENT'), type: CategoryType.consume),
      selectedDate: DateTime(2019, currentMonth, 15)));

  return ledgerList;
}
