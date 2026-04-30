import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:envelope/app/routes/app_router.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/notifications/notifications.dart';
import 'package:envelope/shared/services/app_clock.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:envelope/onboarding/cubit/onboarding_cubit.dart';
import 'package:envelope/onboarding/data/currencies.dart';
import 'package:envelope/settings/cubit/cubit.dart';
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart' hide User;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notification_repository/notification_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(
        authRepository: context.read<AuthRepository>(),
        apiClient: context.read<EnvelopeApiClient>(),
        localDatabase: context.read<AppDatabase>(),
      )..init(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (prev, curr) =>
          prev.successMessage != curr.successMessage ||
          prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        final l10n = context.l10n;
        if (state.successMessage != null) {
          showAppSnackBar(
            context,
            SnackBar(
              content: Text(_localizeMessage(state.successMessage!, l10n)),
            ),
          );
        }
        if (state.status == SettingsStatus.error &&
            state.errorMessage != null) {
          showAppSnackBar(
            context,
            SnackBar(
              content: Text(_localizeMessage(state.errorMessage!, l10n)),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.settingsTitle)),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            final user = authState.user;
            if (user == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, settingsState) {
                return ListView(
                  children: [
                    _SectionHeader(title: l10n.settingsProfile),
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(l10n.settingsDisplayName),
                      subtitle: Text(user.displayName),
                      trailing: const Icon(Icons.edit_outlined),
                      onTap: () => _showEditNameDialog(context, user),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email_outlined),
                      title: Text(l10n.settingsEmail),
                      subtitle: Text(user.email),
                    ),
                    ListTile(
                      leading: const Icon(Icons.lock_outline),
                      title: Text(l10n.settingsChangePassword),
                      onTap: () => _showChangePasswordDialog(context),
                    ),
                    const Divider(),
                    _SectionHeader(title: l10n.settingsPreferences),
                    ListTile(
                      leading: const Icon(Icons.currency_exchange),
                      title: Text(l10n.settingsBaseCurrency),
                      subtitle: Text(user.baseCurrency),
                      onTap: () => _showCurrencyPicker(context, user),
                    ),
                    _ThemeSelector(currentMode: user.themeMode),
                    ListTile(
                      leading: const Icon(Icons.notifications_outlined),
                      title: Text(l10n.settingsNotifications),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => BlocProvider.value(
                            value: context.read<AuthBloc>(),
                            child: RepositoryProvider.value(
                              value: context.read<NotificationRepository>(),
                              child: const NotificationSettingsPage(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    _SectionHeader(title: l10n.settingsData),
                    ListTile(
                      leading: const Icon(Icons.download_outlined),
                      title: Text(l10n.settingsExportData),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        final budgetId =
                            context.read<SharedPreferences>().getString(
                              activeBudgetIdKey,
                            ) ??
                            '';
                        context.go(
                          '${AppRoutes.reports}?budgetId=$budgetId',
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.file_download_outlined),
                      title: Text(l10n.settingsExportAllData),
                      subtitle: Text(l10n.settingsExportAllDataSubtitle),
                      onTap: () =>
                          context.read<SettingsCubit>().exportAllData(user.id),
                    ),
                    const Divider(),
                    _SectionHeader(title: l10n.settingsAccount),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: Text(l10n.settingsSignOut),
                      onTap: () => _showSignOutDialog(context),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.delete_forever,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      title: Text(
                        l10n.settingsDeleteAccount,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      onTap: () => _showDeleteAccountDialog(context),
                    ),
                    const Divider(),
                    if (settingsState.appVersion.isNotEmpty)
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: Text(l10n.settingsAppVersion),
                        subtitle: Text(settingsState.appVersion),
                      ),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip_outlined),
                      title: Text(l10n.settingsPrivacyPolicy),
                      onTap: () => launchUrl(
                        Uri.parse('https://envelope.app/privacy'),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: Text(l10n.settingsTermsOfService),
                      onTap: () => launchUrl(
                        Uri.parse('https://envelope.app/terms'),
                      ),
                    ),
                    if (kDebugMode) ...[
                      const Divider(),
                      _SectionHeader(title: l10n.settingsDebugSection),
                      const _DebugClockTiles(),
                    ],
                    const SizedBox(height: 32),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, User user) {
    final controller = TextEditingController(text: user.displayName);
    final l10n = context.l10n;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.settingsDisplayName),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(hintText: l10n.settingsDisplayName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.settingsCancel),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                context.read<SettingsCubit>().updateDisplayName(name);
              }
              Navigator.pop(dialogContext);
            },
            child: Text(l10n.settingsSave),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final newPasswordController = TextEditingController();
    final confirmController = TextEditingController();
    final l10n = context.l10n;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.settingsChangePassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l10n.settingsNewPassword,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l10n.settingsConfirmPassword,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.settingsCancel),
          ),
          FilledButton(
            onPressed: () {
              final newPassword = newPasswordController.text;
              final confirm = confirmController.text;
              if (newPassword.length < 6) {
                showAppSnackBar(
                  context,
                  SnackBar(
                    content: Text(l10n.settingsPasswordTooShort),
                  ),
                );
                return;
              }
              if (newPassword != confirm) {
                showAppSnackBar(
                  context,
                  SnackBar(
                    content: Text(l10n.settingsPasswordMismatch),
                  ),
                );
                return;
              }
              context.read<SettingsCubit>().changePassword(newPassword);
              Navigator.pop(dialogContext);
            },
            child: Text(l10n.settingsSave),
          ),
        ],
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context, User user) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => BlocProvider.value(
        value: context.read<SettingsCubit>(),
        child: _CurrencyPickerSheet(baseCurrency: user.baseCurrency),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    final l10n = context.l10n;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.settingsSignOut),
        content: Text(l10n.settingsSignOutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.settingsCancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthBloc>().add(const AuthSignOutRequested());
            },
            child: Text(l10n.settingsSignOut),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final controller = TextEditingController();
    final l10n = context.l10n;
    final cubit = context.read<SettingsCubit>();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: BlocConsumer<SettingsCubit, SettingsState>(
          listenWhen: (prev, curr) =>
              prev.status != curr.status && curr.status == SettingsStatus.error,
          listener: (_, _) => Navigator.pop(dialogContext),
          buildWhen: (prev, curr) => prev.status != curr.status,
          builder: (builderContext, state) {
            final isLoading = state.status == SettingsStatus.loading;
            return AlertDialog(
              title: Text(l10n.settingsDeleteAccount),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.settingsDeleteConfirmation),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      hintText: l10n.settingsTypeDelete,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: Text(l10n.settingsCancel),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(builderContext).colorScheme.error,
                  ),
                  onPressed: isLoading
                      ? null
                      : () {
                          if (controller.text.trim() == 'DELETE') {
                            cubit.deleteAccount();
                          }
                        },
                  child: isLoading
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.settingsDeleteAccount),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

