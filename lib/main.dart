import 'package:fiqah/presentation/screen/auth/login_screen.dart';
import 'package:fiqah/presentation/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: FiqihPernikahanApp(),
    ),
  );
}

class FiqihPernikahanApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Fiqih Pernikahan',
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: themeMode,
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      primarySwatch: Colors.green,
      primaryColor: Colors.green[700],
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.grey[50],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green[700]),
        titleTextStyle: TextStyle(
          color: Colors.green[700],
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      primarySwatch: Colors.green,
      primaryColor: Colors.green[400],
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green[400]),
        titleTextStyle: TextStyle(
          color: Colors.green[400],
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
