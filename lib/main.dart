import 'package:flutter/material.dart';
import 'package:thephonepedia/router/app_route.dart';
import 'package:provider/provider.dart';
import 'package:thephonepedia/theme/theme_notifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'ThePhonepedia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: Provider.of<ThemeNotifier>(context).themeMode,
      debugShowCheckedModeBanner: false,
    );
  }
}
