import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/resume_model.dart';
import '../../../core/services/resume_service.dart';

class CertificationsForm extends StatelessWidget {
  const CertificationsForm({super.key});

  Widget _buildInputField(BuildContext context, String label, String initialValue, Function(String) onChanged) {
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
    final certifications = context.watch<ResumeService>().currentResume?.certifications ?? [];
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
              label: const Text('Add Certification'),
              onPressed: () {
                final newCertification = Certification(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: '',
                  issuer: '',
                  date: '',
                );
                context.read<ResumeService>().updateCertifications([...certifications, newCertification]);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : const Color(0xFF0A2540),
                side: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ...certifications.asMap().entries.map((entry) {
            final index = entry.key;
            final cert = entry.value;

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
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildInputField(context, 'Certification Name', cert.name, (val) {
                            final current = context.read<ResumeService>().currentResume?.certifications ?? [];
                            final newList = List<Certification>.from(current);
                            newList[index] = newList[index].copyWith(name: val);
                            context.read<ResumeService>().updateCertifications(newList);
                          }),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () {
                            final current = context.read<ResumeService>().currentResume?.certifications ?? [];
                            final newList = List<Certification>.from(current)..removeAt(index);
                            context.read<ResumeService>().updateCertifications(newList);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(context, 'Issuer', cert.issuer, (val) {
                            final current = context.read<ResumeService>().currentResume?.certifications ?? [];
                            final newList = List<Certification>.from(current);
                            newList[index] = newList[index].copyWith(issuer: val);
                            context.read<ResumeService>().updateCertifications(newList);
                          }),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInputField(context, 'Date', cert.date, (val) {
                            final current = context.read<ResumeService>().currentResume?.certifications ?? [];
                            final newList = List<Certification>.from(current);
                            newList[index] = newList[index].copyWith(date: val);
                            context.read<ResumeService>().updateCertifications(newList);
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
