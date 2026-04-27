import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/resume_service.dart';

class SummaryForm extends StatelessWidget {
  const SummaryForm({super.key});

  @override
  Widget build(BuildContext context) {
    final resumeService = context.read<ResumeService>();
    final summary = resumeService.currentResume?.summary ?? '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PROFESSIONAL SUMMARY',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: summary,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'Write a brief professional summary...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF0A2540), width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onChanged: (value) {
              context.read<ResumeService>().updateSummary(value);
            },
          ),
        ],
      ),
    );
  }
}
