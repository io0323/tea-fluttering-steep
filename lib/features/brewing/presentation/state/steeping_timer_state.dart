/**
 * Immutable state for the steeping timer screen.
 */
class SteepingTimerState {
  /**
   * Creates a SteepingTimerState instance.
   */
  const SteepingTimerState({
    required this.totalDuration,
    required this.remaining,
    required this.isRunning,
    required this.isCompleted,
  });

  final Duration totalDuration;
  final Duration remaining;
  final bool isRunning;
  final bool isCompleted;

  /**
   * Returns progress ratio in range 0.0 to 1.0.
   */
  double get progress {
    if (totalDuration.inMilliseconds == 0) {
      return 0;
    }
    final completedMs =
        totalDuration.inMilliseconds - remaining.inMilliseconds;
    return (completedMs / totalDuration.inMilliseconds).clamp(0.0, 1.0);
  }

  /**
   * Returns a copied state with updated fields.
   */
  SteepingTimerState copyWith({
    Duration? totalDuration,
    Duration? remaining,
    bool? isRunning,
    bool? isCompleted,
  }) {
    return SteepingTimerState(
      totalDuration: totalDuration ?? this.totalDuration,
      remaining: remaining ?? this.remaining,
      isRunning: isRunning ?? this.isRunning,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
