import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/accounts/widgets/account_helpers.dart';
import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/dashboard/bloc/bloc.dart';
import 'package:envelope/dashboard/widgets/allocate_envelope_sheet.dart';
import 'package:envelope/envelopes/cubit/cubit.dart';
import 'package:envelope/envelopes/view/envelope_detail_page.dart';
import 'package:envelope/envelopes/widgets/envelope_card.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/onboarding/cubit/onboarding_cubit.dart';
import 'package:envelope/shared/services/app_clock.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/shared/widgets/animated_cents.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:envelope/transactions/widgets/cc_pay_bottom_sheet.dart';
import 'package:envelope/transactions/widgets/cover_overspend_dialog.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Displays envelopes grouped by category on the dashboard.
class EnvelopeSummaryCard extends StatelessWidget {
  const EnvelopeSummaryCard({
    required this.summaries,
    this.categoryGroups = const [],
    this.accounts = const [],
    this.ccCreditLimits = const {},
    this.onViewAll,
    super.key,
  });

  final List<EnvelopeSummary> summaries;
  final List<CategoryGroup> categoryGroups;
  final List<Account> accounts;
  final Map<String, int?> ccCreditLimits;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    if (summaries.isEmpty) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.mail_outline,
                  size: 40,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.dashboardNoEnvelopes,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Group summaries by category group ID, sorted by group sortOrder.
    final grouped = <String, List<EnvelopeSummary>>{};
    for (final s in summaries) {
      grouped.putIfAbsent(s.envelope.categoryGroupId, () => []).add(s);
    }
    final sortedGroupIds = grouped.keys.toList()
      ..sort((a, b) {
        final aOrder =
            categoryGroups.where((g) => g.id == a).firstOrNull?.sortOrder ?? 0;
        final bOrder =
            categoryGroups.where((g) => g.id == b).firstOrNull?.sortOrder ?? 0;
        return aOrder.compareTo(bOrder);
      });
    for (final groupId in sortedGroupIds) {
      grouped[groupId]!.sort(
        (a, b) => a.envelope.sortOrder.compareTo(b.envelope.sortOrder),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row with View All link.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.dashboardEnvelopes,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              if (onViewAll != null)
                InkWell(
                  onTap: onViewAll,
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: Text(
                      l10n.dashboardViewAll,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Category groups in sortOrder.
          for (final groupId in sortedGroupIds)
            _CategoryGroupSection(
              groupName:
                  categoryGroups
                      .where((g) => g.id == groupId)
                      .firstOrNull
                      ?.name ??
                  grouped[groupId]!.first.categoryGroupName,
              summaries: grouped[groupId]!,
              categoryGroups: categoryGroups,
              accounts: accounts,
              ccCreditLimits: ccCreditLimits,
              onViewAll: onViewAll,
            ),
        ],
      ),
    );
  }
}

class _CategoryGroupSection extends StatelessWidget {
  const _CategoryGroupSection({
    required this.groupName,
    required this.summaries,
    required this.categoryGroups,
    this.accounts = const [],
    this.ccCreditLimits = const {},
    this.onViewAll,
  });

  final String groupName;
  final List<EnvelopeSummary> summaries;
  final List<CategoryGroup> categoryGroups;
  final List<Account> accounts;
  final Map<String, int?> ccCreditLimits;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final symbol = currencySymbol(context);

