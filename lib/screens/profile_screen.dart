

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/Weidgets/follow_btn.dart';
import 'package:social_media_app/resources/auth_methods.dart';
import 'package:social_media_app/resources/firebase_method.dart';
import 'package:social_media_app/screens/login_screen.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/utils/utils.dart';



class ProfileScreen extends StatefulWidget {
  final String uid;
 
  const ProfileScreen({Key? key, required this .uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData ={};
  int postLen =0;
  int followers=0;
  int following= 0;
  bool isFollowing =false;
  bool isLoading= false;


  @override
  void initState() {
    super.initState();
    getData();
    
    
  }


getData()async{
  setState(() {
    isLoading=true;
  });
  try{
   var usersnap = await FirebaseFirestore.instance
   .collection('Users')
   .doc(widget.uid)
   .get();

   // get posts
   var  postsnap =await FirebaseFirestore.instance
    .collection('posts')
    .where('uid',isEqualTo: FirebaseAuth.instance.currentUser!.uid ) .get();
    postLen=postsnap.docs.length;
   userData = usersnap.data()!;
   followers =usersnap.data()!['followers'].length;
   following = usersnap.data()!['following'].length;
   isFollowing =usersnap.data()!['followers'].contains(FirebaseAuth.instance.currentUser!.uid);

   setState(() {});

  }catch(e){
   //showSnackBar(context, e.toString(),),
  }
  setState(() {
    isLoading=false;
  });
}
  @override
 


  @override
  Widget build(BuildContext context) {
    
    return isLoading? const Center(child: CircularProgressIndicator(),):
     Scaffold(
          appBar: AppBar(
            backgroundColor: mobileBackgroudColor,
            title: Text(userData['username'],),
            centerTitle: false,
          ),
          body: ListView(
             children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                   children: [
                    Row(
                      children: [
                        CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                            userData['photoUrl'],
                        ),
                        radius: 36,
                        ),
                       Expanded(
                         flex: 1,
                         child: Column(
                           children: [
                             Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildStateColumn(postLen, "posts"),
                                buildStateColumn(followers, "followers"),
                                buildStateColumn(following, "followeing"),
                              ],
                             ),
                             

                       Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                           FirebaseAuth.instance.currentUser!.uid== widget.uid? FollowButton(
                              text: 'Sign out',
                              backgroundColor: mobileBackgroudColor,
                              textColor: primaryColor,
                              borderColor: Colors.grey,
                              
                              function: () async{
                                 await AuthMethod().signOut();
                                 Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>const LoginScreen(),),);
                              },
                            ):isFollowing ?FollowButton(
                              text: 'Unfollow',
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              borderColor: Colors.grey,
                              function: () async{
                                 await FirestoreMethodes()
                                  .followUser(
                                    FirebaseAuth.instance
                                     .currentUser!.uid,
                                     userData['uid'],
                                  );
                                  setState(() {
                                     isFollowing=false;
                                     followers--; 
                                  });
                              },


                            ):FollowButton(
                              text: 'follow',
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              borderColor: Colors.blue,
                              function: ()async{
                                 await FirestoreMethodes()
                                  .followUser(
                                    FirebaseAuth.instance
                                     .currentUser!.uid,
                                     userData['uid'],

                                    
                                  );
                                  setState(() {
                                    isFollowing=true;
                                    followers++;
                                  });
                              },
                            )
                          ],
                       ),
                           ],
                         ),
                       
                       ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding:  const EdgeInsets.only(top:1,),
                      child: Text(
                         userData['username'],
                         style: TextStyle(
                          fontWeight: FontWeight.bold,
                         ),
                      ),
                    ),
                     Container(
                      alignment: Alignment.centerLeft,
                      padding:  const EdgeInsets.only(top:15,),
                      child: Text(
                        userData ['bio'],
                         
                      ),
                    ),
                   ],
                ),
              ),
             const Divider(),
             FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').where('uid',isEqualTo: widget.uid).get(),
              builder: (context, snapshot){
                   if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(
                      child: CircularProgressIndicator(),
                      );
                   }
                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: (snapshot.data! as dynamic).docs.length ,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, 
                     crossAxisSpacing: 5,
                     mainAxisSpacing: 1.5,
                     childAspectRatio: 1,
                     ), 

                     itemBuilder: (context, index){
                        DocumentSnapshot snap  = (snapshot.data! as dynamic).docs[index];
                        return Container(
                          child: Image(
                            image:NetworkImage(
                              (snap.data()!as dynamic)['postUrl']
                            ),
                            fit: BoxFit.cover,
                             ),
                        );
                     },
                    );
              },
              )
              
             ],
          ),
    );
    
  }
Column buildStateColumn(int num, String label){
return Column(
  mainAxisSize: MainAxisSize.min,
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    
    Text(
      num.toString(),
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        
      ),
    ),
    Container(
      margin: const EdgeInsets.only(top: 4),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
          
        ),
      ),
    ),
     
  ],
);
}

}


