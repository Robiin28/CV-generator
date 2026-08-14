import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/resume_model.dart';
import '../../../core/services/resume_service.dart';
import 'ai_input_field.dart';

class VolunteeringForm extends StatelessWidget {
  const VolunteeringForm({super.key});

  @override
  Widget build(BuildContext context) {
    final volunteering = context.watch<ResumeService>().currentResume?.volunteering ?? [];
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
              label: const Text('Add Volunteering'),
              onPressed: () {
                final newVolunteering = Volunteering(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  role: '',
                  organization: '',
                  location: '',
                  startDate: '',
                  endDate: '',
                  current: false,
                  description: '',
                );
                context.read<ResumeService>().updateVolunteering([...volunteering, newVolunteering]);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : const Color(0xFF0A2540),
                side: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ...volunteering.asMap().entries.map((entry) {
            final index = entry.key;
            final vol = entry.value;

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
                            label: 'Role / Position', 
                            initialValue: vol.role, 
                            onChanged: (val) {
                              final current = context.read<ResumeService>().currentResume?.volunteering ?? [];
                              final newList = List<Volunteering>.from(current);
                              newList[index] = newList[index].copyWith(role: val);
                              context.read<ResumeService>().updateVolunteering(newList);
                            }, 
                            aiContext: 'volunteering role title',
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () {
                            final current = context.read<ResumeService>().currentResume?.volunteering ?? [];
                            final newList = List<Volunteering>.from(current)..removeAt(index);
                            context.read<ResumeService>().updateVolunteering(newList);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AIInputField(
                      label: 'Organization', 
                      initialValue: vol.organization, 
                      onChanged: (val) {
                        final current = context.read<ResumeService>().currentResume?.volunteering ?? [];
                        final newList = List<Volunteering>.from(current);
                        newList[index] = newList[index].copyWith(organization: val);
                        context.read<ResumeService>().updateVolunteering(newList);
                      },
                    ),
                    const SizedBox(height: 20),
                    AIInputField(
                      label: 'Location', 
                      initialValue: vol.location, 
                      onChanged: (val) {
                        final current = context.read<ResumeService>().currentResume?.volunteering ?? [];
                        final newList = List<Volunteering>.from(current);
                        newList[index] = newList[index].copyWith(location: val);
                        context.read<ResumeService>().updateVolunteering(newList);
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: AIInputField(
                            label: 'Start Date', 
                            initialValue: vol.startDate, 
                            onChanged: (val) {
                              final current = context.read<ResumeService>().currentResume?.volunteering ?? [];
                              final newList = List<Volunteering>.from(current);
                              newList[index] = newList[index].copyWith(startDate: val);
                              context.read<ResumeService>().updateVolunteering(newList);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AIInputField(
                            label: 'End Date', 
                            initialValue: vol.endDate, 
                            onChanged: (val) {
                              final current = context.read<ResumeService>().currentResume?.volunteering ?? [];
                              final newList = List<Volunteering>.from(current);
                              newList[index] = newList[index].copyWith(endDate: val);
                              context.read<ResumeService>().updateVolunteering(newList);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AIInputField(
                      label: 'Description', 
                      initialValue: vol.description, 
                      maxLines: 3,
                      onChanged: (val) {
                        final current = context.read<ResumeService>().currentResume?.volunteering ?? [];
                        final newList = List<Volunteering>.from(current);
                        newList[index] = newList[index].copyWith(description: val);
                        context.read<ResumeService>().updateVolunteering(newList);
                      }, 
                      aiContext: 'description of volunteering activities at ${vol.organization} as ${vol.role}',
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
