import 'package:bookoo2/models/Category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bookoo2/shared/category_list.dart' show CategoryList;
import '../test_utils.dart' show TestUtils;

void main() {
  testWidgets("Button", (WidgetTester tester) async{
    List<Category> categories = [];
    await tester.pumpWidget(TestUtils.makeTestableWidget(child: CategoryList(
      categories: categories,
    )));
    await tester.pumpAndSettle();

    // var findByText = find.byType(Text);
    // expect(findByText.evaluate().isEmpty, false);

    // expect(find.text('TextTest'), findsOneWidget);
  });
}
