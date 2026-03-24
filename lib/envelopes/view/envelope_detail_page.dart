import 'dart:async';

import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/envelopes/cubit/cubit.dart';
import 'package:envelope/envelopes/view/envelope_form_page.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
        return Scaffold(
          backgroundColor: AppColors.primary,
          body: CustomScrollView(
            slivers: [
              _EnvelopeAppBar(
                state: state,
                heroTag: 'envelope_${state.envelope.id}',
                onEdit: () => _openEdit(context, state.envelope),
                onDelete: () => _confirmDelete(context),
              ),
              const _EnvelopeContent(),
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
        builder: (_) => EnvelopeFormPage(
          envelopeRepository:
              context.read<EnvelopeRepository>(),
          budgetId: envelope.budgetId,
          categoryGroups: categoryGroups,
          envelope: envelope,
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
            onPressed: () =>
                Navigator.of(dialogContext).pop(false),
            child: Text(l10n.envelopesCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor:
                  Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () =>
                Navigator.of(dialogContext).pop(true),
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
    required this.heroTag,
    required this.onEdit,
    required this.onDelete,
  });

  final EnvelopeDetailState state;
  final String heroTag;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<_EnvelopeAppBar> createState() =>
      _EnvelopeAppBarState();
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

    _scheduleAnimation();
  }

  void _scheduleAnimation() {
    ModalRoute.of(context)?.animation?.addStatusListener(
      _onRouteAnimationStatus,
    );
  }

  void _onRouteAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      unawaited(_controller.forward());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Re-attach in case the route wasn't ready in initState.
    final routeAnimation = ModalRoute.of(context)?.animation;
    routeAnimation?.removeStatusListener(
      _onRouteAnimationStatus,
    );
    routeAnimation?.addStatusListener(
      _onRouteAnimationStatus,
    );
    // If the route is already completed (e.g. no transition),
    // start immediately.
    if (routeAnimation?.status == AnimationStatus.completed) {
      unawaited(_controller.forward());
    }
  }

  @override
  void dispose() {
    ModalRoute.of(context)?.animation?.removeStatusListener(
      _onRouteAnimationStatus,
    );
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
      backgroundColor: AppColors.primary,
      iconTheme:
          const IconThemeData(color: AppColors.onPrimary),
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
              color: AppColors.primary,
              padding: const EdgeInsets.fromLTRB(
                24, 80, 24, 48,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.envelopesDetailAvailable
                        .toUpperCase(),
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
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      SlideTransition(
                        position: _slideLeft,
                        child: FadeTransition(
                          opacity: _opacityCurve,
                          child: _HeaderDetail(
                            label:
                                l10n.envelopesDetailAllocated,
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
                            label:
                                l10n.envelopesDetailSpent,
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
  const _EnvelopeContent();

  @override
  State<_EnvelopeContent> createState() =>
      _EnvelopeContentState();
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeAnimation = ModalRoute.of(context)?.animation;
    routeAnimation?.removeStatusListener(
      _onRouteAnimationStatus,
    );
    routeAnimation?.addStatusListener(
      _onRouteAnimationStatus,
    );
    if (routeAnimation?.status == AnimationStatus.completed) {
      unawaited(_controller.forward());
    }
  }

  void _onRouteAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      unawaited(_controller.forward());
    }
  }

  @override
  void dispose() {
    ModalRoute.of(context)?.animation?.removeStatusListener(
      _onRouteAnimationStatus,
    );
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
    final sectionTitle =
        theme.textTheme.titleSmall?.copyWith(
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
            color: AppColors.primary,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Allocation history.
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        l10n
                            .envelopesDetailAllocationHistory
                            .toUpperCase(),
                        style: sectionTitle,
                      ),
                      const SizedBox(height: 16),
                      const Icon(
                        Icons.history_outlined,
                        size: 48,
                        color: AppColors.primaryDark,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n
                            .envelopesDetailAllocationHistoryPlaceholder,
                        style: mutedStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: AppColors.onPrimary
                      .withValues(alpha: 0.2),
                ),
                // Transactions.
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.receipt_long_outlined,
                        size: 48,
                        color: AppColors.primaryDark,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n
                            .envelopesDetailTransactionsPlaceholder
                            .toUpperCase(),
                        style: mutedStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: AppColors.onPrimary
                      .withValues(alpha: 0.2),
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
                        l10n
                            .envelopesDetailGoalProgressPlaceholder
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
            color:
                AppColors.onPrimary.withValues(alpha: 0.8),
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
