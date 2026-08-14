import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/resume_service.dart';
import '../../../core/services/gemini_service.dart';

class AIEnhancerDialog extends StatefulWidget {
  final String initialText;
  final String context;

  const AIEnhancerDialog({
    super.key,
    required this.initialText,
    required this.context,
  });

  @override
  State<AIEnhancerDialog> createState() => _AIEnhancerDialogState();
}

class _AIEnhancerDialogState extends State<AIEnhancerDialog> {
  final GeminiService _geminiService = GeminiService();
  final TextEditingController _instructionController = TextEditingController();
  
  bool _isLoading = false;
  List<String> _options = [];
  int _selectedIndex = 0;
  String? _errorMessage;

  // History of generated option-sets
  final List<List<String>> _history = [];
  int _historyIndex = -1;

  @override
  void initState() {
    super.initState();
    _generateOptions();
  }

  @override
  void dispose() {
    _instructionController.dispose();
    super.dispose();
  }

  Future<void> _generateOptions([String? instruction]) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final resumeService = context.read<ResumeService>();
      final resume = resumeService.currentResume;
      final targetTitle = resume?.targetJobTitle;
      final targetDescription = resume?.targetJobDescription;

      final textToEnhance = _options.isNotEmpty && _selectedIndex < _options.length
          ? _options[_selectedIndex]
          : widget.initialText;

      final results = await _geminiService.generateEnhancementOptions(
        text: textToEnhance,
        context: widget.context,
        instruction: instruction,
        targetTitle: targetTitle,
        targetDescription: targetDescription,
      );

      setState(() {
        _options = results;
        _selectedIndex = 0;
        
        // Add to history
        if (_historyIndex < _history.length - 1) {
          _history.removeRange(_historyIndex + 1, _history.length);
        }
        _history.add(List<String>.from(results));
        _historyIndex = _history.length - 1;
        
        if (instruction != null) {
          _instructionController.clear();
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to generate options: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _undo() {
    if (_historyIndex > 0) {
      setState(() {
        _historyIndex--;
        _options = List<String>.from(_history[_historyIndex]);
        _selectedIndex = 0;
      });
    }
  }

  void _redo() {
    if (_historyIndex < _history.length - 1) {
      setState(() {
        _historyIndex++;
        _options = List<String>.from(_history[_historyIndex]);
        _selectedIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 800;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      child: Container(
        width: isLargeScreen ? size.width * 0.75 : size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: size.height * 0.85,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.blueAccent, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AI Copilot Editor',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Context: ${widget.context}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white54 : const Color(0xFF64748B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 24),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: isLargeScreen
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 4, child: _buildLeftPanel(isDark)),
                          const SizedBox(width: 24),
                          Expanded(flex: 5, child: _buildRightPanel(isDark)),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLeftPanel(isDark),
                          const SizedBox(height: 24),
                          _buildRightPanel(isDark),
                        ],
                      ),
              ),
            ),
            
            const Divider(height: 24),
            
            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // History controls
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.undo),
                      tooltip: 'Undo last change',
                      onPressed: _historyIndex > 0 ? _undo : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.redo),
                      tooltip: 'Redo last change',
                      onPressed: _historyIndex < _history.length - 1 ? _redo : null,
                    ),
                    if (_history.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Step ${_historyIndex + 1} of ${_history.length}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                        ),
                      ),
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _options.isNotEmpty && !_isLoading
                          ? () => Navigator.pop(context, _options[_selectedIndex])
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Colors.blueAccent : const Color(0xFF0A2540),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: const Text('Accept Selected'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftPanel(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ORIGINAL TEXT',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white54 : const Color(0xFF64748B),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
            border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.initialText.trim().isEmpty ? '(Empty text)' : widget.initialText,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
              height: 1.4,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'TELL AI WHAT TO ADJUST / ADD',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white54 : const Color(0xFF64748B),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _instructionController,
          maxLines: 3,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: 'e.g. "make it sound more senior", "add focus on mobile app development using Flutter", "shorten it to one punchy line"',
            hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.grey.shade400, fontSize: 13),
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
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _isLoading
                ? null
                : () => _generateOptions(_instructionController.text),
            icon: const Icon(Icons.settings_suggest, size: 18),
            label: const Text('Refine with AI'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              foregroundColor: isDark ? Colors.blueAccent : const Color(0xFF0A2540),
              side: BorderSide(color: isDark ? Colors.blueAccent.withOpacity(0.4) : const Color(0xFF0A2540)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRightPanel(bool isDark) {
    if (_isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(strokeWidth: 3),
              const SizedBox(height: 16),
              Text(
                'AI Copilot is composing 3 options...',
                style: TextStyle(
                  color: isDark ? Colors.white60 : Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent, fontSize: 13),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _generateOptions(_instructionController.text),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_options.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60.0),
          child: Text('No options generated yet. Try refining.'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CHOOSE AN OPTION TO ACCEPT',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white54 : const Color(0xFF64748B),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        ...List.generate(_options.length, (index) {
          final option = _options[index];
          final isSelected = _selectedIndex == index;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? Colors.blueAccent.withOpacity(0.08) : Colors.blue.withOpacity(0.04))
                      : (isDark ? const Color(0xFF1E293B) : Colors.white),
                  border: Border.all(
                    color: isSelected
                        ? Colors.blueAccent
                        : (isDark ? Colors.white10 : Colors.grey.shade200),
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? Colors.blueAccent : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? Colors.blueAccent : (isDark ? Colors.white24 : Colors.grey.shade400),
                          width: 1.5,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, size: 12, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                          color: isSelected
                              ? (isDark ? Colors.white : Colors.blue.shade900)
                              : (isDark ? Colors.white70 : Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
