import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:my_wallpapers/pages/main_page.dart';
import 'package:my_wallpapers/utils/utils.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Phoenix(child: const MyApp()));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      title: 'MyWallpapers',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(primaryColor: Colors.white),
      home: Scaffold(
        body: MainPage(),
      ),
      // home:const Home(),
    );
  }
}
