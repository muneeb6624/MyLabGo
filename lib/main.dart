import 'package:flutter/material.dart';
import 'package:mylab_go/screens/registration.dart';
import 'package:mylab_go/screens/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mylab_go/l10n/l10n.dart';
import 'package:provider/provider.dart';
import 'package:mylab_go/provider/locale_provider.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
        scaffoldBackgroundColor:
            Colors.transparent, // Set scaffold background to transparent
      ),
      supportedLocales: L10n.supportedLocales,
      locale: provider.locale, // ✅ Now it listens to changes,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const GradientBackground(
          child: RegistrationPage()), // Start with the registration page
    );
  }
}

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFFDFEFF), // Color Gradient left
            Color(0xFFDFF6F9), // Right
          ],
        ),
      ),
      child: child,
    );
  }
}
