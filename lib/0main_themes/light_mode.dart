import 'package:flutter/material.dart';

ThemeData LightMode = ThemeData(
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade300,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade200,
    tertiary: Colors.white,
    inversePrimary: Colors.grey.shade900,
  ),
);

class AppColors {
  static const Color primary = Color(0xF0000000); // Blue button
  static const Color background = Color(0xFFFFFFFF); // White background
  static const Color cardBackground = Color(0xFFF8F8F8); // Softer card grey
  static const Color textPrimary = Color(0xFF1F486D); // Dark grey text
  static const Color textSecondary = Color(0xFF8E8E93); // Lighter grey text
  static const Color accent = Color(0xFF007AFF); // iOS system blue


  // Additional colors for enhanced functionality
  static const Color success = Color(0xFF34C759); // iOS Green
  static const Color error = Color(0xFFFF3B30); // iOS Red
  static const Color warning = Color(0xFFFF9500); // iOS Orange
  static const Color info = Color(0xFF5AC8FA); // iOS Light Blue
  static const Color surface = Color(0xFFF2F2F7); // iOS Light Grey
  static const Color divider = Color(0xFFE5E5EA); // iOS Separator
  static const Color disabled = Color(0xFFC7C7CC); // iOS Disabled
  static const Color overlay = Color(0x80000000); // Semi-transparent overlay
}

class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AppColors.textPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle sectionHeader = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.2,
  );


  // Additional text styles
  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 1.2,
  );

  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle error = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.error,
  );

  static const TextStyle link = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.accent,
    decoration: TextDecoration.underline,
  );
}

class AppButtonStyles {
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: AppColors.primary,
    textStyle: AppTextStyles.button,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    minimumSize: const Size(double.infinity, 52),
    elevation: 0,
  );

  static ButtonStyle secondaryButton = ElevatedButton.styleFrom(
    foregroundColor: AppColors.primary,
    backgroundColor: Colors.white,
    textStyle: AppTextStyles.button,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    minimumSize: const Size(double.infinity, 52),
    elevation: 0,
  );

  // Additional button styles
  static ButtonStyle outlineButton = OutlinedButton.styleFrom(
    foregroundColor: AppColors.primary,
    textStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    side: const BorderSide(color: AppColors.primary, width: 1.5),
    minimumSize: const Size(double.infinity, 52),
  );

  static ButtonStyle textButton = TextButton.styleFrom(
    foregroundColor: AppColors.primary,
    textStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    minimumSize: const Size(double.infinity, 52),
  );

  static ButtonStyle dangerButton = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: AppColors.error,
    textStyle: AppTextStyles.button,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    minimumSize: const Size(double.infinity, 52),
    elevation: 0,
  );

  static ButtonStyle successButton = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: AppColors.success,
    textStyle: AppTextStyles.button,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    minimumSize: const Size(double.infinity, 52),
    elevation: 0,
  );

  static ButtonStyle smallButton = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: AppColors.primary,
    textStyle: AppTextStyles.button.copyWith(fontSize: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    minimumSize: const Size(120, 36),
    elevation: 0,
  );
}

class AppPadding {
  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 16);
  static const EdgeInsets cardPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 14);
  static const EdgeInsets sectionSpacing = EdgeInsets.only(top: 32);

  // Additional padding options
  static const EdgeInsets listItemPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static const EdgeInsets inputPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static const EdgeInsets buttonPadding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 12);
  static const EdgeInsets modalPadding = EdgeInsets.all(24);
  static const EdgeInsets dialogPadding = EdgeInsets.all(20);
  static const EdgeInsets chipPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 6);
}

class AppDecorations {
  static BoxDecoration card = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration statusChip(Color color) => BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      );

  // Additional decorations
  static BoxDecoration inputDecoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppColors.divider, width: 1),
  );

  static BoxDecoration focusedInputDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppColors.primary, width: 2),
  );

  static BoxDecoration errorInputDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppColors.error, width: 2),
  );

  static BoxDecoration bottomSheet = BoxDecoration(
    color: Colors.white,
    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
        offset: Offset(0, -5),
      ),
    ],
  );

  static BoxDecoration dialog = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration badge = BoxDecoration(
    color: AppColors.error,
    borderRadius: BorderRadius.circular(10),
  );
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class AppSizes {
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  static const double buttonHeight = 52.0;
  static const double inputHeight = 48.0;
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 60.0;

  static const double borderRadius = 12.0;
  static const double cardRadius = 16.0;
  static const double chipRadius = 6.0;
}

class AppAnimations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
}

class AppInputDecorations {
  static InputDecoration textField({
    String? hintText,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool isError = false,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: isError ? AppColors.error.withOpacity(0.1) : AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        borderSide: BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        borderSide: BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: AppPadding.inputPadding,
      hintStyle: AppTextStyles.body,
      labelStyle: AppTextStyles.label,
      errorStyle: AppTextStyles.error,
    );
  }
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'SF Pro Text', // Use system font for iOS feel
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.title,
        headlineLarge: AppTextStyles.headline,
        headlineMedium: AppTextStyles.sectionHeader,
        bodyLarge: AppTextStyles.subtitle,
        bodyMedium: AppTextStyles.body,
        labelLarge: AppTextStyles.button,
        bodySmall: AppTextStyles.caption,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppButtonStyles.primaryButton,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: AppButtonStyles.outlineButton,
      ),
      textButtonTheme: TextButtonThemeData(
        style: AppButtonStyles.textButton,
      ),
      cardTheme: CardTheme(
        color: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        ),
        elevation: 2,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.sectionHeader,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
    );
  }
}
