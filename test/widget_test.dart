import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealth_os/src/app/app.dart';

void main() {
  testWidgets('WealthOsApp starts and renders its home surface',
      (WidgetTester tester) async {
    await tester.pumpWidget(const WealthOsApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(AppPlaceholderScreen), findsOneWidget);
    expect(find.text('Wealth OS'), findsOneWidget);
  });
}
