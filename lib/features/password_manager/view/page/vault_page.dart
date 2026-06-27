import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rxget/rxget.dart';

import '../../../../core/routes/app_router.gr.dart';
import '../../../../service/password_manager/data/repositories/vault_repo_impl.dart';
import '../../../../service/password_manager/domain/entities/vault_entry.dart';
import '../../controller/vault_controller.dart';
import '../widgets/category_chip.dart';
import '../widgets/empty_vault_widget.dart';
import '../widgets/vault_entry_card.dart';
import '../widgets/vault_search_bar.dart';

@RoutePage()
class VaultPage extends StatefulWidget implements AutoRouteWrapper {
  const VaultPage({required this.repository, super.key});

  final VaultRepoImpl repository;

  @override
  Widget wrappedRoute(BuildContext context) {
    return GetInWidget(
      dependencies: <GetIn<dynamic>>[
        GetIn<VaultController>(
          () => VaultController(repository: repository)..loadVault(),
        ),
      ],
      child: this,
    );
  }

  @override
  State<VaultPage> createState() => _VaultPageState();
}

class _VaultPageState extends State<VaultPage> {
  final TextEditingController _searchController = TextEditingController();
  VaultCategory? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToAddEntry({VaultEntry? entry}) {
    context.router.push(AddEntryRoute(existingEntry: entry));
  }

  @override
  Widget build(BuildContext context) {
    final VaultController controller = Get.find<VaultController>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // ── Header ──────────────────────────────────────
            FadeInDown(
              duration: const Duration(milliseconds: 400),
              child: _buildHeader(context),
            ),
            const SizedBox(height: 16),
            // ── Search Bar ──────────────────────────────────
            FadeInDown(
              duration: const Duration(milliseconds: 500),
              delay: const Duration(milliseconds: 100),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: VaultSearchBar(
                  controller: _searchController,
                  onChanged: controller.searchEntries,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // ── Category Chips ──────────────────────────────
            FadeInDown(
              duration: const Duration(milliseconds: 500),
              delay: const Duration(milliseconds: 200),
              child: SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: <Widget>[
                    CategoryChip(
                      category: null,
                      isSelected: _selectedCategory == null,
                      onTap: () {
                        setState(() => _selectedCategory = null);
                        controller.filterByCategory(null);
                      },
                    ),
                    const SizedBox(width: 8),
                    ...VaultCategory.values.map(
                      (VaultCategory cat) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CategoryChip(
                          category: cat,
                          isSelected: _selectedCategory == cat,
                          onTap: () {
                            setState(() => _selectedCategory = cat);
                            controller.filterByCategory(cat);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // ── Vault List ──────────────────────────────────
            Expanded(
              child: Obx(() {
                final ThemeData theme = Theme.of(context);
                if (controller.state.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                      strokeWidth: 2.5,
                    ),
                  );
                }
                if (controller.state.error != null) {
                  return Center(
                    child: Text(
                      controller.state.error!,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  );
                }
                if (controller.state.entries.isEmpty) {
                  return EmptyVaultWidget(
                    onAdd: _navigateToAddEntry,
                  );
                }
                return FadeIn(
                  duration: const Duration(milliseconds: 400),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: controller.state.entries.length,
                    itemBuilder: (BuildContext context, int index) {
                      final VaultEntry entry = controller.state.entries[index];
                      return FadeInUp(
                        duration: const Duration(milliseconds: 400),
                        delay: Duration(milliseconds: index * 60),
                        child: VaultEntryCard(
                          entry: entry,
                          onEdit: () => _navigateToAddEntry(entry: entry),
                          onDelete: () {
                            controller.deleteEntry(entry.id);
                          },
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      // ── FAB ────────────────────────────────────────────
      floatingActionButton: FadeInUp(
        duration: const Duration(milliseconds: 600),
        delay: const Duration(milliseconds: 300),
        child: FloatingActionButton(
          onPressed: _navigateToAddEntry,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.add_rounded, size: 28),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final VaultController controller = Get.find<VaultController>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: <Widget>[
          // Back button
          InkWell(
            onTap: () => context.router.maybePop(),
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: theme.dividerColor,
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: theme.colorScheme.onSurface,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Password Vault',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Obx(() {
                final int count = controller.state.entries.length;
                return Text(
                  '$count passwords stored',
                  style: theme.textTheme.bodySmall,
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
