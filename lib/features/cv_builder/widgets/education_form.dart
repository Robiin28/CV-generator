import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/resume_model.dart';
import '../../../core/services/resume_service.dart';

class EducationForm extends StatelessWidget {
  const EducationForm({super.key});

  @override
  Widget build(BuildContext context) {
    // FIX: Using context.select to only rebuild when the NUMBER of educations changes.
    // This completely prevents the form from losing focus while typing!
    final eduCount = context.select<ResumeService, int>((s) => s.currentResume?.education.length ?? 0);
    final resumeService = context.read<ResumeService>();
    final educationList = resumeService.currentResume?.education ?? [];

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
                const Text('Education', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Color(0xFF3B82F6)), // Premium Blue
                  onPressed: () {
                    final newEdu = Education(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      school: '',
                      degree: '',
                      fieldOfStudy: '',
                      startDate: '',
                      endDate: '',
                      description: '',
                    );
                    resumeService.updateEducation([...educationList, newEdu]);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...educationList.asMap().entries.map((entry) {
              final index = entry.key;
              final edu = entry.value;
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
                              initialValue: edu.school,
                              decoration: const InputDecoration(labelText: 'School/University', isDense: true, border: OutlineInputBorder()),
                              onChanged: (val) {
                                final currentEdu = context.read<ResumeService>().currentResume?.education ?? [];
                                final newList = List<Education>.from(currentEdu);
                                newList[index] = edu.copyWith(school: val);
                                context.read<ResumeService>().updateEducation(newList);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              final currentEdu = context.read<ResumeService>().currentResume?.education ?? [];
                              final newList = List<Education>.from(currentEdu)..removeAt(index);
                              context.read<ResumeService>().updateEducation(newList);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: edu.degree,
                              decoration: const InputDecoration(labelText: 'Degree', isDense: true, border: OutlineInputBorder()),
                              onChanged: (val) {
                                final currentEdu = context.read<ResumeService>().currentResume?.education ?? [];
                                final newList = List<Education>.from(currentEdu);
                                newList[index] = edu.copyWith(degree: val);
                                context.read<ResumeService>().updateEducation(newList);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              initialValue: edu.fieldOfStudy,
                              decoration: const InputDecoration(labelText: 'Field of Study', isDense: true, border: OutlineInputBorder()),
                              onChanged: (val) {
                                final currentEdu = context.read<ResumeService>().currentResume?.education ?? [];
                                final newList = List<Education>.from(currentEdu);
                                newList[index] = edu.copyWith(fieldOfStudy: val);
                                context.read<ResumeService>().updateEducation(newList);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: edu.startDate,
                              decoration: const InputDecoration(labelText: 'Start Date', isDense: true, border: OutlineInputBorder()),
                              onChanged: (val) {
                                final currentEdu = context.read<ResumeService>().currentResume?.education ?? [];
                                final newList = List<Education>.from(currentEdu);
                                newList[index] = edu.copyWith(startDate: val);
                                context.read<ResumeService>().updateEducation(newList);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              initialValue: edu.endDate,
                              decoration: const InputDecoration(labelText: 'End Date', isDense: true, border: OutlineInputBorder()),
                              onChanged: (val) {
                                final currentEdu = context.read<ResumeService>().currentResume?.education ?? [];
                                final newList = List<Education>.from(currentEdu);
                                newList[index] = edu.copyWith(endDate: val);
                                context.read<ResumeService>().updateEducation(newList);
                              },
                            ),
                          ),
                        ],
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
