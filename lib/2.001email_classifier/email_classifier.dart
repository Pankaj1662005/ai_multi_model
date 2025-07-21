import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../0main_themes/light_mode.dart'; // adjust the import if needed

class EmailClassifierScreen extends StatefulWidget {
  const EmailClassifierScreen({super.key});

  @override
  State<EmailClassifierScreen> createState() => _EmailClassifierScreenState();
}

class _EmailClassifierScreenState extends State<EmailClassifierScreen> {
  final TextEditingController _emailController = TextEditingController();
  String predictionResult = '';
  bool isLoading = false;

  Future<void> classifyEmail() async {
    final emailText = _emailController.text.trim();
    if (emailText.isEmpty) return;

    setState(() {
      isLoading = true;
      predictionResult = '';
    });

    final urlPost = Uri.parse(
      'https://pankaj2005-email-spam-detection.hf.space/gradio_api/call/predict',
    );

    final requestBody = {
      "data": [emailText]
    };

    try {
      final postResponse = await http.post(
        urlPost,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (postResponse.statusCode == 200) {
        final eventId = json.decode(postResponse.body)['event_id'];
        final getUrl = Uri.parse(
          'https://pankaj2005-email-spam-detection.hf.space/gradio_api/call/predict/$eventId',
        );

        final streamedResponse =
        await http.Client().send(http.Request('GET', getUrl));

        String buffer = '';
        await for (final chunk
        in streamedResponse.stream.transform(utf8.decoder)) {
          buffer += chunk;
          if (buffer.contains('data: ')) {
            final lines = buffer.split('\n');
            for (final line in lines) {
              if (line.startsWith('data: ') && !line.contains('[DONE]')) {
                final jsonData = json.decode(line.substring(6));
                final predictionlabel = jsonData[0]['label'];
                setState(() {
                  predictionResult = predictionlabel.toString();
                });
                break;
              }
            }
            break;
          }
        }
      } else {
        setState(() {
          predictionResult = '❌ Error: ${postResponse.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        predictionResult = '❌ Error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    print(predictionResult);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.primary.withOpacity(0.4)),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.textSecondary,
        elevation: 2,
        title: const Text(
          'Email Spam Classifier',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _emailController,
                maxLines: 12,
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Paste your email Subject here...',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  border: inputBorder,
                  enabledBorder: inputBorder,
                  focusedBorder: inputBorder.copyWith(
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: classifyEmail,
                icon: const Icon(Icons.search),
                label: const Text('Check'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 14.0),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (isLoading)
                const Center(child: CircularProgressIndicator()),
              if (!isLoading && predictionResult.isNotEmpty)
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: predictionResult == "🚫 Spam"
                      ? Colors.red.shade100
                      : Colors.green.shade100,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    child: Row(
                      children: [
                        Icon(
                          predictionResult == "🚫 Spam"
                              ? Icons.warning_amber
                              : Icons.check_circle,
                          color: predictionResult == "🚫 Spam"
                              ? Colors.red
                              : Colors.green,
                          size: 30,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            "Prediction: $predictionResult",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary.withOpacity(0.85),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

  }
}
