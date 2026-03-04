import '../entities/brewing_session.dart';
import '../entities/tea_leaf.dart';
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
    TeaType? teaType,
    String? query,
    int? limit,
  }) async {
    final brewingSessions = await _repository.fetchBrewingSessions();
    final filteredByCompletionSessions = isCompleted == null
        ? brewingSessions
        : brewingSessions
            .where((session) => session.isCompleted == isCompleted)
            .toList();
    final filteredByTeaTypeSessions = teaType == null
        ? filteredByCompletionSessions
        : filteredByCompletionSessions
            .where((session) => session.tea.type == teaType)
            .toList();
    final normalizedQuery = query?.trim().toLowerCase();
    final filteredSessions = normalizedQuery == null || normalizedQuery.isEmpty
        ? filteredByTeaTypeSessions
        : filteredByTeaTypeSessions
            .where((session) => _matchesQuery(session, normalizedQuery))
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

  /**
   * Returns true when session tea information matches search query.
   */
  bool _matchesQuery(BrewingSession session, String normalizedQuery) {
    return session.tea.name.toLowerCase().contains(normalizedQuery) ||
        session.tea.description.toLowerCase().contains(normalizedQuery);
  }
}
