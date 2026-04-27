import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/resume_model.dart';
import '../../../core/services/resume_service.dart';

class ProjectsForm extends StatelessWidget {
  const ProjectsForm({super.key});

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
    final projectsCount = context.select<ResumeService, int>((s) => s.currentResume?.projects?.length ?? 0);
    final resumeService = context.read<ResumeService>();
    final projects = resumeService.currentResume?.projects ?? [];

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
              label: const Text('Add Project'),
              onPressed: () {
                final newProject = Project(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: '',
                  description: '',
                  technologies: '',
                  bullets: [],
                );
                resumeService.updateProjects([...projects, newProject]);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0A2540),
                side: BorderSide(color: Colors.grey.shade300),
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
                          child: _buildInputField('Project Name', project.name, (val) {
                            final currentProjects = List<Project>.from(resumeService.currentResume?.projects ?? []);
                            currentProjects[index] = project.copyWith(name: val);
                            resumeService.updateProjects(currentProjects);
                          }),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () {
                            final currentProjects = List<Project>.from(resumeService.currentResume?.projects ?? []);
                            currentProjects.removeAt(index);
                            resumeService.updateProjects(currentProjects);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInputField('Technologies', project.technologies, (val) {
                      final currentProjects = List<Project>.from(resumeService.currentResume?.projects ?? []);
                      currentProjects[index] = project.copyWith(technologies: val);
                      resumeService.updateProjects(currentProjects);
                    }),
                    const SizedBox(height: 20),
                    _buildInputField('Description', project.description, (val) {
                      final currentProjects = List<Project>.from(resumeService.currentResume?.projects ?? []);
                      currentProjects[index] = project.copyWith(description: val);
                      resumeService.updateProjects(currentProjects);
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
