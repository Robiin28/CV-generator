import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/resume_model.dart';
import '../../../core/services/resume_service.dart';

class SkillsForm extends StatelessWidget {
  const SkillsForm({super.key});

  Widget _buildInputField(String label, String initialValue, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
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
        ],
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
    final skillCategoriesCount = context.select<ResumeService, int>((s) => s.currentResume?.skills.length ?? 0);
    final resumeService = context.read<ResumeService>();
    final skills = resumeService.currentResume?.skills ?? [];

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
              label: const Text('Add Category'),
              onPressed: () {
                final newCategory = SkillCategory(category: '', skills: []);
                resumeService.updateSkills([...skills, newCategory]);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0A2540),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ...skills.asMap().entries.map((entry) {
            final catIndex = entry.key;
            final category = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField('Category Name', category.category, (val) {
                            final currentSkills = List<SkillCategory>.from(resumeService.currentResume?.skills ?? []);
                            currentSkills[catIndex] = category.copyWith(category: val);
                            resumeService.updateSkills(currentSkills);
                          }),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () {
                            final currentSkills = List<SkillCategory>.from(resumeService.currentResume?.skills ?? []);
                            currentSkills.removeAt(catIndex);
                            resumeService.updateSkills(currentSkills);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'SKILLS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF64748B),
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...category.skills.asMap().entries.map((skillEntry) {
                          final skillIndex = skillEntry.key;
                          final skillName = skillEntry.value;

                          return Chip(
                            label: Text(skillName),
                            deleteIcon: const Icon(Icons.close, size: 14),
                            onDeleted: () {
                              final currentSkills = List<SkillCategory>.from(resumeService.currentResume?.skills ?? []);
                              final updatedCategorySkills = List<String>.from(category.skills)..removeAt(skillIndex);
                              currentSkills[catIndex] = category.copyWith(skills: updatedCategorySkills);
                              resumeService.updateSkills(currentSkills);
                            },
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                          );
                        }),
                        ActionChip(
                          avatar: const Icon(Icons.add, size: 14),
                          label: const Text('Add Skill'),
                          onPressed: () async {
                            final controller = TextEditingController();
                            final skill = await showDialog<String>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Add Skill'),
                                content: TextField(
                                  controller: controller,
                                  autofocus: true,
                                  decoration: const InputDecoration(hintText: 'e.g. Flutter'),
                                ),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context, controller.text),
                                    child: const Text('Add'),
                                  ),
                                ],
                              ),
                            );

                            if (skill != null && skill.isNotEmpty) {
                              final currentSkills = List<SkillCategory>.from(resumeService.currentResume?.skills ?? []);
                              final updatedCategorySkills = List<String>.from(category.skills)..add(skill);
                              currentSkills[catIndex] = category.copyWith(skills: updatedCategorySkills);
                              resumeService.updateSkills(currentSkills);
                            }
                          },
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
