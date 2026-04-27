import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/resume_model.dart';
import '../../../core/services/resume_service.dart';

class ExperienceForm extends StatelessWidget {
  const ExperienceForm({super.key});

  @override
  Widget build(BuildContext context) {
    // FIX: Using context.select to only rebuild when the NUMBER of experiences changes.
    // This completely prevents the form from losing focus while typing!
    final expCount = context.select<ResumeService, int>((s) => s.currentResume?.experience.length ?? 0);
    final resumeService = context.read<ResumeService>();
    final experiences = resumeService.currentResume?.experience ?? [];

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Work Experience', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Color(0xFF3B82F6)), // Premium Blue
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
                    resumeService.updateExperience([...experiences, newExp]);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...experiences.asMap().entries.map((entry) {
              final index = entry.key;
              final exp = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: exp.jobTitle,
                              decoration: const InputDecoration(labelText: 'Job Title', isDense: true, border: OutlineInputBorder()),
                              onChanged: (val) {
                                final currentExps = context.read<ResumeService>().currentResume?.experience ?? [];
                                final newList = List<Experience>.from(currentExps);
                                newList[index] = exp.copyWith(jobTitle: val);
                                context.read<ResumeService>().updateExperience(newList);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              final currentExps = context.read<ResumeService>().currentResume?.experience ?? [];
                              final newList = List<Experience>.from(currentExps)..removeAt(index);
                              context.read<ResumeService>().updateExperience(newList);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        initialValue: exp.company,
                        decoration: const InputDecoration(labelText: 'Company', isDense: true, border: OutlineInputBorder()),
                        onChanged: (val) {
                          final currentExps = context.read<ResumeService>().currentResume?.experience ?? [];
                          final newList = List<Experience>.from(currentExps);
                          newList[index] = exp.copyWith(company: val);
                          context.read<ResumeService>().updateExperience(newList);
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: exp.startDate,
                              decoration: const InputDecoration(labelText: 'Start Date', isDense: true, border: OutlineInputBorder()),
                              onChanged: (val) {
                                final currentExps = context.read<ResumeService>().currentResume?.experience ?? [];
                                final newList = List<Experience>.from(currentExps);
                                newList[index] = exp.copyWith(startDate: val);
                                context.read<ResumeService>().updateExperience(newList);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              initialValue: exp.endDate,
                              decoration: const InputDecoration(labelText: 'End Date', isDense: true, border: OutlineInputBorder()),
                              onChanged: (val) {
                                final currentExps = context.read<ResumeService>().currentResume?.experience ?? [];
                                final newList = List<Experience>.from(currentExps);
                                newList[index] = exp.copyWith(endDate: val);
                                context.read<ResumeService>().updateExperience(newList);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        initialValue: exp.description,
                        maxLines: 3,
                        decoration: const InputDecoration(labelText: 'Description', isDense: true, border: OutlineInputBorder()),
                        onChanged: (val) {
                          final currentExps = context.read<ResumeService>().currentResume?.experience ?? [];
                          final newList = List<Experience>.from(currentExps);
                          newList[index] = exp.copyWith(description: val);
                          context.read<ResumeService>().updateExperience(newList);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