String _localizeMessage(String key, AppLocalizations l10n) {
  switch (key) {
    case SettingsMessage.displayNameUpdated:
      return l10n.settingsProfileUpdated;
    case SettingsMessage.currencyUpdated:
      return l10n.settingsCurrencyUpdated;
    case SettingsMessage.passwordChanged:
      return l10n.settingsPasswordChanged;
    case SettingsMessage.updateFailed:
      return l10n.settingsUpdateFailed;
    case SettingsMessage.passwordChangeFailed:
      return l10n.settingsPasswordChangeFailed;
    case SettingsMessage.deleteAccountFailed:
      return l10n.settingsDeleteFailed;
    case SettingsMessage.dataExported:
      return l10n.settingsDataExported;
    case SettingsMessage.dataExportFailed:
      return l10n.settingsDataExportFailed;
    default:
      return key;
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({required this.currentMode});

  final String currentMode;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListTile(
      leading: const Icon(Icons.palette_outlined),
      title: Text(l10n.settingsTheme),
      trailing: SegmentedButton<String>(
        showSelectedIcon: false,
        style: SegmentedButton.styleFrom(
          padding: EdgeInsets.zero,
          textStyle: const TextStyle(fontSize: 12),
          visualDensity: VisualDensity.compact,
        ),
        segments: [
          ButtonSegment(value: 'light', label: Text(l10n.settingsThemeLight)),
          ButtonSegment(value: 'dark', label: Text(l10n.settingsThemeDark)),
          ButtonSegment(value: 'system', label: Text(l10n.settingsThemeSystem)),
        ],
        selected: {currentMode},
        onSelectionChanged: (selected) {
          context.read<SettingsCubit>().updateThemeMode(selected.first);
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _CurrencyPickerSheet extends StatefulWidget {
  const _CurrencyPickerSheet({required this.baseCurrency});

  final String baseCurrency;

  @override
  State<_CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<_CurrencyPickerSheet> {
  String _searchQuery = '';

  List<CurrencyInfo> get _filteredCurrencies {
    if (_searchQuery.isEmpty) return supportedCurrencies;
    final query = _searchQuery.toLowerCase();
    return supportedCurrencies
        .where(
          (c) =>
              c.code.toLowerCase().contains(query) ||
              c.name.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.settingsBaseCurrency,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.settingsCurrencyWarning,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: l10n.onboardingCurrencySearch,
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
            if (_filteredCurrencies.isEmpty)
              const Expanded(
                child: Center(child: Text('No currencies found')),
              )
            else
              Flexible(
                child: ListView.builder(
                  itemCount: _filteredCurrencies.length,
                  itemBuilder: (_, index) {
                    final currency = _filteredCurrencies[index];
                    final isSelected = currency.code == widget.baseCurrency;
                    return ListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      title: Text(
                        '${currency.symbol} ${currency.code}'
                        ' - ${currency.name}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      trailing: isSelected ? const Icon(Icons.check) : null,
                      onTap: () {
                        context.read<SettingsCubit>().updateBaseCurrency(
                          currency.code,
                        );
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DebugClockTiles extends StatefulWidget {
  const _DebugClockTiles();

  @override
  State<_DebugClockTiles> createState() => _DebugClockTilesState();
}

class _DebugClockTilesState extends State<_DebugClockTiles> {
  late final AppClock _appClock;

  @override
  void initState() {
    super.initState();
    _appClock = context.read<AppClock>();
    _appClock.addListener(_onClockChanged);
  }

  @override
  void dispose() {
    _appClock.removeListener(_onClockChanged);
    super.dispose();
  }

  void _onClockChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _pickDate() async {
    final current = _appClock.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null || !mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (pickedTime == null) return;
    await _appClock.setOverride(
      DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      ),
    );
  }

  String _formatNow() {
    final n = _appClock.now();
    return '${n.year.toString().padLeft(4, '0')}-'
        '${n.month.toString().padLeft(2, '0')}-'
        '${n.day.toString().padLeft(2, '0')} '
        '${n.hour.toString().padLeft(2, '0')}:'
        '${n.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasOverride = _appClock.hasOverride;
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.schedule_outlined),
          title: Text(l10n.settingsDebugSimulatedDate),
          subtitle: Text(
            hasOverride ? _formatNow() : l10n.settingsDebugSimulatedDateOff,
          ),
          trailing: const Icon(Icons.edit_outlined),
          onTap: _pickDate,
        ),
        if (hasOverride)
          ListTile(
            leading: const Icon(Icons.history_toggle_off),
            title: Text(l10n.settingsDebugClearSimulatedDate),
            onTap: () => unawaited(_appClock.clearOverride()),
          ),
      ],
    );
  }
}
