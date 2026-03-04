import '../entities/brewing_session.dart';
import '../entities/tea_leaf.dart';
import '../repositories/i_brewing_repository.dart';

/**
 * Use case for persisting a brewing session.
 */
class SaveBrewingSessionUseCase {
  /**
   * Creates a SaveBrewingSessionUseCase instance.
   */
  const SaveBrewingSessionUseCase(this._repository);

  final IBrewingRepository _repository;

  /**
   * Saves one brewing session for the given tea.
   */
  Future<void> execute({
    required TeaLeaf tea,
    required DateTime startTime,
    required bool isCompleted,
  }) {
    _validateTea(tea);
    _validateStartTime(startTime);
    return _repository.saveBrewingSession(
      BrewingSession(
        tea: tea,
        startTime: startTime,
        isCompleted: isCompleted,
      ),
    );
  }

  /**
   * Validates tea entity before persistence.
   */
  void _validateTea(TeaLeaf tea) {
    if (tea.id.trim().isEmpty) {
      throw ArgumentError.value(tea.id, 'tea.id', 'Tea id must not be empty.');
    }
    if (tea.name.trim().isEmpty) {
      throw ArgumentError.value(
        tea.name,
        'tea.name',
        'Tea name must not be empty.',
      );
    }
    if (tea.defaultTemperature <= 0) {
      throw ArgumentError.value(
        tea.defaultTemperature,
        'tea.defaultTemperature',
        'Default temperature must be greater than 0.',
      );
    }
    if (tea.defaultSteepTime <= Duration.zero) {
      throw ArgumentError.value(
        tea.defaultSteepTime,
        'tea.defaultSteepTime',
        'Default steep time must be greater than zero.',
      );
    }
  }

  /**
   * Validates session start time before persistence.
   */
  void _validateStartTime(DateTime startTime) {
    if (startTime.isAfter(DateTime.now())) {
      throw ArgumentError.value(
        startTime,
        'startTime',
        'Start time must not be in the future.',
      );
    }
  }
}
