import 'package:flutter/material.dart';
import 'ai_enhancer_button.dart';

class AIInputField extends StatefulWidget {
  final String label;
  final String initialValue;
  final Function(String) onChanged;
  final int maxLines;
  final String? aiContext;

  const AIInputField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.maxLines = 1,
    this.aiContext,
  });

  @override
  State<AIInputField> createState() => _AIInputFieldState();
}

class _AIInputFieldState extends State<AIInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(AIInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.label.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white54 : const Color(0xFF64748B),
                  letterSpacing: 1.0,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.aiContext != null)
              AIEnhancerButton(
                currentText: _controller.text,
                context: widget.aiContext!,
                onEnhanced: (val) {
                  setState(() {
                    _controller.text = val;
                  });
                  widget.onChanged(val);
                },
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _controller,
          maxLines: widget.maxLines,
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
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
