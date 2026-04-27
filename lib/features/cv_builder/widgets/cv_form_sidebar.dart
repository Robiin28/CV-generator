import 'package:flutter/material.dart';

import 'personal_info_form.dart';
import 'summary_form.dart';
import 'experience_form.dart';
import 'education_form.dart';

class CvFormSidebar extends StatefulWidget {
  const CvFormSidebar({super.key});

  @override
  State<CvFormSidebar> createState() => _CvFormSidebarState();
}

class _CvFormSidebarState extends State<CvFormSidebar> {
  final List<bool> _isOpen = [true, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAFC), // Surface Color
      child: ListView(
        padding: const EdgeInsets.all(32.0),
        children: [
          const Text(
            'Edit Details',
            style: TextStyle(
              fontSize: 28, 
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A), // Charcoal
            ),
          ),
          const SizedBox(height: 24),
          
          ExpansionPanelList(
            elevation: 1,
            expandedHeaderPadding: EdgeInsets.zero,
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _isOpen[index] = isExpanded;
              });
            },
            children: [
              ExpansionPanel(
                headerBuilder: (context, isExpanded) => const ListTile(
                  title: Text('Personal Information', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  leading: Icon(Icons.person, color: Color(0xFF3B82F6)),
                ),
                body: const PersonalInfoForm(),
                isExpanded: _isOpen[0],
                canTapOnHeader: true,
              ),

              ExpansionPanel(
                headerBuilder: (context, isExpanded) => const ListTile(
                  title: Text('Professional Summary', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  leading: Icon(Icons.description, color: Color(0xFF3B82F6)),
                ),
                body: const SummaryForm(),
                isExpanded: _isOpen[1],
                canTapOnHeader: true,
              ),

              ExpansionPanel(
                headerBuilder: (context, isExpanded) => const ListTile(
                  title: Text('Work Experience', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  leading: Icon(Icons.work, color: Color(0xFF3B82F6)),
                ),
                body: const ExperienceForm(),
                isExpanded: _isOpen[2],
                canTapOnHeader: true,
              ),

              ExpansionPanel(
                headerBuilder: (context, isExpanded) => const ListTile(
                  title: Text('Education', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  leading: Icon(Icons.school, color: Color(0xFF3B82F6)),
                ),
                body: const EducationForm(),
                isExpanded: _isOpen[3],
                canTapOnHeader: true,
              ),
            ],
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
