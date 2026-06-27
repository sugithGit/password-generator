import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/const/constants.dart';
import '../../domain/entities/vault_entry.dart';

class VaultEntryCard extends StatefulWidget {
  const VaultEntryCard({
    required this.entry,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final VaultEntry entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<VaultEntryCard> createState() => _VaultEntryCardState();
}

class _VaultEntryCardState extends State<VaultEntryCard>
    with SingleTickerProviderStateMixin {
  bool _showPassword = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getCategoryColor() {
    switch (widget.entry.category) {
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
    switch (widget.entry.category) {
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
    final theme = Theme.of(context);
    final Color categoryColor = _getCategoryColor();
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: widget.onEdit,
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
                      border: Border.all(
                        color: categoryColor.withAlpha(50),
                      ),
                    ),
                    child: Icon(
                      _getCategoryIcon(),
                      color: categoryColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Title & username
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.entry.title,
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
                          widget.entry.username,
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (_showPassword) ...<Widget>[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onSurface.withAlpha(10),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.entry.encryptedPassword,
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontSize: 13,
                                fontFamily: 'monospace',
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Actions
                  Column(
                    children: <Widget>[
                      // Toggle password visibility
                      _ActionIcon(
                        icon: _showPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        onTap: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                      const SizedBox(height: 4),
                      // Copy password
                      _ActionIcon(
                        icon: Icons.copy_rounded,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          final String decrypted = widget.entry.encryptedPassword;
                          Clipboard.setData(ClipboardData(text: decrypted));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Password copied!'),
                              backgroundColor: theme.colorScheme.primary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
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

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          icon,
          color: theme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
      ),
    );
  }
}
