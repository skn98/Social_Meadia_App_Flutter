import 'package:flutter/material.dart';
import 'package:social_media_app/Weidgets/text_field_input.dart';
import 'package:social_media_app/resources/auth_methods.dart';

import 'package:social_media_app/responsive/mobile_screen_layout.dart';
import 'package:social_media_app/responsive/webscreen_layout.dart';
import 'package:social_media_app/screens/signup_screen.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/utils/utils.dart';

import '../responsive/responsive_layout.dart';

 
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
 _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool  _isLoading =false;

@override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

void loginUser()async{
  setState(() {
    _isLoading=true;
  });
 
  String res =await AuthMethod().loginUser(
    email: _emailController.text, 
    password: _passwordController.text,
    );
    if(res== "scuccess"){
         //  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const HomeScreen()));
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
         Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context)=> const ResponsiveLayout(
               WebScreenLayout: WebScreenLayout(),
               mobileScreenLayout: MobileScreenLayout(),
               ),
               ),
           );
    }else{
      showSnackBar(res, context);
    }
    setState(() {
    _isLoading=false;
  });
}

void navigateToSgnup(){
   Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => const SignupScreen(),
    ),
    );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
      child: Container(
         padding: const EdgeInsets.symmetric(horizontal: 32),
         width: double.infinity,
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           
          children: [
            Flexible(child: Container(), flex: 2),
            //image
            
            Image(image: AssetImage('assets/images/logo-example.jpg'), height: 70,),
            const SizedBox(height: 64),
 
            //email text input
            TextFieldInput(
               hintText: "Enter Your email",
               textInputType: TextInputType.emailAddress,
               textEditingController: _emailController,
               ),
               const SizedBox(height: 25),
            //password text input
            TextFieldInput(
               hintText: "Enter Your password", 
               textInputType: TextInputType.text,
               textEditingController: _passwordController,
               ispass: true,
               ),
               const SizedBox(height: 25),
            //logim btn
            InkWell(
              onTap: loginUser,
              child: Container(
                child: _isLoading?  
                const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                  ) 
                  :const Text("Log in"),
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    )
                  ),
                   color: blueColor
                  ),
              ),
            ),
            const SizedBox(height: 12,),
             Flexible(child: Container(), flex: 2),
            // move to singnup form
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Container(
                  child: const Text("Don't have an account? "),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8
                    ),
                 ),
                 GestureDetector(
                  onTap: navigateToSgnup,
                   child: Container(
                    child:  const Text(
                      "Sign Up",
                       style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                     padding: const EdgeInsets.symmetric(
                      vertical: 8
                      ),
                   ),
                 ),
              ],
            ),
          ],
         ),
      ),
      ),
    );
  }
}