import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/resume_service.dart';
import 'ai_input_field.dart';

class SummaryForm extends StatelessWidget {
  const SummaryForm({super.key});

  @override
  Widget build(BuildContext context) {
    final summary = context.watch<ResumeService>().currentResume?.summary ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AIInputField(
            label: 'PROFESSIONAL SUMMARY',
            initialValue: summary,
            maxLines: 8,
            aiContext: 'professional summary for a CV',
            onChanged: (val) {
              context.read<ResumeService>().updateSummary(val);
            },
          ),
        ],
      ),
    );
  }
}
