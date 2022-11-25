import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/Weidgets/post_card.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/utils/global_variabler.dart';



class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroudColor,
        centerTitle: false,
        title: Image.asset('assets/images/logo-example.jpg',
       // color: primaryColor,
        height: 50,
        ),
        actions: [
          IconButton(
            onPressed: (){},
             icon: const  Icon(
               Icons.message_outlined,
          ),
          ),
        ],
      ),
     body: StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder:( context, AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshots){
           if(snapshots.connectionState==ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
           }
          return ListView.builder(
            itemCount: snapshots.data!.docs.length,
            itemBuilder: (context,index)=> PostCard(
              snap: snapshots.data!.docs[index].data(),

            ),
            );
      },
     ),
   
        
     );
    

          
     
  }
}
  
           
     
