import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/resume_model.dart';
import '../../../core/services/resume_service.dart';

class ExperienceForm extends StatelessWidget {
  const ExperienceForm({super.key});

  Widget _buildInputField(String label, String initialValue, Function(String) onChanged, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFF64748B),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          maxLines: maxLines,
          decoration: InputDecoration(
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
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final expCount = context.select<ResumeService, int>((s) => s.currentResume?.experience.length ?? 0);
    final resumeService = context.read<ResumeService>();
    final experiences = resumeService.currentResume?.experience ?? [];

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
                resumeService.updateExperience(<Experience>[...experiences, newExp]);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0A2540),
                side: BorderSide(color: Colors.grey.shade300),
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
                  color: const Color(0xFFF8FAFC),
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildInputField('Job Title', exp.jobTitle, (val) {
                            final currentExps = context.read<ResumeService>().currentResume?.experience ?? [];
                            final newList = List<Experience>.from(currentExps);
                            newList[index] = exp.copyWith(jobTitle: val);
                            context.read<ResumeService>().updateExperience(newList);
                          }),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () {
                            final currentExps = context.read<ResumeService>().currentResume?.experience ?? [];
                            final newList = List<Experience>.from(currentExps)..removeAt(index);
                            context.read<ResumeService>().updateExperience(newList);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInputField('Company', exp.company, (val) {
                      final currentExps = context.read<ResumeService>().currentResume?.experience ?? [];
                      final newList = List<Experience>.from(currentExps);
                      newList[index] = exp.copyWith(company: val);
                      context.read<ResumeService>().updateExperience(newList);
                    }),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField('Start Date', exp.startDate, (val) {
                            final currentExps = context.read<ResumeService>().currentResume?.experience ?? [];
                            final newList = List<Experience>.from(currentExps);
                            newList[index] = exp.copyWith(startDate: val);
                            context.read<ResumeService>().updateExperience(newList);
                          }),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInputField('End Date', exp.endDate, (val) {
                            final currentExps = context.read<ResumeService>().currentResume?.experience ?? [];
                            final newList = List<Experience>.from(currentExps);
                            newList[index] = exp.copyWith(endDate: val);
                            context.read<ResumeService>().updateExperience(newList);
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInputField('Description', exp.description, (val) {
                      final currentExps = context.read<ResumeService>().currentResume?.experience ?? [];
                      final newList = List<Experience>.from(currentExps);
                      newList[index] = exp.copyWith(description: val);
                      context.read<ResumeService>().updateExperience(newList);
                    }, maxLines: 3),
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
