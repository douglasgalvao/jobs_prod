import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_jobs/firebase_options.dart';
import 'package:my_jobs/infrastructure/chat/pusher_service.dart';
import 'package:my_jobs/presentation/constants/app_colors.dart';
import 'package:my_jobs/presentation/screens/chat/my_chat_page.dart';
import 'package:my_jobs/presentation/screens/home/index.dart';
import 'package:my_jobs/presentation/screens/login/login_screen.dart';
import 'package:my_jobs/presentation/screens/preloader/preloader_screen.dart';
import 'package:my_jobs/presentation/screens/lottie/lottie_screen.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );



  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          accentColor: AppColors.primaryColor,
        ),
      ),
      title: 'Student Jobs Mobile',
      initialRoute: '/',
      routes: {
        '/': (context) => const PreloaderScreen(),
        '/lottie': (context) => const LottieScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomePage(),
        '/chat': (context) => MyChatPage(),
      },
    );
  }
}