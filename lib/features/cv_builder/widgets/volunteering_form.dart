import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/resume_model.dart';
import '../../../core/services/resume_service.dart';

class VolunteeringForm extends StatelessWidget {
  const VolunteeringForm({super.key});

  Widget _buildInputField(BuildContext context, String label, String initialValue, Function(String) onChanged, {int maxLines = 1}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white54 : const Color(0xFF64748B),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          maxLines: maxLines,
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
                          child: _buildInputField(context, 'Role / Position', vol.role, (val) {
                            final current = context.read<ResumeService>().currentResume?.volunteering ?? [];
                            final newList = List<Volunteering>.from(current);
                            newList[index] = newList[index].copyWith(role: val);
                            context.read<ResumeService>().updateVolunteering(newList);
                          }),
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
                    _buildInputField(context, 'Organization', vol.organization, (val) {
                      final current = context.read<ResumeService>().currentResume?.volunteering ?? [];
                      final newList = List<Volunteering>.from(current);
                      newList[index] = newList[index].copyWith(organization: val);
                      context.read<ResumeService>().updateVolunteering(newList);
                    }),
                    const SizedBox(height: 20),
                    _buildInputField(context, 'Location', vol.location, (val) {
                      final current = context.read<ResumeService>().currentResume?.volunteering ?? [];
                      final newList = List<Volunteering>.from(current);
                      newList[index] = newList[index].copyWith(location: val);
                      context.read<ResumeService>().updateVolunteering(newList);
                    }),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(context, 'Start Date', vol.startDate, (val) {
                            final current = context.read<ResumeService>().currentResume?.volunteering ?? [];
                            final newList = List<Volunteering>.from(current);
                            newList[index] = newList[index].copyWith(startDate: val);
                            context.read<ResumeService>().updateVolunteering(newList);
                          }),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInputField(context, 'End Date', vol.endDate, (val) {
                            final current = context.read<ResumeService>().currentResume?.volunteering ?? [];
                            final newList = List<Volunteering>.from(current);
                            newList[index] = newList[index].copyWith(endDate: val);
                            context.read<ResumeService>().updateVolunteering(newList);
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(context, 'Description', vol.description, (val) {
                      final current = context.read<ResumeService>().currentResume?.volunteering ?? [];
                      final newList = List<Volunteering>.from(current);
                      newList[index] = newList[index].copyWith(description: val);
                      context.read<ResumeService>().updateVolunteering(newList);
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
