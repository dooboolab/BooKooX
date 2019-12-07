import 'package:bookoo2/mocks/home_calendar.mock.dart';
import 'package:bookoo2/models/LedgerItem.dart';
import 'package:bookoo2/shared/date_selector.dart' show DateSelector;
import 'package:bookoo2/shared/home_list_item.dart';
import 'package:bookoo2/utils/localization.dart' show Localization;
import 'package:flutter/material.dart';

import 'package:bookoo2/utils/general.dart';
import 'package:bookoo2/shared/home_header.dart' show HomeHeaderExpanded;
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

class HomeCalendar extends StatefulWidget {
  HomeCalendar({
    Key key,
    this.title = '2017 Bookoo',
  }) : super(key: key);
  final String title;

  @override
  _HomeCalendarState createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendar> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: CustomScrollView(
        slivers: <Widget>[
          HomeHeaderExpanded(
            title: widget.title,
            actions: [
              Container(
                width: 56.0,
                child: RawMaterialButton(
                  padding: EdgeInsets.all(0.0),
                  shape: CircleBorder(),
                  onPressed: () =>
                      General.instance.navigateScreenNamed(context, '/ledgers'),
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
                  onPressed: () => General.instance
                      .navigateScreenNamed(context, '/ledger_item_add'),
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _currentDate;
  String _currentMonth = '';

  EventList<Event> _markedDateMap = EventList<Event>();

  /// ledgerList from parents
  List<LedgerItem> _ledgerList = List<LedgerItem>();

  /// for bottom list UI
  List<LedgerItem> _ledgerListOfSelectedDate = List<LedgerItem>();

  void selectDate(
    DateTime date,
  ) {
    setState(() {
      _currentDate = date;
      _ledgerListOfSelectedDate.clear();
      _ledgerList.forEach((item) {
        if (item.selectedDate == date) {
          _ledgerListOfSelectedDate.add(item);
        }
      });
    });
    _currentMonth = DateFormat.yMMM().format(date);
  }

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _currentMonth = DateFormat.yMMM().format(_currentDate);

    Future.delayed(Duration.zero, () {
      var _localization = Localization.of(context);

      List<LedgerItem> ledgerList = createCalendarLedgerItemMock(_localization);
      EventList<Event> markedDateMap = new EventList<Event>();
      ledgerList.forEach((ledger) {
        markedDateMap.add(ledger.selectedDate,
            Event(date: ledger.selectedDate, title: ledger.category.label));
      });
      
      this.setState(() {
        this._ledgerList = ledgerList;
        this._markedDateMap = markedDateMap;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void onDatePressed() async {
      int year = this._currentDate.year;
      int prevDate = year - 100;
      int lastDate = year + 10;
      DateTime pickDate = await showDatePicker(
        context: context,
        initialDate: this._currentDate,
        firstDate: DateTime(prevDate),
        lastDate: DateTime(lastDate),
      );
      if (pickDate != null) {
        this.selectDate(pickDate);
      }
    }

    return SafeArea(
      top: false,
      child: Container(
        margin: EdgeInsets.only(left: 5, right: 5),
        child: Column(
          children: <Widget>[
            DateSelector(
              date: this._currentMonth,
              onDatePressed: onDatePressed,
            ),
            calendar(
              context: context,
              onCalendarChanged: (DateTime date) {
                this.setState(
                    () => _currentMonth = DateFormat.yMMM().format(date));
              },
              onDayPressed: (DateTime date, List<Event> events) {
                this.selectDate(date);
              },
              markedDateMap: _markedDateMap,
              currentDate: _currentDate,
            ),
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

Widget calendar({
  context,
  onCalendarChanged,
  onDayPressed,
  markedDateMap,
  currentDate,
}) {
  return CalendarCarousel<Event>(
    onCalendarChanged: onCalendarChanged,
    onDayPressed: onDayPressed,

    /// make calendar to be scrollable together with its screen
    customGridViewPhysics: NeverScrollableScrollPhysics(),

    /// marked Date
    markedDatesMap: markedDateMap,
    markedDateShowIcon: true,
    markedDateIconMaxShown: 1,
    markedDateIconBuilder: (event) {
      return markedIcon(color: Theme.of(context).accentColor, context: context);
    },

    /// selected date
    selectedDayButtonColor: Theme.of(context).primaryColor,
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

    /// weekday
    weekdayTextStyle: TextStyle(color: Theme.of(context).primaryColorLight),
    weekendTextStyle: TextStyle(
      color: Theme.of(context).primaryColorLight,
    ),
    daysTextStyle: TextStyle(color: Theme.of(context).textTheme.title.color),
    todayBorderColor: Colors.green,
    todayTextStyle: TextStyle(
      color: Theme.of(context).primaryColor,
    ),
    todayButtonColor: Theme.of(context).hintColor,
  );
}

Widget markedIcon({Color color, BuildContext context}) {
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
  Paint _paint;

  DrawCircle({Color color}) {
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
