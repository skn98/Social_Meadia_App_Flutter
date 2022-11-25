

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/utils/global_variabler.dart';


class  MobileScreenLayout extends StatefulWidget {
  const  MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State< MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State< MobileScreenLayout> {
  int _page =0; 
  late PageController pageController; 

  @override
  void initState() {
    super.initState();
    pageController =PageController();
  }
   
   @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
  
  void navigationTapped(int page){
     pageController.jumpToPage(page);

  }
  void onPageChanged(int page){
    setState(() {
      _page =page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
         children: homeScreenItems,
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: onPageChanged,
      ),
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: mobileBackgroudColor,
          items: [ 
              //home 
            BottomNavigationBarItem(
              icon: Icon(Icons.home ,
               color: _page==0? primaryColor: secondaryColr,
               ),
               label: '', 
               backgroundColor: primaryColor,
               ),

             //search
            BottomNavigationBarItem(
              icon: Icon(Icons.search,
              color: _page==1? primaryColor: secondaryColr
              ),
               label: '', 
               backgroundColor: primaryColor,
               ),

               // add item circle
             
               BottomNavigationBarItem(
              icon: Icon(Icons.add_circle, color: _page==2? primaryColor: secondaryColr),
               label: '', 
               backgroundColor: primaryColor,
               ),
               //favourite
               BottomNavigationBarItem(
              icon: Icon(Icons.favorite,color: _page==3? primaryColor: secondaryColr),
               label: '', 
               backgroundColor: primaryColor,
               ),
               //person
               BottomNavigationBarItem(
              icon: Icon(Icons.person,color: _page==4? primaryColor: secondaryColr),
               label: '', 
               backgroundColor: primaryColor,
               ),
          ],
          onTap: navigationTapped,
          ),
    );
  }
}