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
   * Formats remaining time as mm:ss.
   */
  String formatCountdown(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /**
   * Builds tea meta text for subtitle area.
   */
  String buildTeaMetaText(TeaLeaf teaLeaf) {
    final minutes = teaLeaf.defaultSteepTime.inMinutes;
    return '${teaLeaf.type.label}  •  ${teaLeaf.defaultTemperature.toInt()} C'
        '  •  ${minutes} min';
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
