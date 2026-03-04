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
    return _repository.saveBrewingSession(
      BrewingSession(
        tea: tea,
        startTime: startTime,
        isCompleted: isCompleted,
      ),
    );
  }
}
