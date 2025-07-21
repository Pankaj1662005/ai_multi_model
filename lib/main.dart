import 'package:emessage/AppHome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '0main_themes/light_mode.dart';
import '2.1_story_gen/chat_home_page.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ai-Models',
      theme: LightMode,
      home: AppHome(),
    );
  }
}

