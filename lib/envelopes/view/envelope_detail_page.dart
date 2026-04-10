import 'dart:async';

import 'package:envelope/envelopes/cubit/cubit.dart';
import 'package:envelope/envelopes/view/envelope_form_page.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:envelope/transactions/widgets/transaction_helpers.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Detail page for a single envelope with terracotta header.
class EnvelopeDetailPage extends StatelessWidget {
  const EnvelopeDetailPage({
    required this.categoryGroups,
    super.key,
  });

  final List<CategoryGroup> categoryGroups;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EnvelopeDetailCubit, EnvelopeDetailState>(
      builder: (context, state) {
        final envelopeColor =
            AppColors.fromHex(state.envelope.color) ?? AppColors.primary;
        return Scaffold(
          backgroundColor: envelopeColor,
          body: CustomScrollView(
            slivers: [
              _EnvelopeAppBar(
                state: state,
                envelopeColor: envelopeColor,
                heroTag: 'envelope_${state.envelope.id}',
                onEdit: () => _openEdit(context, state.envelope),
                onDelete: () => _confirmDelete(context),
              ),
              _EnvelopeContent(envelopeColor: envelopeColor),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openEdit(
    BuildContext context,
    Envelope envelope,
  ) async {
    final cubit = context.read<EnvelopeDetailCubit>();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BlocProvider(
          create: (_) => EnvelopeFormCubit(
            envelopeRepository: context.read<EnvelopeRepository>(),
            budgetId: envelope.budgetId,
            envelope: envelope,
          ),
          child: EnvelopeFormPage(
            categoryGroups: categoryGroups,
            envelope: envelope,
          ),
        ),
      ),
    );
    if (result == true && context.mounted) {
      await cubit.refresh();
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = context.l10n;
    final cubit = context.read<EnvelopeDetailCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          l10n.envelopesDeleteEnvelopeConfirmTitle,
        ),
        content: Text(
          l10n.envelopesDeleteEnvelopeConfirmMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.envelopesCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.envelopesDelete),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      final success = await cubit.deleteEnvelope();
      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.envelopesDetailDeleteSuccess,
              ),
            ),
          );
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.envelopesDetailDeleteError,
              ),
            ),
          );
        }
      }
    }
  }
}

// ── App bar with hero + slide-in animations ──────────────────

class _EnvelopeAppBar extends StatefulWidget {
  const _EnvelopeAppBar({
    required this.state,
    required this.envelopeColor,
    required this.heroTag,
    required this.onEdit,
    required this.onDelete,
  });

  final EnvelopeDetailState state;
  final Color envelopeColor;
  final String heroTag;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<_EnvelopeAppBar> createState() => _EnvelopeAppBarState();
}

