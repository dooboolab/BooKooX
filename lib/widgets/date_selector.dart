import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  final Function onDatePressed;
  final String date;
  const DateSelector(
      {super.key, required this.onDatePressed, required this.date});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 3, top: 32, bottom: 20),
      child: Row(
        children: <Widget>[
          TextButton(
            onPressed: onDatePressed as void Function()?,
            child: Row(
              children: <Widget>[
                Text(
                  date,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  color: Colors.grey,
                  onPressed: onDatePressed as void Function()?,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
