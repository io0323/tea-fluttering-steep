import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'brewing/data/repositories/brewing_repository_impl.dart';
import 'brewing/domain/repositories/i_brewing_repository.dart';
import 'brewing/domain/usecases/get_tea_leaves_use_case.dart';

// Repository providers
final brewingRepositoryProvider = Provider<IBrewingRepository>((ref) {
  throw UnimplementedError('brewingRepositoryProvider not overridden');
});

// Use case providers
final getTeaLeavesUseCaseProvider = Provider<GetTeaLeavesUseCase>((ref) {
  final repository = ref.watch(brewingRepositoryProvider);
  return GetTeaLeavesUseCase(repository);
});
