import 'package:isar/isar.dart';

import '../../domain/entities/brewing_session.dart';
import '../../domain/entities/tea_leaf.dart';

part 'brewing_session_model.g.dart';

/**
 * Persistent model for BrewingSession.
 */
@collection
class BrewingSessionModel {
  /**
   * Isar primary key.
   */
  Id isarId = Isar.autoIncrement;

  /**
   * Linked tea id.
   */
  @Index()
  late String teaId;

  /**
   * Session start time.
   */
  late DateTime startTime;

  /**
   * Session completion flag.
   */
  late bool isCompleted;

  /**
   * Creates storage model from domain entity.
   */
  static BrewingSessionModel fromEntity(BrewingSession entity) {
    final model = BrewingSessionModel()
      ..teaId = entity.tea.id
      ..startTime = entity.startTime
      ..isCompleted = entity.isCompleted;
    return model;
  }

  /**
   * Rebuilds domain entity using resolved tea entity.
   */
  BrewingSession toEntity(TeaLeaf teaLeaf) {
    return BrewingSession(
      tea: teaLeaf,
      startTime: startTime,
      isCompleted: isCompleted,
    );
  }
}
