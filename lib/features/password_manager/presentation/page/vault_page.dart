import 'package:animate_do/animate_do.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/const/constants.dart';
import '../../domain/entities/vault_entry.dart';
import '../bloc/vault_bloc.dart';
import '../widgets/category_chip.dart';
import '../widgets/empty_vault_widget.dart';
import '../widgets/vault_entry_card.dart';
import '../widgets/vault_search_bar.dart';
import 'add_entry_page.dart';

class VaultPage extends StatefulWidget {
  const VaultPage({super.key});

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
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider<VaultBloc>.value(
          value: context.read<VaultBloc>(),
          child: AddEntryPage(existingEntry: entry),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
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
                  onChanged: (String query) {
                    context
                        .read<VaultBloc>()
                        .add(SearchEntries(query: query));
                  },
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
                        context
                            .read<VaultBloc>()
                            .add(const FilterByCategory());
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
                            context.read<VaultBloc>().add(
                                  FilterByCategory(category: cat),
                                );
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
              child: BlocBuilder<VaultBloc, VaultState>(
                builder: (BuildContext context, VaultState state) {
                  if (state is VaultLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: vaultAccent,
                        strokeWidth: 2.5,
                      ),
                    );
                  }
                  if (state is VaultLoaded) {
                    if (state.entries.isEmpty) {
                      return EmptyVaultWidget(
                        onAdd: () => _navigateToAddEntry(),
                      );
                    }
                    return FadeIn(
                      duration: const Duration(milliseconds: 400),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: state.entries.length,
                        itemBuilder: (BuildContext context, int index) {
                          final VaultEntry entry = state.entries[index];
                          return FadeInUp(
                            duration: const Duration(milliseconds: 400),
                            delay: Duration(milliseconds: index * 60),
                            child: VaultEntryCard(
                              entry: entry,
                              onEdit: () =>
                                  _navigateToAddEntry(entry: entry),
                              onDelete: () {
                                context.read<VaultBloc>().add(
                                      DeleteEntry(entryId: entry.id),
                                    );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }
                  if (state is VaultError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: vaultDanger),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      // ── FAB ────────────────────────────────────────────
      floatingActionButton: FadeInUp(
        duration: const Duration(milliseconds: 600),
        delay: const Duration(milliseconds: 300),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: <Color>[vaultGradientStart, vaultGradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: vaultAccent.withAlpha(60),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () => _navigateToAddEntry(),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(Icons.add_rounded, size: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: <Widget>[
          // Back button
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: vaultCardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: vaultCardBorder.withAlpha(60),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
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
                style: context.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              BlocBuilder<VaultBloc, VaultState>(
                builder: (BuildContext context, VaultState state) {
                  final int count =
                      state is VaultLoaded ? state.entries.length : 0;
                  return Text(
                    '$count passwords stored',
                    style: TextStyle(
                      color: Colors.white.withAlpha(80),
                      fontSize: 13,
                    ),
                  );
                },
              ),
            ],
          ),
          const Spacer(),
          // Gradient accent dot
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: <Color>[vaultGradientStart, vaultGradientEnd],
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: vaultAccent.withAlpha(40),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
