import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'chat_home_page.dart';

class ChatService {
  static const String _baseUrl = 'https://pankaj2005-ai-story-generator.hf.space/gradio_api/call';
  static const String _chatEndpoint = '/chatbot_interface';

  // Convert ChatMessage list to API format
  List<Map<String, dynamic>> _convertMessagesToApiFormat(List<ChatMessage> messages) {
    return messages.map((message) {
      return {
        "role": message.isUser ? "user" : "assistant",
        "metadata": null,
        "content": message.message,
        "options": null,
      };
    }).toList();
  }

  Future<String> sendMessage(String message, List<ChatMessage> chatHistory) async {
    try {
      // Convert chat history to API format
      final apiChatHistory = _convertMessagesToApiFormat(chatHistory);

      // Step 1: Make POST request to initiate the chat
      final postResponse = await _makePostRequest(message, apiChatHistory);

      if (postResponse['success']) {
        final eventId = postResponse['event_id'];

        // Step 2: Make GET request to fetch the result
        final getResponse = await _makeGetRequest(eventId);

        if (getResponse['success']) {
          return getResponse['message'];
        } else {
          throw Exception('Failed to get response: ${getResponse['error']}');
        }
      } else {
        throw Exception('Failed to send message: ${postResponse['error']}');
      }
    } catch (e) {
      print('Error in sendMessage: $e');
      throw Exception('Failed to send message: $e');
    }
  }

  Future<Map<String, dynamic>> _makePostRequest(String message, List<Map<String, dynamic>> chatHistory) async {
    try {
      final url = Uri.parse('$_baseUrl$_chatEndpoint');

      final requestBody = {
        "data": [
          message,
          chatHistory
        ]
      };

      print('Sending POST request to: $url');
      print('Request body: ${json.encode(requestBody)}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      ).timeout(const Duration(seconds: 30));

      print('POST Response status: ${response.statusCode}');
      print('POST Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Extract event_id from response
        final eventId = responseData['event_id'];

        if (eventId != null) {
          return {
            'success': true,
            'event_id': eventId,
          };
        } else {
          return {
            'success': false,
            'error': 'No event_id received from server',
          };
        }
      } else {
        return {
          'success': false,
          'error': 'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        };
      }
    } on SocketException {
      return {
        'success': false,
        'error': 'No internet connection',
      };
    } on HttpException {
      return {
        'success': false,
        'error': 'HTTP error occurred',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Unexpected error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> _makeGetRequest(String eventId) async {
    try {
      final url = Uri.parse('$_baseUrl$_chatEndpoint/$eventId');

      print('Sending GET request to: $url');

      // Use a client that can handle streaming
      final client = http.Client();

      try {
        final request = http.Request('GET', url);
        final streamedResponse = await client.send(request);

        print('GET Response status: ${streamedResponse.statusCode}');

        if (streamedResponse.statusCode == 200) {
          final completer = Completer<Map<String, dynamic>>();
          String buffer = '';

          streamedResponse.stream.transform(utf8.decoder).listen(
                (chunk) {
              buffer += chunk;
              print('Received chunk: $chunk');

              // Process complete lines
              while (buffer.contains('\n')) {
                final lineEndIndex = buffer.indexOf('\n');
                final line = buffer.substring(0, lineEndIndex);
                buffer = buffer.substring(lineEndIndex + 1);

                if (line.startsWith('data: ')) {
                  final dataContent = line.substring(6);
                  print('Processing data: $dataContent');

                  if (dataContent.trim().isNotEmpty && dataContent != '[DONE]') {
                    try {
                      final data = json.decode(dataContent);

                      if (data is List && data.length >= 2) {
                        final chatHistory = data[0];
                        if (chatHistory is List && chatHistory.isNotEmpty) {
                          final lastMessage = chatHistory.last;
                          if (lastMessage is Map && lastMessage.containsKey('content')) {
                            String botResponse = lastMessage['content'].toString();

                            if (!completer.isCompleted) {
                              completer.complete({
                                'success': true,
                                'message': botResponse,
                              });
                            }
                            return;
                          }
                        }
                      }
                    } catch (e) {
                      print('JSON parsing error: $e');
                    }
                  }
                }
              }
            },
            onDone: () {
              if (!completer.isCompleted) {
                completer.complete({
                  'success': false,
                  'error': 'Stream ended without valid response',
                });
              }
            },
            onError: (error) {
              if (!completer.isCompleted) {
                completer.complete({
                  'success': false,
                  'error': 'Stream error: $error',
                });
              }
            },
          );

          // Wait for response with timeout
          return await completer.future.timeout(
            const Duration(seconds: 120),
            onTimeout: () => {
              'success': false,
              'error': 'Timeout waiting for AI response',
            },
          );
        } else {
          return {
            'success': false,
            'error': 'HTTP ${streamedResponse.statusCode}: ${streamedResponse.reasonPhrase}',
          };
        }
      } finally {
        client.close();
      }

    } on SocketException {
      return {
        'success': false,
        'error': 'No internet connection',
      };
    } on HttpException {
      return {
        'success': false,
        'error': 'HTTP error occurred',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Unexpected error: $e',
      };
    }
  }
}