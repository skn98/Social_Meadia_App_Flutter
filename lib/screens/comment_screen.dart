import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/Weidgets/comment_card.dart';
import 'package:social_media_app/providers/user_provider.dart';
import 'package:social_media_app/resources/firebase_method.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/user.dart';

class CommentScreen extends StatefulWidget {
  final snap;

  const CommentScreen({Key? key, required this.snap,}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final  TextEditingController _commentController =TextEditingController();
  
  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }
  @override
  Widget build(BuildContext context) {

    final User user =Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroudColor,
        title: const Text('comments'),
      ),

      //body comment card
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.
        collection('posts')
        .doc(widget.snap['postId'])
        .collection('comments')
        .orderBy('datePublished', descending: true,)
        .snapshots(),
        builder: (context, snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
               return const Center(
                child: CircularProgressIndicator(),
               );
            }
            return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context,index)=>CommentCard(
                    snap:(snapshot.data!as dynamic).docs[index].data(),
              ), 
            
            );
        },
      ),


       bottomNavigationBar: SafeArea(
        child: Container(
         height: kToolbarHeight,  
         margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,
         ),
         padding: const EdgeInsets.only(left: 16 ,right:8),
         child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user.photoUrl,
                  ),
                maxRadius: 18,
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left:16 , right:8.0),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'comment as ${user.username}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              /////
                   InkWell(
                onTap: () async {
                  await FirestoreMethodes().postComment(
                    widget.snap['postId'],
                    _commentController.text,
                    user.uid,
                    user.username,
                    user.photoUrl,
                  );
                  setState(() {
                    _commentController.text="";
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                   style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
            
         ),
        ),
       ),
    );
            

    
    
    
  }
}






