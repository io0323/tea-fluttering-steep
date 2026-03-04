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
  Future<List<BrewingSession>> execute({
    bool? isCompleted,
    int? limit,
  }) async {
    final brewingSessions = await _repository.fetchBrewingSessions();
    final filteredSessions = isCompleted == null
        ? brewingSessions
        : brewingSessions
            .where((session) => session.isCompleted == isCompleted)
            .toList();
    if (limit == null) {
      return filteredSessions;
    }
    if (limit <= 0) {
      return <BrewingSession>[];
    }
    if (filteredSessions.length <= limit) {
      return filteredSessions;
    }
    return filteredSessions.sublist(0, limit);
  }
}
