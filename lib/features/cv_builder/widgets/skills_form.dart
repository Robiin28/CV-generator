import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/resume_model.dart';
import '../../../core/services/resume_service.dart';
import 'ai_enhancer_button.dart';

class SkillsForm extends StatelessWidget {
  const SkillsForm({super.key});

  Widget _buildInputField(BuildContext context, String label, String initialValue, Function(String) onChanged, {String? aiContext}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white54 : const Color(0xFF64748B),
                    letterSpacing: 1.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (aiContext != null)
                AIEnhancerButton(
                  currentText: initialValue,
                  context: aiContext,
                  onEnhanced: onChanged,
                ),
            ],
          ),
          const SizedBox(height: 6),
        ],
        TextFormField(
          key: ValueKey(initialValue),
          initialValue: initialValue,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          decoration: InputDecoration(
            fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: isDark ? Colors.blueAccent : const Color(0xFF0A2540), width: 2),
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
    final skills = context.watch<ResumeService>().currentResume?.skills ?? [];
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
              label: const Text('Add Category'),
              onPressed: () {
                final newCategory = SkillCategory(category: '', skills: []);
                context.read<ResumeService>().updateSkills([...skills, newCategory]);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : const Color(0xFF0A2540),
                side: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300),
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
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                  border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            context, 
                            'Category Name', 
                            category.category, 
                            (val) {
                              final current = context.read<ResumeService>().currentResume?.skills ?? [];
                              final newList = List<SkillCategory>.from(current);
                              newList[catIndex] = newList[catIndex].copyWith(category: val);
                              context.read<ResumeService>().updateSkills(newList);
                            },
                            aiContext: 'skill category name (e.g. Technical Skills, Soft Skills)',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () {
                            final current = context.read<ResumeService>().currentResume?.skills ?? [];
                            final newList = List<SkillCategory>.from(current)..removeAt(catIndex);
                            context.read<ResumeService>().updateSkills(newList);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'SKILLS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white54 : const Color(0xFF64748B),
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
                            label: Text(skillName, style: TextStyle(color: isDark ? Colors.white : Colors.black87)),
                            deleteIcon: Icon(Icons.close, size: 14, color: isDark ? Colors.white54 : Colors.black54),
                            onDeleted: () {
                              final current = context.read<ResumeService>().currentResume?.skills ?? [];
                              final updatedCategorySkills = List<String>.from(category.skills)..removeAt(skillIndex);
                              final newList = List<SkillCategory>.from(current);
                              newList[catIndex] = newList[catIndex].copyWith(skills: updatedCategorySkills);
                              context.read<ResumeService>().updateSkills(newList);
                            },
                            backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade300),
                            ),
                          );
                        }),
                        ActionChip(
                          avatar: Icon(Icons.add, size: 14, color: isDark ? Colors.blueAccent : const Color(0xFF0A2540)),
                          label: Text('Add Skill', style: TextStyle(color: isDark ? Colors.blueAccent : const Color(0xFF0A2540))),
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
                            if (!context.mounted) return;

                            if (skill != null && skill.isNotEmpty) {
                              final current = context.read<ResumeService>().currentResume?.skills ?? [];
                              final updatedCategorySkills = List<String>.from(category.skills)..add(skill);
                              final newList = List<SkillCategory>.from(current);
                              newList[catIndex] = newList[catIndex].copyWith(skills: updatedCategorySkills);
                              context.read<ResumeService>().updateSkills(newList);
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
