import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/envelopes/cubit/cubit.dart';
import 'package:envelope/envelopes/view/envelope_form_page.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/services/app_clock.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:envelope/transactions/widgets/cc_pay_bottom_sheet.dart';
import 'package:envelope/transactions/widgets/transaction_helpers.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
        final l10n = context.l10n;
        final envelopeColor =
            AppColors.fromHex(state.envelope.color) ?? AppColors.primary;
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          floatingActionButton: state.envelope.linkedAccountId != null
              ? FloatingActionButton.extended(
                  onPressed: () => _payCC(context, state),
                  label: Text(l10n.ccPayButton),
                  backgroundColor: AppColors.onPrimary,
                  foregroundColor: envelopeColor,
                )
              : null,
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

  Future<void> _payCC(
    BuildContext context,
    EnvelopeDetailState state,
  ) async {
    final linkedId = state.envelope.linkedAccountId!;
    final budgetId = state.envelope.budgetId;
    final userId = context.read<AuthBloc>().state.user?.id ?? '';
    final budgetPeriodId = state.currentPeriodId;
    final accounts = await context
        .read<AccountRepository>()
        .watchAccounts(budgetId)
        .first;
    if (!context.mounted) return;
    final ccAccount = accounts.where((a) => a.id == linkedId).firstOrNull;
    final ccDebtCents = ccAccount != null
        ? (-ccAccount.currentBalance).clamp(0, maxCentsAmount)
        : 0;
    await showCCPayBottomSheet(
      context,
      ccAccountId: linkedId,
      ccAccountName: ccAccount?.name ?? '',
      ccDebtCents: ccDebtCents,
      accounts: accounts,
      budgetId: budgetId,
      userId: userId,
      budgetPeriodId: budgetPeriodId,
      ccPaymentEnvelopeId: state.envelope.id,
    );
  }

  Future<void> _openEdit(
    BuildContext context,
    Envelope envelope,
  ) async {
    final cubit = context.read<EnvelopeDetailCubit>();
    final result = await Navigator.of(context).push<Object>(
      MaterialPageRoute<Object>(
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
    if (result != null && context.mounted) {
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
          showAppSnackBar(
            context,
            SnackBar(
              content: Text(
                l10n.envelopesDetailDeleteSuccess,
              ),
            ),
          );
          Navigator.of(context).pop();
        } else {
          showAppSnackBar(
            context,
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
    final symbol = currencySymbol(context);
    final state = widget.state;
    final envelope = state.envelope;
    final currentGroup = state.currentGroup;
    final available = currentGroup?.available ?? 0;
    final allocated = currentGroup?.allocated ?? 0;
    final spent = currentGroup?.spent ?? 0;

    return SliverAppBar(
      expandedHeight: 210,
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
              child: state.isCreditCardEnvelope
                  ? _buildCreditCardSummary(l10n, symbol)
                  : _buildEnvelopeSummary(
                      l10n,
                      symbol,
                      available: available,
                      allocated: allocated,
                      spent: spent,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnvelopeSummary(
    AppLocalizations l10n,
    String symbol, {
    required int available,
    required int allocated,
    required int spent,
  }) {
    return Column(
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
          formatCents(available, symbol: symbol),
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
                  amount: allocated,
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
                  amount: spent,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// CC Payment envelope header: shows available credit out of the limit when
  /// a credit limit is known, otherwise just the amount due. No allocated /
  /// spent — those figures aren't meaningful for a credit-card envelope.
  Widget _buildCreditCardSummary(AppLocalizations l10n, String symbol) {
    final state = widget.state;
    final availableCredit = state.ccAvailableCreditCents;
    final hasLimit = availableCredit != null;

    final label = hasLimit
        ? l10n.envelopesDetailAvailable
        : l10n.envelopesDetailDue;
    final amount = hasLimit ? availableCredit : state.ccDueCents;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: AppColors.onPrimary,
            fontSize: 13,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          formatCents(amount, symbol: symbol),
          style: GoogleFonts.playfairDisplay(
            color: AppColors.onPrimary,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (hasLimit) ...[
          const SizedBox(height: 4),
          Text(
            l10n.envelopesDetailOfLimit(
              formatCents(state.ccCreditLimit!, symbol: symbol),
            ),
            style: const TextStyle(
              color: AppColors.onPrimary,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.ccDueLabel(formatCents(state.ccDueCents, symbol: symbol)),
            style: const TextStyle(
              color: AppColors.onPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
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

  bool _showHistory = false;

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
      color: theme.colorScheme.onSurfaceVariant,
    );
    final sectionTitle = theme.textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
      color: theme.colorScheme.onSurface,
    );

    return SliverToBoxAdapter(
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _opacityCurve,
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            child: BlocBuilder<EnvelopeDetailCubit, EnvelopeDetailState>(
              buildWhen: (prev, curr) =>
                  prev.transactions != curr.transactions ||
                  prev.allocations != curr.allocations ||
                  prev.periods != curr.periods ||
                  prev.currentPeriodId != curr.currentPeriodId,
              builder: (context, state) {
                final groups = state.groups;
                final currentGroup = groups
                    .where((g) => g.period?.id == state.currentPeriodId)
                    .toList();
                final historyGroups = groups
                    .where((g) => g.period?.id != state.currentPeriodId)
                    .toList();
                final visibleGroups =
                    _showHistory ? groups : currentGroup;
                final hasHistory = historyGroups.isNotEmpty;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
                      child: Text(
                        l10n.envelopesDetailTransactions,
                        style: sectionTitle,
                      ),
                    ),
                    if (visibleGroups.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 48,
                                color: theme.colorScheme.outline,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.envelopesDetailTransactionsPlaceholder,
                                style: mutedStyle,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      for (final group in visibleGroups)
                        _PeriodSection(
                          group: group,
                          isCurrent:
                              group.period?.id == state.currentPeriodId,
                          envelopeColor: widget.envelopeColor,
                          hideFigures: state.isCreditCardEnvelope,
                        ),
                    if (hasHistory) ...[
                      const SizedBox(height: 8),
                      Center(
                        child: TextButton.icon(
                          onPressed: () =>
                              setState(() => _showHistory = !_showHistory),
                          icon: Icon(
                            _showHistory
                                ? Icons.expand_less
                                : Icons.history,
                            size: 18,
                          ),
                          label: Text(
                            _showHistory
                                ? l10n.envelopesDetailHideHistory
                                : l10n.envelopesDetailShowHistory,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
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
    this.labelColor,
    this.amountColor,
  });

  final String label;
  final int amount;
  final Color? labelColor;
  final Color? amountColor;

  @override
  Widget build(BuildContext context) {
    final symbol = currencySymbol(context);
    final resolvedLabel =
        labelColor ?? AppColors.onPrimary.withValues(alpha: 0.8);
    final resolvedAmount = amountColor ?? AppColors.onPrimary;
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: resolvedLabel,
            fontSize: 11,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          formatCents(amount, symbol: symbol),
          style: TextStyle(
            color: resolvedAmount,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

class _PeriodSection extends StatelessWidget {
  const _PeriodSection({
    required this.group,
    required this.isCurrent,
    required this.envelopeColor,
    this.hideFigures = false,
  });

  final EnvelopePeriodGroup group;
  final bool isCurrent;
  final Color envelopeColor;

  /// When true (CC Payment envelope), the allocated/spent/available row is
  /// omitted — those figures aren't meaningful for a credit-card envelope.
  final bool hideFigures;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final period = group.period;
    final transactions = group.transactions;
    final mutedStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final periodLabel = period == null
        ? l10n.envelopesDetailPeriodUncategorized
        : l10n.envelopesDetailPeriodRange(
            DateFormat.yMMMd().format(period.startDate),
            DateFormat.yMMMd().format(period.endDate),
          );

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  periodLabel,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              if (isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    l10n.envelopesDetailPeriodCurrent,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          // Show allocated/spent/available only for historical periods — current
          // period figures are already prominent in the hero header.
          if (period != null && !hideFigures && !isCurrent) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _HeaderDetail(
                  label: l10n.envelopesDetailAllocated,
                  amount: group.allocated,
                  labelColor: theme.colorScheme.onSurfaceVariant,
                  amountColor: theme.colorScheme.onSurface,
                ),
                _HeaderDetail(
                  label: l10n.envelopesDetailSpent,
                  amount: group.spent,
                  labelColor: theme.colorScheme.onSurfaceVariant,
                  amountColor: theme.colorScheme.onSurface,
                ),
                _HeaderDetail(
                  label: l10n.envelopesDetailAvailable,
                  amount: group.available,
                  labelColor: theme.colorScheme.onSurfaceVariant,
                  amountColor: theme.colorScheme.onSurface,
                ),
              ],
            ),
          ],
          const SizedBox(height: 4),
          if (transactions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Text(
                l10n.envelopesDetailPeriodEmpty,
                style: mutedStyle,
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
                      now: context.read<AppClock>().now(),
                    ),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              _TransactionRow(
                transaction: transactions[i],
                envelopeColor: envelopeColor,
              ),
            ],
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({
    required this.transaction,
    required this.envelopeColor,
  });

  final Transaction transaction;
  final Color envelopeColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amountColor = transaction.type == 'income'
        ? AppColors.income
        : theme.colorScheme.onSurface;
    final prefix = transaction.type == 'income' ? '+' : '';
    final l10n = context.l10n;
    final symbol = currencySymbol(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Icon(
          iconForTransactionType(transaction.type),
          color: theme.colorScheme.onPrimaryContainer,
          size: 20,
        ),
      ),
      title: Text(
        transaction.payee?.isNotEmpty == true
            ? transaction.payee!
            : localizedTransactionType(transaction.type, l10n),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: transaction.notes?.isNotEmpty == true
          ? Text(
              transaction.notes!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      trailing: Text(
        '$prefix${formatCents(transaction.amount, symbol: symbol)}',
        style: TextStyle(
          color: amountColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
