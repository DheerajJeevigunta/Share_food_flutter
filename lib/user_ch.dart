




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:provider/provider.dart';
import 'package:share_food/address.dart';
import 'package:share_food/chat.dart';
import 'package:share_food/circle_transition.dart';
import 'package:share_food/developes.dart';
// import 'package:share_food/home_screen.dart';
import 'package:share_food/nearby.dart';
import 'package:share_food/ngo_ch.dart';
import 'package:share_food/posts.dart';
import 'package:share_food/services/authprovider.dart';
import 'package:share_food/services/database.dart';
import 'package:share_food/services/auth.dart';
import 'package:share_food/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCh extends StatefulWidget {
  const UserCh({Key? key}) : super(key: key);

  @override
  _UserChState createState() => _UserChState();
}

class _UserChState extends State<UserCh> with TickerProviderStateMixin {
   final _formKey = GlobalKey<FormState>();
     String name = '',mobile='',items='',address='';
     final _namecontroller= TextEditingController();
     final _itemcontroller= TextEditingController();
     final _mobilecontroller= TextEditingController();
     final _addresscontroller= TextEditingController();
     void _donate(){
       final getName=_namecontroller.text;
       final getitems=_itemcontroller.text;
       final getmobile= _mobilecontroller.text;
       final getaddress=_addresscontroller.text;
       FirebaseFirestore.instance.collection("Donations")
       .add(
         {
            "name":getName,
            "items":getitems,
            "mobile":getmobile,
            "address":getaddress,
            "created at":DateTime.now(),
         }
       );
       _namecontroller.clear();
       _itemcontroller.clear();
       _mobilecontroller.clear();
       _addresscontroller.clear();
        Navigator.of(context).push(MaterialPageRoute( builder: (context) => Posts()));
       Fluttertoast.showToast(msg: "Posted Succesfully");

     }
    @override
    Widget build(BuildContext context){
      Size size=MediaQuery.of(context).size;
      return Scaffold(
        body: GestureDetector(
          onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //    builder: (context) => Developers()));
                         },
                         child: Container(
                           child: Stack(
         children: <Widget>[
              ShaderMask(
          shaderCallback: (rect) => LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.center,
            colors: [Colors.black, Colors.transparent],
          ).createShader(rect),
          blendMode: BlendMode.darken,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/register_bg.png'),
                    fit: BoxFit.cover,
                    colorFilter:
                        ColorFilter.mode(Colors.black54, BlendMode.darken))),
          ),
        ),
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(1.0, 50.0, 30.0, 20.0),
                    height: 64,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                            radius: size.width*0.15,
                            
                            backgroundColor: Colors.grey[500],
                            backgroundImage: NetworkImage(
                                'https://image.pngaaa.com/346/1956346-middle.png',
                                )
                            // new AssetImage('assets/images/avatar_.png'),
                
                            ),
                        SizedBox(
                          width: 1,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Share Food ',
                              style: TextStyle(
                                color: Colors.amber,
                                  height: 2.05,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold),
                            )
                            //     Text('Share-Food',style:TextStyle(fontSize: 40 ,height: 3.75,fontStyle:FontStyle.italic,fontWeight:FontWeight.bold  ),)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
          Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 35, top: 160, right: 35),
                  child: Center(
                    child: Text('Donate',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 60,
                            fontFamily: 'Nunito regular')),
                  ),
                ),
                SizedBox(height: 20,),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(left: 35, right: 35),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16)),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _namecontroller,
                              validator: (name) {
                                if (name == null || name.isEmpty)
                                  return 'Donar Name is required';
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.grey[500]!.withOpacity(0.5),
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(color: Colors.black)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.white)),
                                hintText: 'Enter Donar Name...',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onChanged: (val) {
                                setState(() => name = val);
                              },
                            ),
                            SizedBox(height: 13,),
                            TextFormField(
                              controller: _itemcontroller,
                              validator: (items) {
                                if (items == null || items.isEmpty)
                                  return 'Required to fill';
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.grey[500]!.withOpacity(0.5),
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.dinner_dining,
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(color: Colors.black)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.white)),
                                hintText: 'Specify Food Items...',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onChanged: (val) {
                                setState(() => items = val);
                              },
                            ),
                            SizedBox(height: 13,),
                            TextFormField(
                              controller: _mobilecontroller,
                              validator: (mobile) {
                                if (mobile == null || mobile.isEmpty)
                                  return 'Mobile Number is required';
                                  String counnt = r'^.{10}';
                                RegExp regExp = RegExp(counnt);
                                if (!regExp.hasMatch(mobile))
                                  return '''Length Mobile Number must be more than 10  ''';
                                String pattren = r'[0-9]';
                                RegExp regExp1 = RegExp(pattren);
                                if (!regExp1.hasMatch(mobile))
                                  return '''Mobile Number  must be only Numbers''';
          
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.grey[500]!.withOpacity(0.5),
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.phone_android,
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(color: Colors.black)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.white)),
                                hintText: 'Enter your Mobile Number...',
                               
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              onChanged: (val) {
                                setState(() => mobile = val);
                              },
                            ),
                            SizedBox(height: 13,),
                            TextFormField(
                              controller: _addresscontroller,
                              validator: (address) {
                                if (address == null || address.isEmpty)
                                  return 'Address Required to fill';
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.grey[500]!.withOpacity(0.5),
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(color: Colors.black)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.white)),
                                hintText: 'Type Your Address...',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              
                              onChanged: (val) {
                                setState(() => address = val);
                              },
                            ),
                   
                              SizedBox(height: 10,),
                              ButtonTheme(
                                 minWidth: 190.0,
                                  height: 50.0,
                                child: RaisedButton(
                                  textColor: Colors.black,
                                  color: Colors.blueAccent[100],
                                  child: Text("Donate",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()){
                                    _donate();}
                                  },
                                  shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(16.0),
                                  ),
                                ),
                              ),
                              
                                      SizedBox(height: 10,) ,
                              Padding(
                                padding:  EdgeInsets.only(left:172,top: 80),
                                child: ButtonTheme(
                                   minWidth: 150.0,
                                    height: 50.0,
                                  child: RaisedButton(
                                    textColor: Colors.black,
                                    
                                    color: Colors.limeAccent,
                                    child: Text("Request Food",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                    onPressed: () {
                                     Navigator.of(context).push(MaterialPageRoute( builder: (context) => NgoCh ()));
                                    },
                                    shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(16.0),
                                    ),
                                  ),
                                ),
                              )
          
                            
                          ],
                          
                        ),
                      
                    ),
                    
                  )
                )
              ]
            ),
          )
          ),
           ]  )
                         )
          )


      );
        
        
        
  }
}

