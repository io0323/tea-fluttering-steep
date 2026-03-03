import 'package:freezed_annotation/freezed_annotation.dart';

import 'tea_leaf.dart';

part 'brewing_session.freezed.dart';

/**
 * Entity that represents a single brewing session.
 */
@freezed
class BrewingSession with _$BrewingSession {
  /**
   * Creates a BrewingSession instance.
   */
  const factory BrewingSession({
    required TeaLeaf tea,
    required DateTime startTime,
    required bool isCompleted,
  }) = _BrewingSession;
}
