#!/usr/bin/env bash
set -euo pipefail

# Run from trip_planner/. This generates the standard Flutter platform folders
# while preserving the Dart source already included in this submission.
flutter create --platforms=ios,android,macos,web .
flutter pub get
