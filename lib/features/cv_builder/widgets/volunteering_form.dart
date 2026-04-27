import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/resume_model.dart';
import '../../../core/services/resume_service.dart';

class VolunteeringForm extends StatelessWidget {
  const VolunteeringForm({super.key});

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
    final volunteeringCount = context.select<ResumeService, int>((s) => s.currentResume?.volunteering?.length ?? 0);
    final resumeService = context.read<ResumeService>();
    final volunteering = resumeService.currentResume?.volunteering ?? [];

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
                resumeService.updateVolunteering([...volunteering, newVolunteering]);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0A2540),
                side: BorderSide(color: Colors.grey.shade300),
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
                          child: _buildInputField('Role / Position', vol.role, (val) {
                            final currentVol = List<Volunteering>.from(resumeService.currentResume?.volunteering ?? []);
                            currentVol[index] = vol.copyWith(role: val);
                            resumeService.updateVolunteering(currentVol);
                          }),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () {
                            final currentVol = List<Volunteering>.from(resumeService.currentResume?.volunteering ?? []);
                            currentVol.removeAt(index);
                            resumeService.updateVolunteering(currentVol);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInputField('Organization', vol.organization, (val) {
                      final currentVol = List<Volunteering>.from(resumeService.currentResume?.volunteering ?? []);
                      currentVol[index] = vol.copyWith(organization: val);
                      resumeService.updateVolunteering(currentVol);
                    }),
                    const SizedBox(height: 20),
                    _buildInputField('Location', vol.location, (val) {
                      final currentVol = List<Volunteering>.from(resumeService.currentResume?.volunteering ?? []);
                      currentVol[index] = vol.copyWith(location: val);
                      resumeService.updateVolunteering(currentVol);
                    }),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField('Start Date', vol.startDate, (val) {
                            final currentVol = List<Volunteering>.from(resumeService.currentResume?.volunteering ?? []);
                            currentVol[index] = vol.copyWith(startDate: val);
                            resumeService.updateVolunteering(currentVol);
                          }),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInputField('End Date', vol.endDate, (val) {
                            final currentVol = List<Volunteering>.from(resumeService.currentResume?.volunteering ?? []);
                            currentVol[index] = vol.copyWith(endDate: val);
                            resumeService.updateVolunteering(currentVol);
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInputField('Description', vol.description, (val) {
                      final currentVol = List<Volunteering>.from(resumeService.currentResume?.volunteering ?? []);
                      currentVol[index] = vol.copyWith(description: val);
                      resumeService.updateVolunteering(currentVol);
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
