import 'package:flutter/material.dart';

import '../../../../core/const/constants.dart';
import '../../../../service/password_manager/domain/entities/decrypted_vault_entry.dart';
import '../../../../service/password_manager/domain/entities/vault_category.dart';

class VaultEntryCard extends StatefulWidget {
  const VaultEntryCard({required this.entry, required this.onTap, super.key});

  final DecryptedVaultEntry entry;
  final VoidCallback onTap;

  @override
  State<VaultEntryCard> createState() => _VaultEntryCardState();
}

class _VaultEntryCardState extends State<VaultEntryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getCategoryColor() {
    switch (widget.entry.entry.category) {
      case VaultCategory.social:
        return categorySocial;
      case VaultCategory.email:
        return categoryEmail;
      case VaultCategory.banking:
        return categoryBanking;
      case VaultCategory.shopping:
        return categoryShopping;
      case VaultCategory.work:
        return categoryWork;
      case VaultCategory.other:
        return categoryOther;
    }
  }

  IconData _getCategoryIcon() {
    switch (widget.entry.entry.category) {
      case VaultCategory.social:
        return Icons.people_outline_rounded;
      case VaultCategory.email:
        return Icons.email_outlined;
      case VaultCategory.banking:
        return Icons.account_balance_outlined;
      case VaultCategory.shopping:
        return Icons.shopping_bag_outlined;
      case VaultCategory.work:
        return Icons.work_outline_rounded;
      case VaultCategory.other:
        return Icons.key_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color categoryColor = _getCategoryColor();
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  // Category icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: categoryColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: categoryColor.withAlpha(50)),
                    ),
                    child: Icon(
                      _getCategoryIcon(),
                      color: categoryColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.entry.decryptedTitle,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap to view details',
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurfaceVariant.withAlpha(100),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
