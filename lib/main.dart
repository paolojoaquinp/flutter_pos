import 'package:flutter/material.dart';
import 'package:flutter_pos/features/shared/app_shell/presentation/app_shell.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      routes: {
        AppShell.route: (_) => const AppShell(),
        // ListProductsScreen.route: (_) => ListProductsScreen(),
      },
    );
  }
}
