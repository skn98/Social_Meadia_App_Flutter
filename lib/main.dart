import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/providers/user_provider.dart';
import 'package:social_media_app/responsive/mobile_screen_layout.dart';
import 'package:social_media_app/responsive/responsive_layout.dart';
import 'package:social_media_app/responsive/webscreen_layout.dart';
import 'package:social_media_app/screens/login_screen.dart';
import 'package:social_media_app/screens/signup_screen.dart';
import 'package:social_media_app/utils/colors.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
         apiKey: 'AIzaSyCP0ExTkdUdsQPygoBmlVW3GtuyK60u1uM',
         appId: '1:390089686843:web:6e4f0aaccf80fdd955811e', 
         messagingSenderId: '390089686843', 
         projectId: 'social-meadia-app-db',
         storageBucket: "social-meadia-app-db.appspot.com",
         ),
    );

  }else{
  await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
          ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroudColor,
        ),

         home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.hasData){
              return const ResponsiveLayout(
                WebScreenLayout: WebScreenLayout(),
                 mobileScreenLayout: MobileScreenLayout(),
               );
              }else if(snapshot.hasError){
                return Center(child: Text('${snapshot.error}'),
                );
              }
            }
            if(snapshot.connectionState== ConnectionState.waiting){
               return const Center(
                child: CircularProgressIndicator(
                    color: primaryColor,
                )
               );
            }
           
           return const LoginScreen();

          

          },
         ),
      ),
    );
  }
}

