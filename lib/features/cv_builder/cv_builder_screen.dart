import 'package:flutter/material.dart';

import 'widgets/cv_form_sidebar.dart';
import 'widgets/cv_preview_document.dart';

class CvBuilderScreen extends StatelessWidget {
  const CvBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CV Generator Pro', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0A2540), // Deep Navy
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 900;
          
          final previewPane = Container(
            color: const Color(0xFF020617), 
            child: const SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Center(
                    child: CvPreviewDocument(),
                  ),
                ),
              ),
            ),
          );

          if (isNarrow) {
            // Mobile layout
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 400,
                  child: CvFormSidebar(),
                ),
                const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                Expanded(child: previewPane),
              ],
            );
          }

          // Desktop layout
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Fixed width ensures the text NEVER gets squashed vertically
              const SizedBox(
                width: 450, 
                child: CvFormSidebar(),
              ),
              
              const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE2E8F0)),

              Expanded(child: previewPane),
            ],
          );
        },
      ),
    );
  }
}
