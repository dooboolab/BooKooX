import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:wecount/mocks/home_calendar.mock.dart';
import 'package:wecount/models/ledger_item.dart';
import 'package:wecount/providers/current_ledger.dart';
import 'package:wecount/utils/navigation.dart';
import 'package:wecount/utils/routes.dart';
import 'package:wecount/widgets/date_selector.dart' show DateSelector;
import 'package:wecount/widgets/home_list_item.dart';
import 'package:wecount/types/color.dart';
import 'package:wecount/utils/localization.dart' show Localization;
import 'package:flutter/material.dart';
import 'package:wecount/utils/asset.dart' as Asset;

import 'package:wecount/widgets/home_header.dart' show HomeHeaderExpanded;
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart';

class HomeCalendar extends HookWidget {
  HomeCalendar({
    Key? key,
    this.title = '2022 WeCount',
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    var color = Provider.of<CurrentLedger>(context).getLedger() != null
        ? Provider.of<CurrentLedger>(context).getLedger()!.color
        : ColorType.DUSK;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: <Widget>[
          HomeHeaderExpanded(
            title: title,
            color: Asset.Colors.getColor(color),
            actions: [
              Container(
                width: 56.0,
                child: RawMaterialButton(
                  padding: EdgeInsets.all(0.0),
                  shape: CircleBorder(),
                  onPressed: () =>
                      navigation.push(context, AppRoute.ledgers.path),
                  child: Icon(
                    Icons.book,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                width: 56.0,
                child: RawMaterialButton(
                  padding: EdgeInsets.all(0.0),
                  shape: CircleBorder(),
                  onPressed: () => Navigator.of(context)
                      .pushNamed(AppRoute.ledgerItemEdit.fullPath),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              MyHomePage(),
            ]),
          )
        ],
      ),
    );
  }
}

class MyHomePage extends HookWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _currentDate = useState<DateTime?>(DateTime.now());
    var _targetDate = useState<DateTime?>(DateTime.now());
    var _currentMonth = useState<String>("");

    var _markedDateMap = useState<EventList<Event>?>(null);

    /// ledgerList from parents
    var _ledgerList = useState<List<LedgerItem>>([]);

    /// for bottom list UI
    List<LedgerItem> _ledgerListOfSelectedDate = [];

    void selectDate(
      DateTime date,
    ) {
      _ledgerListOfSelectedDate.clear();
      _ledgerList.value.forEach((item) {
        if (item.selectedDate == date) {
          _ledgerListOfSelectedDate.add(item);
        }
      });
      _currentDate.value = date;
      _targetDate.value = DateTime(date.year, date.month);
      _currentMonth.value = DateFormat.yMMM().format(date);
    }

    useEffect(() {
      _currentDate.value = DateTime.now();
      _targetDate.value = DateTime.now();
      _currentMonth.value = DateFormat.yMMM().format(_currentDate.value!);

      Future.delayed(Duration.zero, () {
        var _localization = Localization.of(context)!;

        List<LedgerItem> ledgerList =
            createCalendarLedgerItemMock(_localization);
        EventList<Event>? markedDateMap = EventList(events: {});
        ledgerList.forEach((ledger) {
          markedDateMap.add(ledger.selectedDate!,
              Event(date: ledger.selectedDate!, title: ledger.category!.label));
        });

        _ledgerList.value = ledgerList;
        _markedDateMap.value = markedDateMap;
      });
      return null;
    }, []);

    var color = Provider.of<CurrentLedger>(context).getLedger() != null
        ? Provider.of<CurrentLedger>(context).getLedger()!.color
        : ColorType.DUSK;

    void onDatePressed() async {
      int year = _currentDate.value!.year;
      int prevDate = year - 100;
      int lastDate = year + 10;
      DateTime? pickDate = await showDatePicker(
        context: context,
        initialDate: _currentDate.value!,
        firstDate: DateTime(prevDate),
        lastDate: DateTime(lastDate),
      );
      if (pickDate != null) {
        selectDate(pickDate);
      }
    }

    return SafeArea(
      top: false,
      child: Container(
        margin: EdgeInsets.only(left: 5, right: 5),
        child: Column(
          children: <Widget>[
            DateSelector(
              date: _currentMonth.value,
              onDatePressed: onDatePressed,
            ),
            renderCalendar(
                context: context,
                onCalendarChanged: (DateTime date) {
                  _currentMonth.value = DateFormat.yMMM().format(date);
                  _targetDate.value = date;
                },
                onDayPressed: (DateTime date, List<Event> events) {
                  selectDate(date);
                },
                markedDateMap: _markedDateMap.value,
                currentDate: _currentDate.value,
                targetDate: _targetDate.value,
                color: Asset.Colors.getColor(color)),
            Divider(
              color: Colors.grey,
              indent: 10,
              endIndent: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              itemCount: _ledgerListOfSelectedDate.length,
              itemBuilder: (BuildContext context, int index) {
                return HomeListItem(
                    ledgerItem: _ledgerListOfSelectedDate[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget renderCalendar({
  required BuildContext context,
  Function? onCalendarChanged,
  Function? onDayPressed,
  EventList<Event>? markedDateMap,
  DateTime? currentDate,
  DateTime? targetDate,
  required Color color,
}) {
  return CalendarCarousel<Event>(
    onCalendarChanged: onCalendarChanged as dynamic Function(DateTime)?,
    onDayPressed: onDayPressed as dynamic Function(DateTime, List<Event>)?,

    /// make calendar to be scrollable together with its screen
    customGridViewPhysics: NeverScrollableScrollPhysics(),

    /// marked Date
    markedDatesMap: markedDateMap,
    markedDateShowIcon: true,
    markedDateIconMaxShown: 1,
    markedDateIconBuilder: (event) {
      return renderMarkedIcon(
          color: Theme.of(context).accentColor, context: context);
    },

    /// selected date
    selectedDayButtonColor: color,
    selectedDateTime: currentDate,
    selectedDayTextStyle: TextStyle(
      color: Colors.white,
    ),

    pageSnapping: true,
    weekFormat: false,
    showHeader: false,
    thisMonthDayBorderColor: Colors.grey,
    height:
        MediaQuery.of(context).orientation == Orientation.portrait ? 380 : 490,
    childAspectRatio:
        MediaQuery.of(context).orientation == Orientation.portrait ? 1.0 : 1.5,
    targetDateTime: targetDate,

    /// weekday
    weekdayTextStyle: TextStyle(color: Theme.of(context).primaryColorLight),
    weekendTextStyle: TextStyle(
      color: Theme.of(context).primaryColorLight,
    ),
    daysTextStyle:
        TextStyle(color: Theme.of(context).textTheme.displayLarge!.color),
    todayBorderColor: Colors.green,
    todayTextStyle: TextStyle(
      color: Theme.of(context).primaryColor,
    ),
    todayButtonColor: Theme.of(context).hintColor,
    minSelectedDate: DateTime(1970, 1, 1),
    maxSelectedDate: DateTime.now().add(Duration(days: 3650)),
  );
}

Widget renderMarkedIcon({required Color color, required BuildContext context}) {
  return Container(
    child: Stack(
      children: <Widget>[
        Positioned(
          child: CustomPaint(painter: DrawCircle(color: color)),
          top: 7,
          right: MediaQuery.of(context).orientation == Orientation.portrait
              ? 0
              : 15,
          height: 5,
          width: 5,
        )
      ],
    ),
  );
}

class DrawCircle extends CustomPainter {
  late Paint _paint;

  DrawCircle({required Color color}) {
    _paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(0.0, 0.0), 3.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
