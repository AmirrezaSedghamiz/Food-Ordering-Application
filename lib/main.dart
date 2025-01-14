import 'package:data_base_project/DataHandler/DataBaseConnection.dart';
import 'package:data_base_project/DataHandler/QueryHandler.dart';
import 'package:data_base_project/GlobalWidgets/Map.dart';
import 'package:data_base_project/MainApplication/LoginSignUp/LoginPage.dart';
import 'package:data_base_project/SourceDesign/Address.dart';
import 'package:data_base_project/SourceDesign/Customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:latlong2/latlong.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // const filePath = 'assets/queries/testQuery.sql';
  // await executeQuery(filePath);
  // Customer.insertCustomer(
  //     username: 'test3',
  //     password: 'amir7007',
  //     phoneNumber: '09388556994',
  //     addressString: 'hereley',
  //     latLng: const LatLng(58, 13));
  // LoginQuery.login(username: 'amirreza', password: 'amir7007');
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
      home: const LoginPage(),
    );
  }
}
