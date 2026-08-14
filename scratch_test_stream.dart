import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const String url = 'https://restless-bush-e2bd.byu92798.workers.dev/v1beta/models/gemini-1.5-flash:streamGenerateContent';

  print('--- Testing Custom Streaming Parser ---');
  try {
    final client = http.Client();
    final request = http.Request('POST', Uri.parse(url));
    request.headers['Content-Type'] = 'application/json';
    request.body = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text": "Write a short 3-sentence essay about the solar system."
            }
          ]
        }
      ]
    });

    final response = await client.send(request);
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
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
          try {
            final decodedText = jsonDecode('"$escapedText"') as String;
            print('Token: $decodedText');
          } catch (_) {
            print('Fallback Token: ${escapedText.replaceAll(r'\n', '\n').replaceAll(r'\"', '"')}');
          }
          
          buffer = buffer.substring(endQuoteIndex + 1);
        }
      }
    } else {
      final body = await response.stream.transform(utf8.decoder).join();
      print('Failed: $body');
    }
    client.close();
  } catch (e) {
    print('Error: $e');
  }
}
