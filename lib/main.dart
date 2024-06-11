import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled/AI1/app.dart';
import 'package:untitled/effect/ar_effect1.dart';
import 'package:untitled/effect/ar_effect2.dart';
import 'package:untitled/effect/ar_effect3.dart';
import 'package:untitled/effect/ar_effect4.dart';
import 'package:untitled/AI1/ai.dart';
import 'package:untitled/models/model_auth.dart';
import 'package:untitled/models/model_cart.dart';
import 'package:untitled/models/model_item_provider.dart';
import 'package:untitled/models/model_query.dart';
import 'package:untitled/screens/screen_index.dart';
import 'package:untitled/screens/screen_login.dart';
import 'package:untitled/screens/screen_splash.dart';
import 'package:untitled/screens/screen_register.dart';
import 'package:untitled/screens/screen_detail.dart';
import 'package:untitled/screens/screen_search.dart';
import 'package:provider/provider.dart';
import 'package:untitled/firebase_options.dart';
import 'package:untitled/tabs/tab_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseAuthProvider()),
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => SearchQuery()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AR Glasses Shop',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/index': (context) => IndexScreen(),
          '/register': (context) => RegisterScreen(),
          '/search': (context) => SearchScreen(),
          '/detail': (context) => DetailScreen(),
          '/Home': (context) => HomeTab(),
          '/effect1': (context) => AREffect1(),
          '/effect2': (context) => AREffect2(),
          '/effect3': (context) => AREffect3(),
          '/effect4': (context) => AREffect4(),
          '/MainAi': (context) => MainApp(),
        },
        initialRoute: '/',
      ),
    );
  }
}

