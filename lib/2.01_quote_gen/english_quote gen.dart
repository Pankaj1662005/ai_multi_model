import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QuoteGeneratorScreen extends StatefulWidget {
  const QuoteGeneratorScreen({super.key});

  @override
  State<QuoteGeneratorScreen> createState() => _QuoteGeneratorScreenState();
}

class _QuoteGeneratorScreenState extends State<QuoteGeneratorScreen> {
  bool isLoading = false;
  String quoteResult = '';

  Future<void> generateQuote() async {
    setState(() {
      isLoading = true;
      quoteResult = '';
    });

    final urlPost = Uri.parse(
        'https://pankaj2005-markov-quote-generator.hf.space/gradio_api/call/predict');

    final requestBody = {
      "data": [],
    };

    try {
      // POST request to get event_id
      final postResponse = await http.post(
        urlPost,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (postResponse.statusCode == 200) {
        final eventId = json.decode(postResponse.body)['event_id'];
        final getUrl = Uri.parse(
            'https://pankaj2005-markov-quote-generator.hf.space/gradio_api/call/predict/$eventId');

        // GET request using event_id
        final streamedResponse =
        await http.Client().send(http.Request('GET', getUrl));

        String buffer = '';
        await for (final chunk in streamedResponse.stream.transform(utf8.decoder)) {
          buffer += chunk;
          if (buffer.contains('data: ')) {
            final lines = buffer.split('\n');
            for (final line in lines) {
              if (line.startsWith('data: ') && !line.contains('[DONE]')) {
                final jsonData = json.decode(line.substring(6));
                final prediction = jsonData[0];
                setState(() {
                  quoteResult = prediction.toString();
                  print("Quote: $quoteResult");
                });
                break;
              }
            }
            break;
          }
        }
      } else {
        setState(() {
          quoteResult = 'Error: ${postResponse.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        quoteResult = 'Error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('English Quote Generator'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: isLoading
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Icon(Icons.format_quote),
                label: Text(isLoading ? 'Generating...' : 'Generate Quote'),
                onPressed: isLoading ? null : generateQuote,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (quoteResult.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🌟 Generated Quote:',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '"$quoteResult"',
                      style: const TextStyle(
                          fontSize: 18, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
