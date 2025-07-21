import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScorePredictionScreen extends StatefulWidget {
  const ScorePredictionScreen({super.key});

  @override
  State<ScorePredictionScreen> createState() => _ScorePredictionScreenState();
}

class _ScorePredictionScreenState extends State<ScorePredictionScreen> {
  double economicScore = 0.5;
  double studyHours = 6;
  double sleepHours = 7;
  double attendance = 75;
  bool isLoading = false;
  String predictionResult = '';

  Future<void> predictScore() async {
    setState(() {
      isLoading = true;
      predictionResult = '';
    });

    final urlPost = Uri.parse(
      'https://pankaj2005-student-grade-predictor.hf.space/gradio_api/call/predict',
    );

    final requestBody = {
      "data": [
        economicScore.toInt(),
        studyHours.toInt(),
        sleepHours.toInt(),
        attendance.toInt(),
      ]
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
            'https://pankaj2005-student-grade-predictor.hf.space/gradio_api/call/predict/$eventId');

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
                final prediction = jsonData[0];
                setState(() {
                  predictionResult = prediction.toString();
                  print(predictionResult);
                });
                break;
              }
            }
            break;
          }
        }
      } else {
        setState(() {
          predictionResult = 'Error: ${postResponse.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        predictionResult = 'Error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    int? divisions,
    required ValueChanged<double> onChanged,
    String? unit,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$label: ${value.toStringAsFixed(2)}${unit ?? ''}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              label: '${value.toStringAsFixed(2)}${unit ?? ''}',
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Score Predictor'),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: Colors.amber.shade50,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '💡 How to Estimate Socioeconomic Score (0.0 to 1.0):',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text('• 📶 Internet Access at Home → +0.25'),
                    Text('• 🛏️ Private Study Room → +0.25'),
                    Text('• 📚 Educational Books Available → +0.25'),
                    Text('• 💰 Income > ₹20,000/month → +0.25'),
                    SizedBox(height: 8),
                    Text(
                      'Example: Internet + Room + Books = 0.75',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),

            buildSlider(
              label: 'Economic Score',
              value: economicScore,
              min: 0,
              max: 1,
              divisions: 4,
              onChanged: (val) => setState(() => economicScore = val),
            ),
            buildSlider(
              label: 'Study Hours',
              value: studyHours,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (val) => setState(() => studyHours = val),
              unit: ' hrs',
            ),
            buildSlider(
              label: 'Sleep Hours',
              value: sleepHours,
              min: 0,
              max: 12,
              divisions: 12,
              onChanged: (val) => setState(() => sleepHours = val),
              unit: ' hrs',
            ),
            buildSlider(
              label: 'Attendance',
              value: attendance,
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: (val) => setState(() => attendance = val),
              unit: '%',
            ),
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
                    : const Icon(Icons.analytics),
                label: Text(isLoading ? 'Predicting...' : 'Predict Score'),
                onPressed: isLoading ? null : predictScore,
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
            if (predictionResult.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$predictionResult',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

          ],
        ),
      ),
    );
  }
  String getGrade(double score) {
    if (score >= 95) return 'A+';
    if (score >= 70) return 'A';
    if (score >= 50) return 'B';
    return 'Below B';
  }
  }
