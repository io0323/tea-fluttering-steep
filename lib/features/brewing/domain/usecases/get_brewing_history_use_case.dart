import '../entities/brewing_session.dart';
import '../repositories/i_brewing_repository.dart';

/**
 * Use case for loading brewing history.
 */
class GetBrewingHistoryUseCase {
  /**
   * Creates a GetBrewingHistoryUseCase instance.
   */
  const GetBrewingHistoryUseCase(this._repository);

  final IBrewingRepository _repository;

  /**
   * Executes brewing history loading flow.
   */
  Future<List<BrewingSession>> execute() {
    return _repository.fetchBrewingSessions();
  }
}
