//@dart =2.9//
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:share_food/datahandler/appdata.dart';
import 'package:share_food/navbar.dart';
import 'package:share_food/nearby.dart';

// import 'package:share_food/home_screen.dart';
import 'package:share_food/models/user.dart';

// import 'package:share_food/services/auth.dart';
import 'package:share_food/services/authprovider.dart';
import 'package:share_food/services/chat_provider.dart';
import 'package:share_food/services/home_provider.dart';
import 'package:share_food/services/setting_provider.dart';
import 'package:share_food/splash_screen.dart';
import 'package:share_food/user_ch.dart';
// import 'package:share_food/wrapper.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isWhite =false;

void main() async {
  // HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs =await SharedPreferences.getInstance();
  runApp(MyApp(prefs:prefs));
  SystemChrome.setSystemUIOverlayStyle(
    // ignore: prefer_const_constructors
    SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent),
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore =FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage =FirebaseStorage.instance;
  MyApp({required this.prefs});



  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context)=> AppData(),
      child: MultiProvider(
       
        providers:[
          ChangeNotifierProvider<Authprovider>(
            create: (_) => Authprovider(firebaseAuth: FirebaseAuth.instance, firebaseFirestore: this.firebaseFirestore, prefs:this. prefs
            ,googleSignIn: GoogleSignIn())
            
            ),
    
    
    
                Provider<SettingProvider>(
                  create:(_)=> SettingProvider(
                    prefs: this.prefs, 
                  firebaseFirestore: this.firebaseFirestore, 
                  firebaseStorage: this.firebaseStorage
                  )
                ),
                Provider<HomeProvider>(
                  create:(_)=>HomeProvider(firebaseFirestore: this.firebaseFirestore)
                  ),
    
                  Provider<ChatProvider>(
                    create: (_)=> ChatProvider(
                      firebaseFirestore:this. firebaseFirestore, 
                      prefs:this. prefs, 
                      firebaseStorage:this. firebaseStorage)
                    )
        ],
               child: MaterialApp(
              theme: ThemeData(
                  appBarTheme: AppBarTheme(
                    color: Colors.transparent,
                    elevation: 0,
                    systemOverlayStyle: (SystemUiOverlayStyle.dark),
                    iconTheme: IconThemeData(color: Colors.black, size: 20),
                  ),
                  fontFamily: "Nunito Regular"),
              debugShowCheckedModeBanner: false,
              home: SplashScreen() ),
      ),
    );
  }
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }
