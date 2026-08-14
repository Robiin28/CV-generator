import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const String baseUrl = 'https://restless-bush-e2bd.byu92798.workers.dev';

  print('--- Starting Gemini Connection Test ---');
  print('Target URL: $baseUrl');

  try {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text": "Hello Gemini! Say 'Connection Successful' if you can read this."
              }
            ]
          }
        ]
      }),
    );

    print('Status Code: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      // Handle different response formats
      String aiResponse;
      if (data['candidates'] != null && data['candidates'][0]['content'] != null) {
        aiResponse = data['candidates'][0]['content']['parts'][0]['text'];
      } else if (data['response'] != null) {
        aiResponse = data['response'];
      } else {
        aiResponse = response.body;
      }
      
      print('AI Response: $aiResponse');
      print('✅ SUCCESS! Your proxy is working.');
    } else {
      print('❌ FAILED with status: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }
  } catch (e) {
    print('❌ ERROR: $e');
  }
}