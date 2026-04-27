import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/resume_service.dart';

class SummaryForm extends StatelessWidget {
  const SummaryForm({super.key});

  @override
  Widget build(BuildContext context) {
    // FIX: Use context.read so this form only builds once and never loses focus!
    final resumeService = context.read<ResumeService>();
    final summary = resumeService.currentResume?.summary ?? '';

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Professional Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: summary,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Write a brief professional summary...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                context.read<ResumeService>().updateSummary(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
