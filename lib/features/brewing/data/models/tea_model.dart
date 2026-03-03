import 'package:isar/isar.dart';

import '../../domain/entities/tea_leaf.dart';

part 'tea_model.g.dart';

/**
 * Persistent model for TeaLeaf.
 */
@collection
class TeaModel {
  /**
   * Isar primary key.
   */
  Id isarId = Isar.autoIncrement;

  /**
   * Domain-level id.
   */
  @Index(unique: true, replace: true)
  late String id;

  /**
   * Tea display name.
   */
  late String name;

  /**
   * Tea type enum for storage.
   */
  @enumerated
  late TeaTypeDb type;

  /**
   * Recommended water temperature.
   */
  late double defaultTemperature;

  /**
   * Recommended steep time in milliseconds.
   */
  late int defaultSteepTimeMs;

  /**
   * Tea note or description.
   */
  late String description;

  /**
   * Converts storage model into domain entity.
   */
  TeaLeaf toEntity() {
    return TeaLeaf(
      id: id,
      name: name,
      type: type.toEntity(),
      defaultTemperature: defaultTemperature,
      defaultSteepTime: Duration(milliseconds: defaultSteepTimeMs),
      description: description,
    );
  }

  /**
   * Converts domain entity into storage model.
   */
  static TeaModel fromEntity(TeaLeaf entity) {
    final model = TeaModel()
      ..id = entity.id
      ..name = entity.name
      ..type = TeaTypeDbMapper.fromEntity(entity.type)
      ..defaultTemperature = entity.defaultTemperature
      ..defaultSteepTimeMs = entity.defaultSteepTime.inMilliseconds
      ..description = entity.description;
    return model;
  }
}

/**
 * Tea type enum used in Isar.
 */
enum TeaTypeDb {
  green,
  black,
  oolong,
  herb,
}

/**
 * Mapper between storage enum and domain enum.
 */
extension TeaTypeDbMapper on TeaTypeDb {
  /**
   * Converts storage type into domain type.
   */
  TeaType toEntity() {
    switch (this) {
      case TeaTypeDb.green:
        return TeaType.green;
      case TeaTypeDb.black:
        return TeaType.black;
      case TeaTypeDb.oolong:
        return TeaType.oolong;
      case TeaTypeDb.herb:
        return TeaType.herb;
    }
  }

  /**
   * Converts domain type into storage type.
   */
  static TeaTypeDb fromEntity(TeaType teaType) {
    switch (teaType) {
      case TeaType.green:
        return TeaTypeDb.green;
      case TeaType.black:
        return TeaTypeDb.black;
      case TeaType.oolong:
        return TeaTypeDb.oolong;
      case TeaType.herb:
        return TeaTypeDb.herb;
    }
  }
}
