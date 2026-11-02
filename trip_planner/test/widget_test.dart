import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/presentation/app/trip_planner_app.dart';
import 'package:trip_planner/presentation/providers/trip_providers.dart';

import 'fakes/fake_trip_repository.dart';

void main() {
  testWidgets('Trip planner app loads successfully', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tripRepositoryProvider.overrideWithValue(
            FakeTripRepository(),
          ),
        ],
        child: const TripPlannerApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(TripPlannerApp), findsOneWidget);
  });
}