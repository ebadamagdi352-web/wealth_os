import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealth_os/src/app/app.dart';
import 'package:wealth_os/src/features/dashboard/dashboard_page.dart';
import 'package:wealth_os/src/features/dashboard/widgets/net_worth_card.dart';

void main() {
  group('WealthOsApp', () {
    testWidgets('builds successfully', (WidgetTester tester) async {
      await tester.pumpWidget(const WealthOsApp());
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('opens on the dashboard', (WidgetTester tester) async {
      await tester.pumpWidget(const WealthOsApp());

      // `pumpAndSettle`, not a bare `pump`. The app starts at `/`, which
      // redirects to `/dashboard`; the redirect and the localization delegates
      // both need a frame to resolve. A single pump would assert against a tree
      // that has not finished arriving.
      await tester.pumpAndSettle();

      expect(find.byType(DashboardPage), findsOneWidget);
    });

    testWidgets('shows the net worth card', (WidgetTester tester) async {
      await tester.pumpWidget(const WealthOsApp());
      await tester.pumpAndSettle();

      expect(find.byType(NetWorthCard), findsOneWidget);

      // The label is read from `DashboardCopy` rather than retyped as a literal.
      // A test that hardcodes the string it is checking will keep passing after
      // someone changes the label — it stops testing the screen and starts
      // testing itself.
      expect(find.text(DashboardCopy.netWorthLabel), findsOneWidget);

      // The figure and its currency. `1,245,300` — with separators, and without
      // a trailing `.0` — proves the amount went through `NumberFormat` rather
      // than string interpolation. `'$amount'` would render `1245300.0`, which is
      // the failure this assertion exists to catch.
      expect(find.text('EGP'), findsOneWidget);
      expect(find.text('1,245,300'), findsOneWidget);
    });

    testWidgets('renders without exceptions', (WidgetTester tester) async {
      await tester.pumpWidget(const WealthOsApp());
      await tester.pumpAndSettle();

      // Flutter records build, layout and paint errors rather than throwing them
      // out of `pump`, so a screen can overflow, throw in a builder, or fail to
      // lay out while every `find` above still passes. `takeException` is what
      // actually surfaces that.
      expect(tester.takeException(), isNull);
    });
  });
}
