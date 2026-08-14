import 'package:flutter/material.dart';
import 'ai_enhancer_dialog.dart';

class AIEnhancerButton extends StatefulWidget {
  final String currentText;
  final String context;
  final Function(String) onEnhanced;

  const AIEnhancerButton({
    super.key,
    required this.currentText,
    required this.context,
    required this.onEnhanced,
  });

  @override
  State<AIEnhancerButton> createState() => _AIEnhancerButtonState();
}

class _AIEnhancerButtonState extends State<AIEnhancerButton> {
  Future<void> _enhance() async {
    if (widget.currentText.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some text first to enhance.')),
      );
      return;
    }

    final String? resultText = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AIEnhancerDialog(
        initialText: widget.currentText,
        context: widget.context,
      ),
    );

    if (resultText != null && resultText.trim().isNotEmpty) {
      widget.onEnhanced(resultText);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Text updated with AI!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: _enhance,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: const Icon(Icons.auto_awesome, size: 16, color: Colors.blueAccent),
      label: const Text(
        'AI Enhance',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}

