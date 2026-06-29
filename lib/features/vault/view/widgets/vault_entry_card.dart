import 'package:flutter/material.dart';

import '../../../../core/const/constants.dart';
import '../../../../core/widgets/squircle.dart';
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
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: Colors.white.withOpacity(
                0.05,
              ), // Dark translucent glass card
              shape: const Squircle(
                radius: 28,
              ).shape(side: BorderSide(color: Colors.white.withOpacity(0.02))),
            ),
            child: Row(
              children: <Widget>[
                // Category icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: ShapeDecoration(
                    color: categoryColor.withAlpha(25),
                    shape: const Squircle(radius: 14).shape(
                      side: BorderSide(color: categoryColor.withAlpha(50)),
                    ),
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
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (widget.entry.entry.username != null &&
                                widget.entry.entry.username!.isNotEmpty)
                            ? widget.entry.entry.username!
                            : 'Tap to view details',
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant.withOpacity(
                            0.7,
                          ),
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons
                      .link_rounded, // Similar to the infinity/link icon in image
                  color: theme.colorScheme.onSurfaceVariant.withAlpha(150),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
