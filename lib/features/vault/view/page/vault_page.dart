import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:rxget/rxget.dart';

import '../../../../core/extension/color_ext.dart';
import '../../../../core/routes/app_router.gr.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/squircle.dart';
import '../../../../service/password_manager/data/repositories/vault_repo_impl.dart';
import '../../../../service/password_manager/domain/entities/decrypted_vault_entry.dart';
import '../../../../service/password_manager/domain/entities/vault_entry.dart';
import '../../controller/vault/vault_controller.dart';
import '../widgets/empty_vault_widget.dart';
import '../widgets/glass_icon_button.dart';
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
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFF3ECF8E), // Vibrant Supabase Green at the top
              Color(0xFF1B6A42), // Transition to dark green
              AppColors.background, // Fades perfectly into black
            ],
            stops: <double>[0, 0.20, 0.35],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: <Widget>[
              // ── Top Bar ──────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GlassIconButton(icon: Icons.menu_rounded, onTap: () {}),
                      GlassIconButton(
                        icon: Icons.more_vert_rounded,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),

              // ── Search Bar ──────────────────────────────────
              SliverToBoxAdapter(
                child: FadeInDown(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 100),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: VaultSearchBar(
                      controller: _searchController,
                      onChanged: controller.searchEntries,
                    ),
                  ),
                ),
              ),

              // ── List Header ──────────────────────────────────
              const SliverToBoxAdapter(
                child: FadeInDown(
                  duration: Duration(milliseconds: 600),
                  delay: Duration(milliseconds: 300),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Vault List ──────────────────────────────────
              Obx(() {
                if (controller.state.isLoading) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  );
                }
                if (controller.state.error != null) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Center(
                        child: Text(
                          controller.state.error!,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ),
                    ),
                  );
                }
                if (controller.state.entries.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: EmptyVaultWidget(onAdd: _navigateToAddEntry),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((
                      BuildContext context,
                      int index,
                    ) {
                      final DecryptedVaultEntry entry =
                          controller.state.entries[index];
                      return FadeInUp(
                        duration: const Duration(milliseconds: 400),
                        delay: Duration(milliseconds: index * 60),
                        child: VaultEntryCard(
                          entry: entry,
                          onTap: () {
                            context.router.push(
                              ViewPasswordRoute(entry: entry.entry),
                            );
                          },
                        ),
                      );
                    }, childCount: controller.state.entries.length),
                  ),
                );
              }),

              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ), // Bottom padding
            ],
          ),
        ),
      ),
      // Floating Bottom Add Button (matches the image aesthetic)
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FadeInUp(
        duration: const Duration(milliseconds: 600),
        delay: const Duration(milliseconds: 400),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: ShapeDecoration(
            color: Colors.white.op(0.12),
            shape: const Squircle().shape(),
          ),
          child: Text("🔑 NEW", style: context.titleLarge),
        ),
      ),
    );
  }
}
