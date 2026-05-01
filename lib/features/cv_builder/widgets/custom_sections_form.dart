import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/resume_model.dart';
import '../../../core/services/resume_service.dart';

class CustomSectionsForm extends StatelessWidget {
  const CustomSectionsForm({super.key});

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
    final resumeService = context.read<ResumeService>();
    final sections = resumeService.currentResume?.customSections ?? [];

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
          const Text(
            'ADD CUSTOM SECTIONS',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0A2540)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create unique sections for hobbies, publications, awards, etc.',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New Section'),
              onPressed: () {
                final newSection = CustomSection(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: 'New Section',
                  items: [],
                );
                resumeService.updateCustomSections([...sections, newSection]);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0A2540),
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ...sections.asMap().entries.map((entry) {
            final secIdx = entry.key;
            final section = entry.value;

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
                      children: [
                        Expanded(
                          child: _buildInputField('Section Title', section.title, (val) {
                            final current = List<CustomSection>.from(resumeService.currentResume?.customSections ?? []);
                            current[secIdx] = CustomSection(id: section.id, title: val, items: section.items);
                            resumeService.updateCustomSections(current);
                          }),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () {
                            final current = List<CustomSection>.from(resumeService.currentResume?.customSections ?? []);
                            current.removeAt(secIdx);
                            resumeService.updateCustomSections(current);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ITEMS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                        TextButton.icon(
                          icon: const Icon(Icons.add, size: 14),
                          label: const Text('Add Item', style: TextStyle(fontSize: 12)),
                          onPressed: () {
                            final current = List<CustomSection>.from(resumeService.currentResume?.customSections ?? []);
                            final updatedItems = <CustomField>[...section.items, CustomField(label: 'Label', value: '')];
                            current[secIdx] = CustomSection(id: section.id, title: section.title, items: updatedItems);
                            resumeService.updateCustomSections(current);
                          },
                        ),
                      ],
                    ),
                    ...section.items.asMap().entries.map((itemEntry) {
                      final itemIdx = itemEntry.key;
                      final item = itemEntry.value;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildInputField('Label', item.label, (val) {
                                final current = List<CustomSection>.from(resumeService.currentResume?.customSections ?? []);
                                final updatedItems = List<CustomField>.from(section.items);
                                updatedItems[itemIdx] = CustomField(label: val, value: item.value);
                                current[secIdx] = CustomSection(id: section.id, title: section.title, items: updatedItems);
                                resumeService.updateCustomSections(current);
                              }),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 3,
                              child: _buildInputField('Value', item.value, (val) {
                                final current = List<CustomSection>.from(resumeService.currentResume?.customSections ?? []);
                                final updatedItems = List<CustomField>.from(section.items);
                                updatedItems[itemIdx] = CustomField(label: item.label, value: val);
                                current[secIdx] = CustomSection(id: section.id, title: section.title, items: updatedItems);
                                resumeService.updateCustomSections(current);
                              }),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                              onPressed: () {
                                final current = List<CustomSection>.from(resumeService.currentResume?.customSections ?? []);
                                final updatedItems = List<CustomField>.from(section.items)..removeAt(itemIdx);
                                current[secIdx] = CustomSection(id: section.id, title: section.title, items: updatedItems);
                                resumeService.updateCustomSections(current);
                              },
                            ),
                          ],
                        ),
                      );
                    }),
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
