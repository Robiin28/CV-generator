import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/resume_model.dart';
import '../../../core/services/resume_service.dart';
import 'ai_input_field.dart';

class ProjectsForm extends StatelessWidget {
  const ProjectsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<ResumeService>().currentResume?.projects ?? [];
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
              label: const Text('Add Project'),
              onPressed: () {
                final newProject = Project(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: '',
                  description: '',
                  technologies: '',
                  bullets: [],
                );
                context.read<ResumeService>().updateProjects([...projects, newProject]);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : const Color(0xFF0A2540),
                side: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ...projects.asMap().entries.map((entry) {
            final index = entry.key;
            final project = entry.value;

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
                            label: 'Project Name', 
                            initialValue: project.name, 
                            onChanged: (val) {
                              final current = context.read<ResumeService>().currentResume?.projects ?? [];
                              final newList = List<Project>.from(current);
                              newList[index] = newList[index].copyWith(name: val);
                              context.read<ResumeService>().updateProjects(newList);
                            }, 
                            aiContext: 'professional project name'
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () {
                            final current = context.read<ResumeService>().currentResume?.projects ?? [];
                            final newList = List<Project>.from(current)..removeAt(index);
                            context.read<ResumeService>().updateProjects(newList);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AIInputField(
                      label: 'Technologies', 
                      initialValue: project.technologies, 
                      onChanged: (val) {
                        final current = context.read<ResumeService>().currentResume?.projects ?? [];
                        final newList = List<Project>.from(current);
                        newList[index] = newList[index].copyWith(technologies: val);
                        context.read<ResumeService>().updateProjects(newList);
                      }, 
                      aiContext: 'list of technologies for a software project'
                    ),
                    const SizedBox(height: 20),
                    AIInputField(
                      label: 'Description', 
                      initialValue: project.description, 
                      maxLines: 3,
                      onChanged: (val) {
                        final current = context.read<ResumeService>().currentResume?.projects ?? [];
                        final newList = List<Project>.from(current);
                        newList[index] = newList[index].copyWith(description: val);
                        context.read<ResumeService>().updateProjects(newList);
                      }, 
                      aiContext: 'professional description for the project ${project.name} using ${project.technologies}'
                    ),
                    const SizedBox(height: 20),
                    AIInputField(
                      label: 'View Profile Link (e.g. LinkedIn URL)', 
                      initialValue: project.link ?? '', 
                      onChanged: (val) {
                        final current = context.read<ResumeService>().currentResume?.projects ?? [];
                        final newList = List<Project>.from(current);
                        newList[index] = newList[index].copyWith(link: val);
                        context.read<ResumeService>().updateProjects(newList);
                      }
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
