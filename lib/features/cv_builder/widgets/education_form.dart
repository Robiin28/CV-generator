import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/resume_model.dart';
import '../../../core/services/resume_service.dart';

class EducationForm extends StatelessWidget {
  const EducationForm({super.key});

  Widget _buildInputField(String label, String initialValue, Function(String) onChanged) {
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
    final eduCount = context.select<ResumeService, int>((s) => s.currentResume?.education.length ?? 0);
    final resumeService = context.read<ResumeService>();
    final educationList = resumeService.currentResume?.education ?? [];

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
              label: const Text('Add Education'),
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
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0A2540),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ...educationList.asMap().entries.map((entry) {
            final index = entry.key;
            final edu = entry.value;
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
                          child: _buildInputField('School / University', edu.school, (val) {
                            final currentEdu = context.read<ResumeService>().currentResume?.education ?? [];
                            final newList = List<Education>.from(currentEdu);
                            newList[index] = edu.copyWith(school: val);
                            context.read<ResumeService>().updateEducation(newList);
                          }),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () {
                            final currentEdu = context.read<ResumeService>().currentResume?.education ?? [];
                            final newList = List<Education>.from(currentEdu)..removeAt(index);
                            context.read<ResumeService>().updateEducation(newList);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField('Degree', edu.degree, (val) {
                            final currentEdu = context.read<ResumeService>().currentResume?.education ?? [];
                            final newList = List<Education>.from(currentEdu);
                            newList[index] = edu.copyWith(degree: val);
                            context.read<ResumeService>().updateEducation(newList);
                          }),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInputField('Field of Study', edu.fieldOfStudy, (val) {
                            final currentEdu = context.read<ResumeService>().currentResume?.education ?? [];
                            final newList = List<Education>.from(currentEdu);
                            newList[index] = edu.copyWith(fieldOfStudy: val);
                            context.read<ResumeService>().updateEducation(newList);
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField('Start Date', edu.startDate, (val) {
                            final currentEdu = context.read<ResumeService>().currentResume?.education ?? [];
                            final newList = List<Education>.from(currentEdu);
                            newList[index] = edu.copyWith(startDate: val);
                            context.read<ResumeService>().updateEducation(newList);
                          }),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInputField('End Date', edu.endDate, (val) {
                            final currentEdu = context.read<ResumeService>().currentResume?.education ?? [];
                            final newList = List<Education>.from(currentEdu);
                            newList[index] = edu.copyWith(endDate: val);
                            context.read<ResumeService>().updateEducation(newList);
                          }),
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
    );
  }
}
