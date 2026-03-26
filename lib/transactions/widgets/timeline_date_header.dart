import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:envelope/transactions/widgets/transaction_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A serif-styled date header for the timeline transaction layout.
class TimelineDateHeader extends StatelessWidget {
  const TimelineDateHeader({required this.date, super.key});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        formatDateHeader(date, l10n).toUpperCase(),
        style: GoogleFonts.playfairDisplay(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
          color: AppColors.secondaryText,
        ),
      ),
    );
  }
}
