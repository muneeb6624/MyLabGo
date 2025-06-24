import 'package:flutter/material.dart';
import 'package:mylab_go/screens/registration.dart';
import 'package:mylab_go/screens/registration_camera.dart';
import 'package:mylab_go/screens/login_camera.dart';
import 'package:mylab_go/screens/home.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mylab_go/l10n/l10n.dart';
import 'package:provider/provider.dart';
import 'package:mylab_go/provider/locale_provider.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import './firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Lab Go!',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.lightBlue).copyWith(
          secondary: Colors.lightBlueAccent,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      supportedLocales: L10n.supportedLocales,
      locale: provider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: {
       // '/': (_) => const RegistrationPage(),
        '/face-register': (_) => const FaceRegisterPage(),
        '/face-login': (_) => const FaceLoginPage(),
        '/home': (_) => const HomePage(),
      },
      home: const GradientBackground(
        child: RegistrationPage(),
      ),
    );
  }
}

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFFDFEFF),
            Color(0xFFDFF6F9),
          ],
        ),
      ),
      child: child,
    );
  }
}
