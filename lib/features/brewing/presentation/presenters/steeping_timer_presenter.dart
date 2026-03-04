import '../../domain/entities/tea_leaf.dart';
import '../state/steeping_timer_state.dart';

/**
 * Presenter for steeping timer display text and actions.
 */
class SteepingTimerPresenter {
  /**
   * Creates a SteepingTimerPresenter instance.
   */
  const SteepingTimerPresenter();

  /**
   * Formats remaining time as mm:ss or hh:mm:ss.
   */
  String formatCountdown(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (hours > 0) {
      final hourText = hours.toString().padLeft(2, '0');
      return '$hourText:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  /**
   * Builds tea meta text for subtitle area.
   */
  String buildTeaMetaText(TeaLeaf teaLeaf) {
    return '${teaLeaf.type.label}  •  ${teaLeaf.defaultTemperature.toInt()} C'
        '  •  ${_formatSteepTime(teaLeaf.defaultSteepTime)}';
  }

  /**
   * Returns primary button label by timer state.
   */
  String primaryButtonLabel(SteepingTimerState state) {
    if (state.isCompleted) {
      return 'Done';
    }
    if (state.isRunning) {
      return 'Pause';
    }
    if (_hasStarted(state)) {
      return 'Resume';
    }
    return 'Start';
  }

  /**
   * Returns true when primary action is clickable.
   */
  bool isPrimaryActionEnabled(SteepingTimerState state) {
    return !state.isCompleted;
  }

  /**
   * Returns true when countdown has moved from initial state.
   */
  bool _hasStarted(SteepingTimerState state) {
    return state.remaining < state.totalDuration;
  }

  /**
   * Builds completion message with tea-specific tone.
   */
  String buildCompletionMessage(TeaLeaf teaLeaf) {
    switch (teaLeaf.type) {
      case TeaType.green:
        return 'Steeping complete. Preserve the gentle umami and pour now.';
      case TeaType.black:
        return 'Steeping complete. Rich aroma is at its peak.';
      case TeaType.oolong:
        return 'Steeping complete. Floral notes are ready to bloom.';
      case TeaType.herb:
        return 'Steeping complete. Relaxing infusion is ready to enjoy.';
    }
  }

  /**
   * Formats steeping duration for metadata text.
   */
  String _formatSteepTime(Duration duration) {
    final totalSeconds = duration.inSeconds;
    if (totalSeconds < 60) {
      return '${totalSeconds}s';
    }
    final minutes = duration.inMinutes;
    final seconds = totalSeconds.remainder(60);
    if (seconds == 0) {
      return '${minutes}m';
    }
    return '${minutes}m ${seconds}s';
  }
}

/**
 * Presentation mapper for tea type labels.
 */
extension TeaTypePresentationX on TeaType {
  /**
   * Returns a concise label used in UI.
   */
  String get label {
    switch (this) {
      case TeaType.green:
        return 'Green';
      case TeaType.black:
        return 'Black';
      case TeaType.oolong:
        return 'Oolong';
      case TeaType.herb:
        return 'Herb';
    }
  }
}
