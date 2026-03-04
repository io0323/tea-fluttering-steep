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
  Future<List<TeaLeaf>> execute() {
    return _repository.fetchTeaLeaves();
  }
}
