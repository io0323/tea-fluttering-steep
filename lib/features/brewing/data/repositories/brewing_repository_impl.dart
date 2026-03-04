import 'package:isar/isar.dart';

import '../../domain/entities/brewing_session.dart';
import '../../domain/entities/tea_leaf.dart';
import '../../domain/repositories/i_brewing_repository.dart';
import '../models/brewing_session_model.dart';
import '../models/tea_model.dart';

/**
 * Isar-backed implementation of IBrewingRepository.
 */
class BrewingRepositoryImpl implements IBrewingRepository {
  /**
   * Creates a BrewingRepositoryImpl instance.
   */
  BrewingRepositoryImpl(this._isar);

  final Isar _isar;

  /**
   * Returns tea list and seeds presets when empty.
   */
  @override
  Future<List<TeaLeaf>> fetchTeaLeaves() async {
    var models = await _isar.teaModels.where().findAll();
    if (models.isEmpty) {
      await _seedInitialTeaLeaves();
      models = await _isar.teaModels.where().findAll();
    }
    return models.map((model) => model.toEntity()).toList();
  }

  /**
   * Returns one tea by its id.
   */
  @override
  Future<TeaLeaf?> getTeaLeafById(String id) async {
    final model = await _isar.teaModels.filter().idEqualTo(id).findFirst();
    return model?.toEntity();
  }

  /**
   * Persists one brewing session.
   */
  @override
  Future<void> saveBrewingSession(BrewingSession session) async {
    await _isar.writeTxn(() async {
      await _isar.teaModels.put(TeaModel.fromEntity(session.tea));
      await _isar.brewingSessionModels.put(
        BrewingSessionModel.fromEntity(session),
      );
    });
  }

  /**
   * Returns saved brewing session history.
   */
  @override
  Future<List<BrewingSession>> fetchBrewingSessions() async {
    final sessions = await _isar.brewingSessionModels.where().findAll();
    final teaModels = await _isar.teaModels.where().findAll();
    final teaMap = <String, TeaLeaf>{
      for (final tea in teaModels) tea.id: tea.toEntity(),
    };

    final result = <BrewingSession>[];
    for (final session in sessions) {
      final tea = teaMap[session.teaId];
      if (tea == null) {
        continue;
      }
      result.add(session.toEntity(tea));
    }
    result.sort(
      (left, right) => right.startTime.compareTo(left.startTime),
    );
    return result;
  }

  /**
   * Seeds common tea presets.
   */
  Future<void> _seedInitialTeaLeaves() async {
    final presets = <TeaLeaf>[
      TeaLeaf(
        id: 'gyokuro',
        name: '玉露',
        type: TeaType.green,
        defaultTemperature: 60,
        defaultSteepTime: const Duration(minutes: 2),
        description: '低温で旨味を引き出す上質な日本茶です。',
      ),
      TeaLeaf(
        id: 'darjeeling',
        name: 'ダージリン',
        type: TeaType.black,
        defaultTemperature: 95,
        defaultSteepTime: const Duration(minutes: 3),
        description: 'マスカテルフレーバーが特徴の紅茶です。',
      ),
      TeaLeaf(
        id: 'tieguanyin',
        name: '鉄観音',
        type: TeaType.oolong,
        defaultTemperature: 90,
        defaultSteepTime: const Duration(minutes: 2),
        description: '華やかな香りと焙煎感を楽しめる烏龍茶です。',
      ),
      TeaLeaf(
        id: 'chamomile',
        name: 'カモミール',
        type: TeaType.herb,
        defaultTemperature: 95,
        defaultSteepTime: const Duration(minutes: 5),
        description: 'やさしい香りでリラックスしやすいハーブティーです。',
      ),
    ];

    await _isar.writeTxn(() async {
      await _isar.teaModels.putAll(
        presets.map(TeaModel.fromEntity).toList(),
      );
    });
  }
}