class _EnvelopeAppBarState extends State<_EnvelopeAppBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _slideCurve;
  late final CurvedAnimation _opacityCurve;
  late final Animation<Offset> _slideLeft;
  late final Animation<Offset> _slideRight;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideCurve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _opacityCurve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slideLeft = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(_slideCurve);
    _slideRight = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(_slideCurve);

    // Start content animation after the route transition completes.
    _startAfterRouteTransition();
  }

  void _startAfterRouteTransition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final animation = ModalRoute.of(context)?.animation;
      if (animation == null || animation.status == AnimationStatus.completed) {
        unawaited(_controller.forward());
      } else {
        void listener(AnimationStatus status) {
          if (status == AnimationStatus.completed && mounted) {
            animation.removeStatusListener(listener);
            unawaited(_controller.forward());
          }
        }

        animation.addStatusListener(listener);
      }
    });
  }

  @override
  void dispose() {
    _opacityCurve.dispose();
    _slideCurve.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = widget.state;
    final envelope = state.envelope;

    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: widget.envelopeColor,
      iconTheme: const IconThemeData(color: AppColors.onPrimary),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          tooltip: l10n.envelopesEditEnvelope,
          onPressed: widget.onEdit,
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: l10n.envelopesDetailDeleteEnvelope,
          onPressed: widget.onDelete,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          envelope.name.toUpperCase(),
          style: const TextStyle(
            color: AppColors.onPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        background: Hero(
          tag: widget.heroTag,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              color: widget.envelopeColor,
              padding: const EdgeInsets.fromLTRB(
                24,
                80,
                24,
                48,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.envelopesDetailAvailable.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.onPrimary,
                      fontSize: 13,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatCents(state.available),
                    style: GoogleFonts.playfairDisplay(
                      color: AppColors.onPrimary,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SlideTransition(
                        position: _slideLeft,
                        child: FadeTransition(
                          opacity: _opacityCurve,
                          child: _HeaderDetail(
                            label: l10n.envelopesDetailAllocated,
                            amount: state.allocated,
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),
                      SlideTransition(
                        position: _slideRight,
                        child: FadeTransition(
                          opacity: _opacityCurve,
                          child: _HeaderDetail(
                            label: l10n.envelopesDetailSpent,
                            amount: state.spent,
                          ),
                        ),
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

// ── Content section with slide-up animation ──────────────────

class _EnvelopeContent extends StatefulWidget {
  const _EnvelopeContent({required this.envelopeColor});

  final Color envelopeColor;

  @override
  State<_EnvelopeContent> createState() => _EnvelopeContentState();
}

class _EnvelopeContentState extends State<_EnvelopeContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _opacityCurve;
  late final CurvedAnimation _slideCurve;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacityCurve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slideCurve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(_slideCurve);

    // Start content animation after the route transition completes.
    _startAfterRouteTransition();
  }

  void _startAfterRouteTransition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final animation = ModalRoute.of(context)?.animation;
      if (animation == null || animation.status == AnimationStatus.completed) {
        unawaited(_controller.forward());
      } else {
        void listener(AnimationStatus status) {
          if (status == AnimationStatus.completed && mounted) {
            animation.removeStatusListener(listener);
            unawaited(_controller.forward());
          }
        }

        animation.addStatusListener(listener);
      }
    });
  }

  @override
  void dispose() {
    _slideCurve.dispose();
    _opacityCurve.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final mutedStyle = theme.textTheme.bodyMedium?.copyWith(
      color: AppColors.onPrimary.withValues(alpha: 0.85),
    );
    final sectionTitle = theme.textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: 0.8,
      color: AppColors.onPrimary,
    );

    return SliverToBoxAdapter(
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _opacityCurve,
          child: Container(
            color: widget.envelopeColor,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Transactions.
                BlocBuilder<EnvelopeDetailCubit, EnvelopeDetailState>(
                  buildWhen: (prev, curr) =>
                      prev.transactions != curr.transactions,
                  builder: (context, state) {
                    final transactions = [...state.transactions]
                      ..sort((a, b) => b.date.compareTo(a.date));
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
                          child: Text(
                            l10n.envelopesDetailTransactions.toUpperCase(),
                            style: sectionTitle,
                          ),
                        ),
                        if (transactions.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.receipt_long_outlined,
                                    size: 48,
                                    color: AppColors.primaryDark,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    l10n.envelopesDetailTransactionsPlaceholder
                                        .toUpperCase(),
                                    style: mutedStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          for (int i = 0; i < transactions.length; i++) ...[
                            if (i == 0 ||
                                !_sameDay(
                                  transactions[i].date,
                                  transactions[i - 1].date,
                                ))
                              Padding(
                                padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
                                child: Text(
                                  formatDateHeader(
                                    transactions[i].date,
                                    l10n,
                                  ),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: AppColors.onPrimary.withValues(
                                      alpha: 0.6,
                                    ),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                            _TransactionRow(
                              transaction: transactions[i],
                              envelopeColor: widget.envelopeColor,
                            ),
                          ],
                      ],
                    );
                  },
                ),
                Divider(
                  color: AppColors.onPrimary.withValues(alpha: 0.2),
                ),
                // Goal progress.
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.flag_outlined,
                        size: 48,
                        color: AppColors.primaryDark,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.envelopesDetailGoalProgressPlaceholder
                            .toUpperCase(),
                        style: mutedStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Small helper widgets ─────────────────────────────────────

class _HeaderDetail extends StatelessWidget {
  const _HeaderDetail({
    required this.label,
    required this.amount,
  });

  final String label;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: AppColors.onPrimary.withValues(alpha: 0.8),
            fontSize: 11,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          formatCents(amount),
          style: const TextStyle(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({
    required this.transaction,
    required this.envelopeColor,
  });

  final Transaction transaction;
  final Color envelopeColor;

  @override
  Widget build(BuildContext context) {
    final typeColor = AppColors.onPrimary.withValues(alpha: 0.9);
    final iconColor = AppColors.onPrimary.withValues(alpha: 0.7);
    final prefix = transaction.type == 'income' ? '+' : '';
    final l10n = context.l10n;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: CircleAvatar(
        backgroundColor: AppColors.onPrimary.withValues(alpha: 0.15),
        child: Icon(
          iconForTransactionType(transaction.type),
          color: iconColor,
          size: 20,
        ),
      ),
      title: Text(
        transaction.payee?.isNotEmpty == true
            ? transaction.payee!
            : localizedTransactionType(transaction.type, l10n),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: AppColors.onPrimary),
      ),
      subtitle: transaction.notes?.isNotEmpty == true
          ? Text(
              transaction.notes!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.onPrimary.withValues(alpha: 0.7),
              ),
            )
          : null,
      trailing: Text(
        '$prefix${formatCents(transaction.amount)}',
        style: TextStyle(
          color: typeColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
