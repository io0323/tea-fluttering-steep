import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'steeping_timer_state.dart';

/**
 * StateNotifier that drives the steeping timer workflow.
 */
class SteepingTimerNotifier extends StateNotifier<SteepingTimerState> {
  /**
   * Creates a SteepingTimerNotifier instance.
   */
  SteepingTimerNotifier(Duration initialDuration)
      : super(
          SteepingTimerState(
            totalDuration: initialDuration,
            remaining: initialDuration,
            isRunning: false,
            isCompleted: false,
          ),
        );

  Timer? _timer;

  /**
   * Starts the countdown.
   */
  void start() {
    if (state.isRunning || state.isCompleted) {
      return;
    }
    state = state.copyWith(isRunning: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  /**
   * Pauses the countdown.
   */
  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  /**
   * Resets countdown to initial duration.
   */
  void reset() {
    _timer?.cancel();
    state = state.copyWith(
      remaining: state.totalDuration,
      isRunning: false,
      isCompleted: false,
    );
  }

  /**
   * Reconfigures timer with a new total duration.
   */
  void configure(Duration duration) {
    _timer?.cancel();
    state = SteepingTimerState(
      totalDuration: duration,
      remaining: duration,
      isRunning: false,
      isCompleted: false,
    );
  }

  /**
   * Disposes running timer resources.
   */
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /**
   * Applies a one-second countdown tick.
   */
  void _tick() {
    final remainingSeconds = state.remaining.inSeconds - 1;
    if (remainingSeconds <= 0) {
      _timer?.cancel();
      state = state.copyWith(
        remaining: Duration.zero,
        isRunning: false,
        isCompleted: true,
      );
      return;
    }
    state = state.copyWith(remaining: Duration(seconds: remainingSeconds));
  }
}

/**
 * Provider family keyed by initial steeping duration.
 */
final steepingTimerProvider = StateNotifierProvider.autoDispose
    .family<SteepingTimerNotifier, SteepingTimerState, Duration>(
  (ref, initialDuration) {
    return SteepingTimerNotifier(initialDuration);
  },
);