    // Compute group totals.
    final totalAllocated = summaries.fold(0, (sum, s) => sum + s.allocated);
    final totalAvailable = summaries.fold(0, (sum, s) => sum + s.available);
    final availColor = totalAvailable < 0
        ? AppColors.expense
        : AppColors.charcoal;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header with totals beside it.
          Row(
            children: [
              Expanded(
                child: Text(
                  groupName.toUpperCase(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.charcoal,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              AnimatedCents(
                cents: totalAvailable,
                symbol: symbol,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: availColor,
                ),
              ),
              AnimatedCents(
                cents: totalAllocated,
                symbol: symbol,
                prefix: '/',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              if (onViewAll != null) ...[
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 18,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: AppColors.secondaryText,
                  onPressed: onViewAll,
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          // Envelope cards grid.
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = (constraints.maxWidth / 200).floor().clamp(2, 6);
              final cardWidth =
                  (constraints.maxWidth - (columns - 1) * 8) / columns;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: summaries.map(
                  (s) {
                    final linkedId = s.envelope.linkedAccountId;
                    final creditLimit = linkedId != null
                        ? ccCreditLimits[linkedId]
                        : null;
                    final ccAccount = linkedId != null
                        ? accounts.where((a) => a.id == linkedId).firstOrNull
                        : null;

                    final hasCreditInfo =
                        creditLimit != null && ccAccount != null;
                    final displayAvailable = hasCreditInfo
                        ? creditLimit + ccAccount.currentBalance
                        : s.available;
                    final displayAllocated = hasCreditInfo
                        ? creditLimit
                        : s.budgeted;
                    final displayOverspent = hasCreditInfo
                        ? displayAvailable < 0
                        : s.isOverspent;

                    final ccDebt = hasCreditInfo
                        ? (-ccAccount.currentBalance).clamp(0, maxCentsAmount)
                        : 0;
                    final primaryLabel = hasCreditInfo
                        ? context.l10n.ccDueLabel(
                            formatCents(ccDebt, symbol: symbol),
                          )
                        : null;
                    final limitLabel = hasCreditInfo
                        ? context.l10n.ccLimitLabel(
                            formatCents(
                              displayAvailable,
                              symbol: symbol,
                            ),
                            formatCents(
                              displayAllocated,
                              symbol: symbol,
                            ),
                          )
                        : null;

                    return SizedBox(
                      width: cardWidth,
                      child: EnvelopeCard(
                        name: s.envelope.name,
                        availableCents: displayAvailable,
                        allocatedCents: displayAllocated,
                        spentCents: s.spent,
                        isOverspent: displayOverspent,
                        primaryLabel: primaryLabel,
                        limitLabel: limitLabel,
                        color: AppColors.fromHex(s.envelope.color),
                        heroTag: 'envelope_${s.envelope.id}',
                        onTap: () => _openDetail(context, s),
                        onEditTap: linkedId != null
                            ? null
                            : () {
                                unawaited(
                                  showAllocateEnvelopeSheet(
                                    context,
                                    envelopeId: s.envelope.id,
                                    envelopeName: s.envelope.name,
                                    currentAllocatedCents:
                                        s.allocation?.allocatedAmount ?? 0,
                                  ),
                                );
                              },
                        onFixOverspend:
                            linkedId == null &&
                                s.isOverspent &&
                                s.allocation != null
                            ? () => _fixOverspend(context, s)
                            : null,
                        onPay: linkedId != null && ccAccount != null
                            ? () => _showCCPayBottomSheet(
                                context,
                                ccAccount,
                                linkedId,
                              )
                            : null,
                      ),
                    );
                  },
                ).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _fixOverspend(
    BuildContext context,
    EnvelopeSummary summary,
  ) async {
    final dashState = context.read<DashboardBloc>().state;

    // Find a CC account used for this envelope's transactions, then look up
    // its linked CC Payment allocation so it can be funded alongside the cover.
    final ccAccountId = dashState.transactions
        .where((t) => t.envelopeId == summary.envelope.id)
        .map((t) => t.accountId)
        .where((id) {
          final account = dashState.accounts
              .where((a) => a.id == id)
              .firstOrNull;
          return account != null && isCreditCard(account.type);
        })
        .firstOrNull;

    final ccPaymentEnvelope = ccAccountId != null
        ? dashState.envelopes
              .where((e) => e.linkedAccountId == ccAccountId)
              .firstOrNull
        : null;

    final ccPaymentAllocation = ccPaymentEnvelope != null
        ? dashState.allocations
              .where((a) => a.envelopeId == ccPaymentEnvelope.id)
              .firstOrNull
        : null;

    final result = await showCoverOverspendDialog(
      context,
      budgetRepository: context.read<BudgetRepository>(),
      envelopeRepository: context.read<EnvelopeRepository>(),
      allocations: dashState.allocations,
      envelopes: dashState.envelopes,
      overspentAllocation: summary.allocation!,
      overspentEnvelopeName: summary.envelope.name,
      deficitCents: -summary.available,
      readyToAssign: dashState.readyToAssign,
      ccPaymentAllocation: ccPaymentAllocation,
    );

    if (result == true && context.mounted) {
      context.read<DashboardBloc>().add(const DashboardRefreshRequested());
    }
  }

  Future<void> _showCCPayBottomSheet(
    BuildContext context,
    Account ccAccount,
    String linkedId,
  ) async {
    final dashState = context.read<DashboardBloc>().state;
    final budgetId =
        context.read<SharedPreferences>().getString(activeBudgetIdKey) ?? '';
    final userId = context.read<AuthBloc>().state.user?.id ?? '';
    final budgetPeriodId = dashState.selectedPeriod?.id;
    final ccDebtCents = (-ccAccount.currentBalance).clamp(0, maxCentsAmount);

    await showCCPayBottomSheet(
      context,
      ccAccountId: linkedId,
      ccAccountName: ccAccount.name,
      ccDebtCents: ccDebtCents,
      accounts: dashState.accounts,
      budgetId: budgetId,
      userId: userId,
      budgetPeriodId: budgetPeriodId,
    );

    if (context.mounted) {
      context.read<DashboardBloc>().add(const DashboardRefreshRequested());
    }
  }

  void _openDetail(BuildContext context, EnvelopeSummary summary) {
    unawaited(
      Navigator.of(context).push(
        PageRouteBuilder<void>(
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, animation, secondaryAnimation) => BlocProvider(
            create: (_) => EnvelopeDetailCubit(
              envelopeRepository: context.read<EnvelopeRepository>(),
              envelope: summary.envelope,
              allocation: summary.allocation,
              transactionRepository: context.read<TransactionRepository>(),
              budgetRepository: context.read<BudgetRepository>(),
              now: context.read<AppClock>().now,
            ),
            child: EnvelopeDetailPage(
              categoryGroups: categoryGroups,
            ),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          },
        ),
      ),
    );
  }
}
