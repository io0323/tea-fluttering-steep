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
    return state.isRunning ? 'Pause' : 'Start';
  }

  /**
   * Returns true when primary action is clickable.
   */
  bool isPrimaryActionEnabled(SteepingTimerState state) {
    return !state.isCompleted;
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
