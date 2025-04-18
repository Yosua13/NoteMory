import 'package:flutter/material.dart';
import 'package:note_mory/presentation/onboarding.dart';
import 'package:note_mory/providers/note_provider.dart';
import 'package:note_mory/providers/user_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userProvider = UserProvider();
  await userProvider.loadUser();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>.value(value: userProvider),
        ChangeNotifierProxyProvider<UserProvider, NoteProvider>(
          create: (context) => NoteProvider(userProvider: userProvider),
          update: (context, userProvider, previous) =>
              NoteProvider(userProvider: userProvider),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
      ),
      debugShowCheckedModeBanner: false,
      home: const Onboarding(),
    );
  }
}
