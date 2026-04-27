import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/resume_service.dart';
import '../../core/services/pdf_service.dart';
import 'widgets/cv_form_sidebar.dart';
import 'widgets/cv_preview_document.dart';

class CvBuilderScreen extends StatefulWidget {
  const CvBuilderScreen({super.key});

  @override
  State<CvBuilderScreen> createState() => _CvBuilderScreenState();
}

class _CvBuilderScreenState extends State<CvBuilderScreen> {
  bool _isEditMode = true; // For mobile toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF0A2540),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('RF', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            const Text('ResumeForge', style: TextStyle(color: Color(0xFF0A2540), fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.dark_mode_outlined, color: Color(0xFF64748B), size: 22), onPressed: () {}),
          const SizedBox(width: 8),
          const Icon(Icons.circle, color: Colors.black, size: 24), // User circle icon
          const SizedBox(width: 12),
          IconButton(icon: const Icon(Icons.logout, color: Colors.redAccent, size: 22), onPressed: () {}),
          const SizedBox(width: 16),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF0A2540),
        child: const Icon(Icons.auto_awesome, color: Colors.white),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 900;
          
          final previewToolbar = Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    CircleAvatar(radius: 3, backgroundColor: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'Continuous Print Layout',
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    final resume = context.read<ResumeService>().currentResume;
                    if (resume != null) {
                      await PdfService.generateAndDownload(resume);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A2540),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    elevation: 0,
                  ),
                  child: const Text('Download PDF', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );

          final previewPane = Container(
            color: const Color(0xFF020617), 
            child: Column(
              children: [
                previewToolbar,
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: isNarrow 
                        ? SizedBox(
                            width: constraints.maxWidth,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: const CvPreviewDocument(),
                            ),
                          )
                        : const CvPreviewDocument(),
                    ),
                  ),
                ),
              ],
            ),
          );

          // Common Tab Bar for mobile/narrow
          final tabBar = Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _isEditMode = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _isEditMode ? const Color(0xFF0A2540) : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit_note, size: 20, color: _isEditMode ? const Color(0xFF0A2540) : const Color(0xFF64748B)),
                          const SizedBox(width: 8),
                          Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _isEditMode ? const Color(0xFF0A2540) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _isEditMode = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: !_isEditMode ? const Color(0xFF0A2540) : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.visibility_outlined, size: 20, color: !_isEditMode ? const Color(0xFF0A2540) : const Color(0xFF64748B)),
                          const SizedBox(width: 8),
                          Text(
                            'Preview',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: !_isEditMode ? const Color(0xFF0A2540) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );

          if (isNarrow) {
            return Column(
              children: [
                tabBar,
                Expanded(
                  child: IndexedStack(
                    index: _isEditMode ? 0 : 1,
                    children: [
                      const CvFormSidebar(),
                      previewPane,
                    ],
                  ),
                ),
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
