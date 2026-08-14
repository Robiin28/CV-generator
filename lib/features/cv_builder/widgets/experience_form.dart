import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/resume_model.dart';
import '../../../core/services/resume_service.dart';
import 'ai_input_field.dart';

class ExperienceForm extends StatelessWidget {
  const ExperienceForm({super.key});

  @override
  Widget build(BuildContext context) {
    final experiences = context.watch<ResumeService>().currentResume?.experience ?? [];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Experience'),
              onPressed: () {
                final newExp = Experience(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  jobTitle: '',
                  company: '',
                  location: '',
                  startDate: '',
                  endDate: '',
                  current: false,
                  description: '',
                  bullets: [],
                );
                context.read<ResumeService>().updateExperience(<Experience>[...experiences, newExp]);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : const Color(0xFF0A2540),
                side: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ...experiences.asMap().entries.map((entry) {
            final index = entry.key;
            final exp = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                  border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AIInputField(
                            label: 'Job Title', 
                            initialValue: exp.jobTitle, 
                            onChanged: (val) {
                              final current = context.read<ResumeService>().currentResume?.experience ?? [];
                              final newList = List<Experience>.from(current);
                              newList[index] = newList[index].copyWith(jobTitle: val);
                              context.read<ResumeService>().updateExperience(newList);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () {
                            final current = context.read<ResumeService>().currentResume?.experience ?? [];
                            final newList = List<Experience>.from(current)..removeAt(index);
                            context.read<ResumeService>().updateExperience(newList);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AIInputField(
                      label: 'Company', 
                      initialValue: exp.company, 
                      onChanged: (val) {
                        final current = context.read<ResumeService>().currentResume?.experience ?? [];
                        final newList = List<Experience>.from(current);
                        newList[index] = newList[index].copyWith(company: val);
                        context.read<ResumeService>().updateExperience(newList);
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: AIInputField(
                            label: 'Start Date', 
                            initialValue: exp.startDate, 
                            onChanged: (val) {
                              final current = context.read<ResumeService>().currentResume?.experience ?? [];
                              final newList = List<Experience>.from(current);
                              newList[index] = newList[index].copyWith(startDate: val);
                              context.read<ResumeService>().updateExperience(newList);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AIInputField(
                            label: 'End Date', 
                            initialValue: exp.endDate, 
                            onChanged: (val) {
                              final current = context.read<ResumeService>().currentResume?.experience ?? [];
                              final newList = List<Experience>.from(current);
                              newList[index] = newList[index].copyWith(endDate: val);
                              context.read<ResumeService>().updateExperience(newList);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AIInputField(
                      label: 'Description', 
                      initialValue: exp.description, 
                      maxLines: 3,
                      onChanged: (val) {
                        final current = context.read<ResumeService>().currentResume?.experience ?? [];
                        final newList = List<Experience>.from(current);
                        newList[index] = newList[index].copyWith(description: val);
                        context.read<ResumeService>().updateExperience(newList);
                      }, 
                      aiContext: 'job description for ${exp.jobTitle} at ${exp.company}',
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
