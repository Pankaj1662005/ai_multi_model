import 'package:emessage/2.001email_classifier/email_classifier.dart';
import 'package:emessage/2.01_quote_gen/english_quote%20gen.dart';
import 'package:flutter/material.dart';
import 'package:emessage/0main_themes/light_mode.dart';
import 'package:emessage/2.0_grade_prediction/grade_home.dart';
import 'package:emessage/2.1_story_gen/chat_home_page.dart';
import 'package:emessage/setting_page.dart';

import '1page_auth/auth_service.dart';
import '1page_auth/login_page.dart';

class AppHome extends StatefulWidget {
  const AppHome({Key? key}) : super(key: key);

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  final UserAuthService _userAuthService = UserAuthService();

  void logout() async {
    await _userAuthService.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) =>  LoginPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.textSecondary,
        elevation: 0,
        title: const Text(
          'ML Models',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  DrawerHeader(
                    child: Icon(
                      Icons.message,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  ListTile(
                    title: const Text("H o m e"),
                    leading: const Icon(Icons.home),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    title: const Text("S e t t i n g s"),
                    leading: const Icon(Icons.settings),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingPage()),
                      );
                    },
                  ),
                ],
              ),
              ListTile(
                title: const Text("L o g o u t"),
                leading: const Icon(Icons.logout),
                onTap: logout,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
          children: [

            _buildModelCard(
              context,
              title: 'Score Prediction',
              description: 'Enter the details like study hours ,sleep and get a idea of marks.',
              icon: Icons.text_snippet,
              color: AppColors.success,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScorePredictionScreen()),
              ),
            ),
            _buildModelCard(
              context,
              title: 'Email Classifier',
              description: 'Detect if mail ir spam or not.',
              icon: Icons.email,
              color: AppColors.accent,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EmailClassifierScreen()),
              ),
            ),
            _buildModelCard(
              context,
              title: 'Be a Poet',
              description: 'Use markov chain to generate quotes.',
              icon: Icons.save_as_sharp,
              color: AppColors.warning,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuoteGeneratorScreen()),
              ),
            ),

            _buildModelCard(
              context,
              title: 'AI Story Generator',
              description: 'Just start the story, AI will finish it.',
              icon: Icons.auto_stories,
              color: AppColors.textSecondary,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatHomePage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelCard(
      BuildContext context, {
        required String title,
        required String description,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                description,
                style: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.8),
                  fontSize: 13,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textSecondary.withOpacity(0.6),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
