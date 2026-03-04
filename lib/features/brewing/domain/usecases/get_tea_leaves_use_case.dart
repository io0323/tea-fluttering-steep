import '../entities/tea_leaf.dart';
import '../repositories/i_brewing_repository.dart';

/**
 * Use case for loading available tea leaves.
 */
class GetTeaLeavesUseCase {
  /**
   * Creates a GetTeaLeavesUseCase instance.
   */
  const GetTeaLeavesUseCase(this._repository);

  final IBrewingRepository _repository;

  /**
   * Executes tea leaf loading flow.
   */
  Future<List<TeaLeaf>> execute({
    TeaType? teaType,
    String? query,
  }) async {
    final teaLeaves = await _repository.fetchTeaLeaves();
    final filteredByTypeTeaLeaves = teaType == null
        ? teaLeaves
        : teaLeaves.where((teaLeaf) => teaLeaf.type == teaType).toList();
    final normalizedQuery = query?.trim().toLowerCase();
    final filteredTeaLeaves = normalizedQuery == null || normalizedQuery.isEmpty
        ? filteredByTypeTeaLeaves
        : filteredByTypeTeaLeaves
            .where((teaLeaf) => _matchesQuery(teaLeaf, normalizedQuery))
            .toList();
    filteredTeaLeaves.sort(_compareTeaLeaf);
    return filteredTeaLeaves;
  }

  /**
   * Returns true when tea leaf matches search query.
   */
  bool _matchesQuery(TeaLeaf teaLeaf, String normalizedQuery) {
    return teaLeaf.name.toLowerCase().contains(normalizedQuery) ||
        teaLeaf.description.toLowerCase().contains(normalizedQuery);
  }

  /**
   * Compares tea leaves with stable UI-friendly ordering.
   */
  int _compareTeaLeaf(TeaLeaf left, TeaLeaf right) {
    final typeOrderCompare = _teaTypeOrder(left.type).compareTo(
      _teaTypeOrder(right.type),
    );
    if (typeOrderCompare != 0) {
      return typeOrderCompare;
    }
    return left.name.compareTo(right.name);
  }

  /**
   * Returns display order index for each tea type.
   */
  int _teaTypeOrder(TeaType teaType) {
    switch (teaType) {
      case TeaType.green:
        return 0;
      case TeaType.black:
        return 1;
      case TeaType.oolong:
        return 2;
      case TeaType.herb:
        return 3;
    }
  }
}
