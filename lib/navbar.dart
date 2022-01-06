import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:share_food/chat.dart';
import 'package:share_food/postr.dart';
import 'package:share_food/posts.dart';
import 'package:share_food/settings.dart';
import 'package:share_food/user_ch.dart';
import 'package:share_food/nearby.dart';
// import 'package:share_food/profile.dart';


import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Navbar extends StatefulWidget {
  const Navbar({ Key? key }) : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  
  final Navkey =GlobalKey<CurvedNavigationBarState>();

  int index=2;
 final List <Widget> _children =[
   UserCh(),
   Nearby(),
   
   Chat(),
   
   Posts(),
   Postr()
   
   
 ];
 
  @override
  Widget build(BuildContext context) {
    final items =<Widget>[
        ImageIcon(AssetImage('assets/images/home_fill.png'),size: 30, color: Colors.black,),
        ImageIcon(AssetImage('assets/images/near_fill.png'),size: 30,color: Colors.black),
        ImageIcon(AssetImage('assets/images/user_fill.png'),size: 30,color: Colors.black),
        ImageIcon(AssetImage('assets/images/give.png'),size: 30,color: Colors.black),
        ImageIcon(AssetImage('assets/images/request.png'),size: 30,color: Colors.black),
    ];
    var size = MediaQuery.of(context).size;
    return Container(
      color:Colors.white,
      child: SafeArea(
        top: false,
        child: ClipRect(
          child: Scaffold(
            extendBody: true,
              backgroundColor: Colors.grey.shade900,
              body: _children[ index],

                bottomNavigationBar: CurvedNavigationBar(
                items: items,
                key:Navkey,
                animationCurve: Curves.easeInOut,
                animationDuration: Duration(milliseconds:300),
                buttonBackgroundColor:Colors.blue,
                index: index,
                backgroundColor: Colors.transparent,
              
              height: 50,
              
            onTap:  (index)=>setState(()=>this.index=index),
              
              )
              ),
          )
          )
      );
    
  }
}