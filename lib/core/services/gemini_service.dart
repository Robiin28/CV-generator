import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  // Your Cloudflare Worker URL
  static const String _baseUrl = 'https://restless-bush-e2bd.byu92798.workers.dev';

  /// Generic text enhancer based on context
  Future<String> enhanceText(String text, String context) async {
    if (text.isEmpty) return text;
    
    final url = Uri.parse(_baseUrl);
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text": "COMMAND: Professionally enhance the provided text for a CV. \nRULES: \n1. Maintain the SAME LENGTH and level of detail as the original text.\n2. Do NOT summarize. Do NOT omit specific accomplishments or facts.\n3. Fix grammar and improve professional impact.\n4. ONLY return the enhanced text. No chat.\n\nContext: $context\nOriginal Text: $text"
              }
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.3,
          "maxOutputTokens": 8192,
        }
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['candidates'] != null && data['candidates'].isNotEmpty) {
        return data['candidates'][0]['content']['parts'][0]['text'].trim();
      } else if (data['response'] != null) {
        return data['response'].trim();
      }
      return response.body;
    } else {
      throw Exception('AI Error: ${response.statusCode}');
    }
  }

  /// Generates a professional summary based on the provided text
  Future<String> generateSummary(String currentInfo) async {
    final url = Uri.parse(_baseUrl);
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text": "OUTPUT ONLY THE SUMMARY. NO INTRO. NO OUTRO. NO CHAT.\n\nCreate a 3-sentence professional summary for a CV based on this info: $currentInfo"
              }
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.3,
          "maxOutputTokens": 8192,
        }
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['candidates'] != null && data['candidates'].isNotEmpty) {
        return data['candidates'][0]['content']['parts'][0]['text'].trim();
      } else if (data['response'] != null) {
        return data['response'].trim();
      }
      return response.body;
    } else {
      throw Exception('AI Error: ${response.statusCode}');
    }
  }

  /// General purpose generation with retry
  Future<String> generate(String prompt) async {
    int attempts = 0;
    while (attempts < 3) {
      try {
        final url = Uri.parse(_baseUrl);
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "contents": [{"parts": [{"text": prompt}]}],
            "generationConfig": {"temperature": 0.7, "maxOutputTokens": 8192}
          }),
        ).timeout(const Duration(seconds: 30));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['candidates'] != null && data['candidates'].isNotEmpty) {
            return data['candidates'][0]['content']['parts'][0]['text'].trim();
          }
          return response.body;
        }
      } catch (e) {
        if (attempts == 2) rethrow;
      }
      attempts++;
      await Future.delayed(Duration(milliseconds: 500 * attempts));
    }
    throw Exception('Failed after 3 attempts');
  }

  /// Streams text response in real-time
  Stream<String> generateStream(String prompt) async* {
    // Append the streaming path. The Cloudflare Worker proxy will forward this path.
    final url = Uri.parse('$_baseUrl/v1beta/models/gemini-1.5-flash:streamGenerateContent');
    
    final request = http.Request('POST', url);
    request.headers['Content-Type'] = 'application/json';
    request.body = jsonEncode({
      "contents": [{"parts": [{"text": prompt}]}],
      "generationConfig": {"temperature": 0.7, "maxOutputTokens": 8192}
    });

    final client = http.Client();
    try {
      final response = await client.send(request).timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) {
        throw Exception('AI Error: ${response.statusCode}');
      }

      String buffer = '';
      await for (final chunk in response.stream.transform(utf8.decoder)) {
        buffer += chunk;
        
        while (true) {
          final textIndex = buffer.indexOf('"text": "');
          if (textIndex == -1) break;
          
          final startQuoteIndex = textIndex + 9;
          
          int endQuoteIndex = -1;
          for (int i = startQuoteIndex; i < buffer.length; i++) {
            if (buffer[i] == '"' && buffer[i - 1] != '\\') {
              endQuoteIndex = i;
              break;
            }
          }
          
          if (endQuoteIndex == -1) {
            break;
          }
          
          final escapedText = buffer.substring(startQuoteIndex, endQuoteIndex);
          String decodedText = '';
          try {
            decodedText = jsonDecode('"$escapedText"') as String;
          } catch (_) {
            decodedText = escapedText.replaceAll(r'\n', '\n').replaceAll(r'\"', '"');
          }
          
          yield decodedText;
          buffer = buffer.substring(endQuoteIndex + 1);
        }
      }
    } finally {
      client.close();
    }
  }

  /// Generates exactly 3 distinct professional enhancements for the text, optionally using a custom instruction and target job details
  Future<List<String>> generateEnhancementOptions({
    required String text,
    required String context,
    String? instruction,
    String? targetTitle,
    String? targetDescription,
  }) async {
    if (text.isEmpty) return [text, text, text];
    
    final url = Uri.parse(_baseUrl);
    
    final instructionPart = instruction != null && instruction.trim().isNotEmpty
        ? "Apply the following user instruction to refine the content: $instruction"
        : "Improve grammar, flow, professional vocabulary, and clarity while maintaining all original details and accomplishments.";

    String targetJobPart = '';
    if (targetTitle != null && targetTitle.trim().isNotEmpty) {
      targetJobPart = "\nTarget Job Role/Title: $targetTitle\n";
      if (targetDescription != null && targetDescription.trim().isNotEmpty) {
        targetJobPart += "Target Job Description:\n$targetDescription\n";
      }
      targetJobPart += "IMPORTANT: Tailor the enhancements to align with and highlight matching skills/achievements for this target job post.\n";
    }

    final promptText = """
You are an expert professional resume and CV editor.
Context: This text belongs to a CV section for: $context
$targetJobPart
Original Text:
$text

Task:
Generate exactly 3 distinct, high-quality, professional variations/enhancements of the original text.

Rules:
1. Vary the tone, structure, or length slightly across the 3 options (e.g. Option 1: strong and action-oriented; Option 2: concise and direct; Option 3: detailed and comprehensive).
2. $instructionPart
3. Do NOT add placeholder text (like "[Year]" or "[Company]") unless they were already present.
4. Output MUST be a valid JSON array of exactly 3 strings.
5. Do NOT wrap the JSON in markdown formatting (do not use ```json or ```). Return ONLY the raw JSON string array.

Example response:
[
  "Enhanced version one with action verbs...",
  "Slightly different enhanced version two...",
  "Third professional version..."
]
""";

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text": promptText
              }
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.5,
          "maxOutputTokens": 8192,
        }
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = response.body;
      try {
        final data = jsonDecode(responseBody);
        String rawText = '';
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          rawText = data['candidates'][0]['content']['parts'][0]['text'].trim();
        } else if (data['response'] != null) {
          rawText = data['response'].trim();
        } else {
          rawText = responseBody;
        }

        // Clean up markdown block formatting if present
        rawText = rawText.replaceAll(RegExp(r'^```json\s*', caseSensitive: false), '');
        rawText = rawText.replaceAll(RegExp(r'^```\s*'), '');
        rawText = rawText.replaceAll(RegExp(r'\s*```$'), '');
        rawText = rawText.trim();

        final parsed = jsonDecode(rawText);
        if (parsed is List) {
          return parsed.map((item) => item.toString()).toList();
        }
      } catch (e) {
        print('Error parsing JSON from Gemini: $e. Raw response: $responseBody');
      }
      
      // Fallback
      return _fallbackTokenize(responseBody, text);
    } else {
      throw Exception('AI Error: ${response.statusCode}');
    }
  }

  List<String> _fallbackTokenize(String responseBody, String originalText) {
    try {
      final cleaned = responseBody.replaceAll(RegExp(r'<[^>]*>'), '');
      // Try parsing candidates from raw response if we didn't extract correctly
      if (cleaned.contains('candidates')) {
        final data = jsonDecode(cleaned);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final rawText = data['candidates'][0]['content']['parts'][0]['text'].trim();
          final parsed = jsonDecode(rawText.replaceAll(RegExp(r'^```json\s*|^```|\s*```$'), '').trim());
          if (parsed is List) {
            return parsed.map((item) => item.toString()).toList();
          }
        }
      }
      // Try to find numbered items (e.g. 1. text 2. text 3. text)
      final pattern = RegExp(r'(?:^\d+\.|\n\d+\.)\s*([^\n]+)');
      final matches = pattern.allMatches(cleaned).map((m) => m.group(1)!.trim()).toList();
      if (matches.length >= 3) {
        return matches.sublist(0, 3);
      }
      if (matches.isNotEmpty) {
        final List<String> list = List<String>.from(matches);
        while (list.length < 3) {
          list.add(list.first);
        }
        return list;
      }
    } catch (_) {}
    
    // Default fallback
    return [
      originalText,
      "$originalText (Alt 1)",
      "$originalText (Alt 2)"
    ];
  }

  /// Tailors an entire Resume to target a specific job title and job description.
  /// Returns a Map of updated properties containing 'summary', 'experience', 'projects', 'skills'.
  Future<Map<String, dynamic>> tailorWholeResume({
    required Map<String, dynamic> resumeJson,
    required String targetTitle,
    required String targetDescription,
  }) async {
    final url = Uri.parse(_baseUrl);

    final promptText = """
You are an expert professional CV editor and career advisor.
Your task is to tailor the user's CV to match this target position:
Target Job Title: $targetTitle
Target Job Description:
$targetDescription

Here is the current CV Data in JSON format:
${jsonEncode(resumeJson)}

Task:
Generate tailored versions of the resume's editable text sections to maximize matching and ATS score for the target job.
Specifically, rewrite:
1. The professional "summary".
2. The "description" of each experience item in the "experience" list (maintain the order and the same number of items, identifying each by its "id"). Make sure to align their accomplishments with the target job's keywords and requirements.
3. The "description" of each project item in the "projects" list (identify each by its "id").
4. The list of skills in "skills" (identify each category by its "category" and adjust the list of "skills" strings to highlight relevant competencies matching the job post).

Rules:
1. Do NOT change factual properties like: names, emails, phone, locations, company names, school names, degrees, GPAs, start/end dates, or the IDs of experiences/projects.
2. Maintain the exact same number of experience items and project items, using their matching "id".
3. Return ONLY a valid JSON object matching the output schema below. No chat, no explanation, no markdown wraps.

Output Schema:
{
  "summary": "Tailored 3-sentence summary here...",
  "experience": [
    {
      "id": "exp-id-here",
      "description": "Tailored experience description..."
    }
  ],
  "projects": [
    {
      "id": "project-id-here",
      "description": "Tailored project description..."
    }
  ],
  "skills": [
    {
      "category": "Category Name",
      "skills": ["Skill 1", "Skill 2"]
    }
  ]
}
""";

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text": promptText
              }
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.4,
          "maxOutputTokens": 8192,
        }
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = response.body;
      try {
        final data = jsonDecode(responseBody);
        String rawText = '';
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          rawText = data['candidates'][0]['content']['parts'][0]['text'].trim();
        } else if (data['response'] != null) {
          rawText = data['response'].trim();
        } else {
          rawText = responseBody;
        }

        // Clean up markdown block formatting if present
        rawText = rawText.replaceAll(RegExp(r'^```json\s*', caseSensitive: false), '');
        rawText = rawText.replaceAll(RegExp(r'^```\s*'), '');
        rawText = rawText.replaceAll(RegExp(r'\s*```$'), '');
        rawText = rawText.trim();

        return jsonDecode(rawText) as Map<String, dynamic>;
      } catch (e) {
        throw Exception('Failed to parse tailored CV JSON: $e\nRaw response: $responseBody');
      }
    } else {
      throw Exception('AI Error: ${response.statusCode}');
    }
  }
}
