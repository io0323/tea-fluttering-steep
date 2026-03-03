import '../entities/brewing_session.dart';
import '../entities/tea_leaf.dart';

/**
 * Repository contract for brewing-related persistence.
 */
abstract interface class IBrewingRepository {
  /**
   * Returns all available tea leaves.
   */
  Future<List<TeaLeaf>> fetchTeaLeaves();

  /**
   * Returns a tea leaf by its domain id.
   */
  Future<TeaLeaf?> getTeaLeafById(String id);

  /**
   * Persists one brewing session.
   */
  Future<void> saveBrewingSession(BrewingSession session);

  /**
   * Returns persisted brewing sessions.
   */
  Future<List<BrewingSession>> fetchBrewingSessions();
}
