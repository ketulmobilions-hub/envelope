import 'dart:async';

import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/services/app_clock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Persistent banner shown across the shell whenever a simulated clock
/// override is active. Only mounts in `kDebugMode`.
class DebugClockBanner extends StatefulWidget {
  const DebugClockBanner({required this.appClock, super.key});

  final AppClock appClock;

  @override
  State<DebugClockBanner> createState() => _DebugClockBannerState();
}

class _DebugClockBannerState extends State<DebugClockBanner> {
  @override
  void initState() {
    super.initState();
    widget.appClock.addListener(_onClockChanged);
  }

  @override
  void dispose() {
    widget.appClock.removeListener(_onClockChanged);
    super.dispose();
  }

  void _onClockChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();
    if (!widget.appClock.hasOverride) return const SizedBox.shrink();

    final now = widget.appClock.now();
    final formatted =
        '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';

    return Material(
      color: Colors.amber.shade700,
      child: SafeArea(
        bottom: false,
        child: InkWell(
          onTap: () => _pickDate(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                const Icon(Icons.bug_report_outlined, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.l10n.debugClockBannerLabel(formatted),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  iconSize: 18,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.close),
                  onPressed: () => unawaited(widget.appClock.clearOverride()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final current = widget.appClock.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null || !context.mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (pickedTime == null) return;
    await widget.appClock.setOverride(
      DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      ),
    );
  }
}
