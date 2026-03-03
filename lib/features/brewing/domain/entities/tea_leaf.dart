import 'package:freezed_annotation/freezed_annotation.dart';

part 'tea_leaf.freezed.dart';

/**
 * Enum that represents tea categories.
 */
enum TeaType {
  green,
  black,
  oolong,
  herb,
}

/**
 * Entity that stores tea profile and brewing defaults.
 */
@freezed
class TeaLeaf with _$TeaLeaf {
  /**
   * Creates a TeaLeaf instance.
   */
  const factory TeaLeaf({
    required String id,
    required String name,
    required TeaType type,
    required double defaultTemperature,
    required Duration defaultSteepTime,
    required String description,
  }) = _TeaLeaf;
}
