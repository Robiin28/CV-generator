import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../../core/services/gemini_service.dart';
import '../../core/services/resume_service.dart';

class AIAssistantBody extends StatefulWidget {
  final bool isDark;

  const AIAssistantBody({super.key, required this.isDark});

  @override
  State<AIAssistantBody> createState() => _AIAssistantBodyState();
}

class _AIAssistantBodyState extends State<AIAssistantBody> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GeminiService _geminiService = GeminiService();
  
  bool _isLoading = false;
  String? _typewriterText;

  void _scrollToBottom({bool force = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final position = _scrollController.position;
        final maxScroll = position.maxScrollExtent;
        final currentScroll = position.pixels;

        if (force) {
          _scrollController.animateTo(
            maxScroll,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        } else if (maxScroll - currentScroll < 150) {
          _scrollController.jumpTo(maxScroll);
        }
      }
    });
  }

  Future<void> _sendMessage([String? text]) async {
    final messageText = text ?? _controller.text.trim();
    if (messageText.isEmpty) return;

    final resumeService = context.read<ResumeService>();

    setState(() {
      _isLoading = true;
      _typewriterText = null;
      if (text == null) _controller.clear();
    });
    
    // Persist user message immediately in service
    resumeService.addAiChatMessage(true, messageText);
    _scrollToBottom(force: true);

    try {
      final resume = resumeService.currentResume;
      final contextPrompt = resume != null 
        ? "User's Current CV Data: ${resume.toJson()}\n\n" 
        : "";
      
      // Feed full continuous chat history to the Gemini model
      final history = resumeService.aiChatHistory
          .map((m) => "${m['isUser'] ? 'User' : 'Assistant'}: ${m['text']}")
          .join("\n");
        
      final stream = _geminiService.generateStream(
        "You are a helpful Career Coach. Your goal is to GUIDE the user collaboratively to build an ATS-friendly CV tailored for their target jobs. \n\n"
        "RULES:\n"
        "1. Remember the context of our previous conversation and full history.\n"
        "2. Focus on the user's current request.\n"
        "3. STRUCTURE & FORMATTING: Use clean, professional markdown formatting. Use bolding (**text**) to highlight key skills, metrics, or sections. Use bullet points (- item) for lists. Use headers (### heading) to separate major sections. Do not use # or ## headers. Keep paragraphs short and space them with double newlines. This ensures a clean, conversational UI.\n"
        "4. INTERACTIVE DISCOVERY: Instead of blindly rewriting sections, if the user wants to tailor their CV for a job requirement they seem to lack (e.g. they want an Angular job but have no Angular projects), ASK relevant clarifying/probing questions. For example: ask if they have experience with related frameworks (like React), or if they did similar tasks in another project. Guide them in drawing out these details first.\n"
        "5. ATS-FRIENDLY & COLLABORATIVE: Walk them through the improvement process step-by-step. Provide guidance, and present structured updates only when you have enough context.\n"
        "6. INTERACTIVE CV EDITS: If you are suggesting a specific revision, rewrite, or correction to a section of their CV (specifically the 'summary', an item in 'experience', or an item in 'project'), you MUST append a structured update suggestion block at the very end of your response inside a markdown code block starting with ```cv_update and ending with ```. The contents inside must be a valid JSON object matching the following structure:\n"
        "   {\n"
        "     \"section\": \"summary\" | \"experience\" | \"project\",\n"
        "     \"id\": \"matching-id-from-user-cv\" (only required if section is experience or project - look at the current CV Data JSON for the matching ID),\n"
        "     \"original\": \"the exact text being replaced\",\n"
        "     \"suggested\": \"your new suggested text\"\n"
        "   }\n"
        "   Do not write any comments inside the JSON or markdown. It must be valid JSON.\n\n"
        "$contextPrompt"
        "Conversation History:\n$history\n\n"
        "User's Latest Message: $messageText"
      );

      String fullResponse = '';
      bool firstChunk = true;

      await for (final token in stream) {
        if (firstChunk) {
          setState(() {
            _isLoading = false;
            _typewriterText = '';
          });
          firstChunk = false;
        }
        fullResponse += token;
        setState(() {
          _typewriterText = fullResponse;
        });
        _scrollToBottom(force: false);
      }

      if (firstChunk) {
        setState(() {
          _isLoading = false;
        });
      } else {
        // Once finished typing, save helper message to service cache
        resumeService.addAiChatMessage(false, fullResponse);
        setState(() {
          _typewriterText = null;
        });
      }
    } catch (e) {
      resumeService.addAiChatMessage(false, 'Sorry, I encountered an error: $e');
      setState(() {
        _isLoading = false;
        _typewriterText = null;
      });
    }
    
    _scrollToBottom(force: false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final resumeService = context.watch<ResumeService>();

    if (resumeService.initialChatPrompt != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _controller.text = resumeService.initialChatPrompt!;
        });
        resumeService.setInitialChatPrompt(null);
      });
    }
    
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.auto_awesome, color: Colors.blueAccent, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ResumeForge AI',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Always here to help',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white54 : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Chat History
                ...resumeService.aiChatHistory.asMap().entries.map((entry) {
                  final index = entry.key;
                  final m = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: _ChatMessage(
                      isUser: m['isUser'],
                      isDark: isDark,
                      message: m['text'],
                      messageIndex: index,
                      isApplied: m['applied'] == true,
                      onRefine: (sectionTitle) {
                        _controller.text = 'Can you refine the suggested $sectionTitle? Let\'s make it ';
                        _controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: _controller.text.length),
                        );
                      },
                    ),
                  );
                }),
                
                if (_typewriterText != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: _ChatMessage(
                      isUser: false,
                      isDark: isDark,
                      message: _typewriterText!,
                    ),
                  ),

                if (_isLoading)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: _ChatMessage(
                      isUser: false,
                      isDark: isDark,
                      message: '',
                      isLoading: true,
                    ),
                  ),
                
                // Quick Actions (Only show at start or when not loading)
                if (!_isLoading && _typewriterText == null) ...[
                  Text(
                    'SUGGESTED ACTIONS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: isDark ? Colors.white38 : Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _ActionChip(
                        icon: Icons.edit_note, 
                        label: 'Rewrite Summary', 
                        isDark: isDark,
                        onTap: () => _sendMessage('Can you help me rewrite my professional summary?'),
                      ),
                      _ActionChip(
                        icon: Icons.spellcheck, 
                        label: 'Check Spelling', 
                        isDark: isDark,
                        onTap: () => _sendMessage('Could you check the spelling in my CV?'),
                      ),
                      _ActionChip(
                        icon: Icons.work_outline, 
                        label: 'Optimize Experience', 
                        isDark: isDark,
                        onTap: () => _sendMessage('How can I optimize my work experience descriptions?'),
                      ),
                      _ActionChip(
                        icon: Icons.lightbulb_outline, 
                        label: 'Suggest Keywords', 
                        isDark: isDark,
                        onTap: () => _sendMessage('What keywords should I add to my resume?'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        
        // Input Area
        Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Ask me anything...',
                      hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey.shade400),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(_isLoading ? Icons.hourglass_empty : Icons.send, color: Colors.white, size: 20),
                  onPressed: _isLoading ? null : () => _sendMessage(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChatMessage extends StatelessWidget {
  final bool isUser;
  final bool isDark;
  final String message;
  final int? messageIndex;
  final bool isApplied;
  final Function(String)? onRefine;
  final bool isLoading;

  const _ChatMessage({
    required this.isUser, 
    required this.isDark, 
    required this.message,
    this.messageIndex,
    this.isApplied = false,
    this.onRefine,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    String cleanMessage = message;
    Map<String, dynamic>? updateSuggestion;

    if (!isUser && message.contains('```cv_update')) {
      try {
        final parts = message.split('```cv_update');
        cleanMessage = parts[0].trim();
        
        final blockAndAfter = parts[1].split('```');
        final jsonText = blockAndAfter[0].trim();
        
        updateSuggestion = jsonDecode(jsonText);
      } catch (e) {
        // Fallback to displaying the raw message if parsing fails
      }
    }

    if (isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: RichMarkdownText(
              text: cleanMessage,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ),
      );
    }

    // AI Message Row (Includes AI logo/avatar)
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Forge AI Logo Avatar
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withValues(alpha: 0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.bolt,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isLoading)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(20),
                    ),
                    border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Lottie.network(
                    'https://assets2.lottiefiles.com/packages/lf20_usmfx6bp.json',
                    width: 48,
                    height: 48,
                    fit: BoxFit.contain,
                  ),
                )
              else ...[
                // Main AI Text bubble
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(20),
                    ),
                      border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: RichMarkdownText(
                      text: cleanMessage,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                if (updateSuggestion != null && messageIndex != null) ...[
                  const SizedBox(height: 12),
                  // Render the side-by-side comparison update card
                  _buildComparisonCard(context, updateSuggestion, isDark),
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonCard(BuildContext context, Map<String, dynamic> updateSuggestion, bool isDark) {
    final section = updateSuggestion['section']?.toString() ?? 'summary';
    final id = updateSuggestion['id']?.toString();
    final original = updateSuggestion['original']?.toString() ?? '';
    final suggested = updateSuggestion['suggested']?.toString() ?? '';
    
    final s = section.toLowerCase().trim();
    final isSummary = s == 'summary';
    final isExperience = s == 'experience' || s == 'experiences' || s == 'work_experience' || s == 'work_experiences' || s.contains('experience');
    final isProject = s == 'project' || s == 'projects' || s.contains('project');
    final isSkill = s == 'skills' || s == 'skill' || s.contains('skill');
    final isEducation = s == 'education' || s == 'educations' || s.contains('education');

    final sectionTitle = isSummary
        ? 'Professional Summary'
        : isExperience
            ? 'Work Experience'
            : isProject
                ? 'Project Details'
                : isSkill
                    ? 'Skills'
                    : isEducation
                        ? 'Education'
                        : section;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E294B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isApplied == true
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.blueAccent.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isApplied == true ? Icons.check_circle : Icons.auto_awesome,
                color: isApplied == true ? Colors.green : Colors.blueAccent,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Suggested Update: $sectionTitle',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (original.isNotEmpty) ...[
            Text(
              'CURRENT',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white38 : Colors.grey.shade500,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A).withValues(alpha: 0.4) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
              ),
              child: Text(
                original,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.grey.shade600,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text(
            'SUGGESTED',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark 
                  ? Colors.blueAccent.withValues(alpha: 0.08) 
                  : Colors.blueAccent.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.2)),
            ),
            child: Text(
              suggested,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : const Color(0xFF1E3A8A),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (isApplied == true)
            const Row(
              children: [
                Icon(Icons.check, color: Colors.green, size: 18),
                SizedBox(width: 8),
                Text(
                  'Applied to CV',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<ResumeService>().applyAiSuggestion(
                          messageIndex!,
                          section,
                          id,
                          suggested,
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.check, size: 14),
                  label: const Text(
                    'Accept & Apply',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                if (onRefine != null)
                  OutlinedButton.icon(
                    onPressed: () => onRefine!(sectionTitle),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark ? Colors.white70 : Colors.grey.shade700,
                      side: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 14),
                    label: const Text(
                      'Refine',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const _ActionChip({required this.icon, required this.label, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isDark ? Colors.white70 : const Color(0xFF0A2540)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0A2540),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BouncingDotsIndicator extends StatefulWidget {
  const BouncingDotsIndicator({super.key});

  @override
  State<BouncingDotsIndicator> createState() => _BouncingDotsIndicatorState();
}

class _BouncingDotsIndicatorState extends State<BouncingDotsIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delay = index * 0.2;
            final animValue = (sin((_controller.value * 2 * pi) - (delay * 2 * pi)) + 1) / 2;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Transform.translate(
                offset: Offset(0, -6 * animValue),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.blueAccent.withValues(alpha: 0.7) : const Color(0xFF0A2540).withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class RichMarkdownText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const RichMarkdownText({super.key, required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    final List<Widget> blocks = [];
    final lines = text.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) {
        blocks.add(const SizedBox(height: 8));
        continue;
      }

      // Check for headings
      if (line.startsWith('### ')) {
        blocks.add(Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 4),
          child: Text(
            line.substring(4),
            style: style.copyWith(
              fontSize: (style.fontSize ?? 14) + 2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
      } else if (line.startsWith('## ')) {
        blocks.add(Padding(
          padding: const EdgeInsets.only(top: 14, bottom: 6),
          child: Text(
            line.substring(3),
            style: style.copyWith(
              fontSize: (style.fontSize ?? 14) + 4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
      } else if (line.startsWith('# ')) {
        blocks.add(Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 8),
          child: Text(
            line.substring(2),
            style: style.copyWith(
              fontSize: (style.fontSize ?? 14) + 6,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
      }
      // Check for bullet lists (starting with *, -, or •)
      else if (line.startsWith('* ') || line.startsWith('- ') || line.startsWith('• ')) {
        final content = line.substring(2);
        blocks.add(Padding(
          padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• ', style: style.copyWith(fontWeight: FontWeight.bold, color: style.color?.withOpacity(0.7))),
              const SizedBox(width: 6),
              Expanded(
                child: RichText(
                  text: _parseInlineStyles(content, style),
                ),
              ),
            ],
          ),
        ));
      }
      // Standard paragraph line
      else {
        blocks.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: RichText(
            text: _parseInlineStyles(line, style),
          ),
        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks,
    );
  }

  // Parses inline styles like **bold**
  TextSpan _parseInlineStyles(String line, TextStyle defaultStyle) {
    final List<TextSpan> spans = [];
    final RegExp exp = RegExp(r'\*\*(.*?)\*\*');
    int start = 0;

    for (final match in exp.allMatches(line)) {
      if (match.start > start) {
        spans.add(TextSpan(
          text: line.substring(start, match.start),
          style: defaultStyle,
        ));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: defaultStyle.copyWith(fontWeight: FontWeight.bold),
      ));
      start = match.end;
    }

    if (start < line.length) {
      spans.add(TextSpan(
        text: line.substring(start),
        style: defaultStyle,
      ));
    }

    return TextSpan(children: spans);
  }
}
