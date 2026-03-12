import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/tea_leaf.dart';
import '../../data/repositories/brewing_repository_impl.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  TeaType? _selectedType;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brewingRepository = ref.watch(brewingRepositoryProvider);
    final teaLeavesAsync = ref.watch(_teaLeavesProvider(
      teaType: _selectedType,
      query: _searchController.text,
    ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tea Selection'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search teas...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: TeaType.values.map((type) {
                      final isSelected = _selectedType == type;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(type.label),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedType = selected ? type : null;
                            });
                          },
                        ),
                      );
                    }).toList()
                      ..insert(0, Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: const Text('All'),
                          selected: _selectedType == null,
                          onSelected: (selected) {
                            setState(() {
                              _selectedType = null;
                            });
                          },
                        ),
                      )),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: teaLeavesAsync.when(
              data: (teaLeaves) => teaLeaves.isEmpty
                  ? const Center(child: Text('No teas found'))
                  : ListView.builder(
                      itemCount: teaLeaves.length,
                      itemBuilder: (context, index) {
                        final tea = teaLeaves[index];
                        return TeaListItem(
                          tea: tea,
                          onTap: () => _navigateToTimer(context, tea),
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToTimer(BuildContext context, TeaLeaf tea) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SteepingTimerPage(teaLeaf: tea),
      ),
    );
  }
}

class TeaListItem extends StatelessWidget {
  const TeaListItem({
    required this.tea,
    required this.onTap,
    super.key,
  });

  final TeaLeaf tea;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ListTile(
        title: Text(
          tea.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${tea.type.label} • ${tea.defaultTemperature.toInt()}°C • ${tea.defaultSteepTime.inMinutes}m ${tea.defaultSteepTime.inSeconds % 60}s',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              tea.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

final _teaLeavesProvider = FutureProvider.autoDispose
    .family<List<TeaLeaf>, ({TeaType? teaType, String query})>(
  (ref, params) async {
    final getTeaLeavesUseCase = ref.watch(getTeaLeavesUseCaseProvider);
    return getTeaLeavesUseCase.execute(
      teaType: params.teaType,
      query: params.query,
    );
  },
);
