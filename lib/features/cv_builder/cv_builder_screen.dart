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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.auto_awesome),
        label: const Text('AI Assistant'),
        backgroundColor: const Color(0xFF0A2540),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 900;
          
          final previewPane = Container(
            color: const Color(0xFF020617), 
            child: Column(
              children: [
                // Preview Toolbar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    border: Border(bottom: BorderSide(color: Colors.white.withAlpha(20))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          CircleAvatar(radius: 4, backgroundColor: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            'Continuous Print Layout',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.download, size: 18),
                        label: const Text('Download PDF'),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A2540),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: SingleChildScrollView(
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
                ),
              ],
            ),
          );

          if (isNarrow) {
            // Mobile layout
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 450,
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
              const SizedBox(
                width: 500, 
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
