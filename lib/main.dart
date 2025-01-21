import 'package:data_base_project/MainApplication/Customer/Dashboard/Dashboard.dart';
import 'package:data_base_project/MainApplication/LoginSignUp/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa', 'IR'),
      ],
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
              color: Colors.black,
              fontFamily: "DanaFaNum",
              fontWeight: FontWeight.w500,
              fontSize: 17),
          bodyMedium: TextStyle(
              color: Colors.black,
              fontFamily: "DanaFaNum",
              fontWeight: FontWeight.w500,
              fontSize: 15),
          bodySmall: TextStyle(
              color: Colors.black,
              fontFamily: "DanaFaNum",
              fontWeight: FontWeight.w500,
              fontSize: 13),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: //Dashboard() 
      const LoginPage(),
    );
  }
}
