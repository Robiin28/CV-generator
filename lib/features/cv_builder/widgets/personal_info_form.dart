import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/resume_service.dart';

class PersonalInfoForm extends StatelessWidget {
  const PersonalInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    // FIX: Use context.read so this form only builds once and never loses focus!
    // The Preview on the right uses context.watch, so it still updates live.
    final resumeService = context.read<ResumeService>();
    final personalInfo = resumeService.currentResume?.personalInfo;

    if (personalInfo == null) return const SizedBox.shrink();

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
            const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 20),
            
            TextFormField(
              initialValue: personalInfo.fullName,
              decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
              onChanged: (value) {
                final current = context.read<ResumeService>().currentResume!.personalInfo;
                context.read<ResumeService>().updatePersonalInfo(current.copyWith(fullName: value));
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              initialValue: personalInfo.jobTitle,
              decoration: const InputDecoration(labelText: 'Job Title', border: OutlineInputBorder()),
              onChanged: (value) {
                final current = context.read<ResumeService>().currentResume!.personalInfo;
                context.read<ResumeService>().updatePersonalInfo(current.copyWith(jobTitle: value));
              },
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: personalInfo.email,
                    decoration: const InputDecoration(labelText: 'Email Address', border: OutlineInputBorder()),
                    onChanged: (value) {
                      final current = context.read<ResumeService>().currentResume!.personalInfo;
                      context.read<ResumeService>().updatePersonalInfo(current.copyWith(email: value));
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: personalInfo.phone,
                    decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                    onChanged: (value) {
                      final current = context.read<ResumeService>().currentResume!.personalInfo;
                      context.read<ResumeService>().updatePersonalInfo(current.copyWith(phone: value));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              initialValue: personalInfo.location,
              decoration: const InputDecoration(labelText: 'Location', border: OutlineInputBorder()),
              onChanged: (value) {
                final current = context.read<ResumeService>().currentResume!.personalInfo;
                context.read<ResumeService>().updatePersonalInfo(current.copyWith(location: value));
              },
            ),
          ],
        ),
      ),
    );
  }
}
