import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/main.dart';

void main() {
  testWidgets('app starts with Trip Planner title', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: TripPlannerApp()));
    expect(find.text('Trip Planner'), findsOneWidget);
  });
}
